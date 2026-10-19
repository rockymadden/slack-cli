#!/usr/bin/env bats

load suite

USERS_PAGE_1='{"ok":true,"members":[{"id":"U001","name":"alice","profile":{"display_name":"Alice"}}],"response_metadata":{"next_cursor":"page2"}}'
USERS_PAGE_2='{"ok":true,"members":[{"id":"U002","name":"jason","profile":{"display_name":"Jason"}}],"response_metadata":{"next_cursor":""}}'

# --- token handling ---------------------------------------------------------------------------

@test 'token never appears in curl argv' {
  slk presence away
  ! grep -qF "${TOKEN}" <(jq -c '.argv' "${SHIM_DIR}/calls")
}

@test 'token is sent as a bearer header through curl config on stdin' {
  slk presence away
  [ "$(jq -r '.config' "${SHIM_DIR}/calls")" = "header = \"Authorization: Bearer ${TOKEN}\"" ]
}

@test '--trace does not print the token' {
  run slk presence away --trace
  [[ "${output}" != *"${TOKEN}"* ]]
}

@test 'ok:false response exits 1' {
  respond users.setPresence '{"ok":false,"error":"invalid_auth"}'
  run slk presence away
  [ "${status}" -eq 1 ]
  [[ "${output}" == *invalid_auth* ]]
}

@test 'response JSON is not glob-expanded' {
  respond users.setPresence '{"ok":true,"note":"a * b"}'
  run slk presence away --filter .note
  [ "${output}" = 'a * b' ]
}

# --- presence ---------------------------------------------------------------------------------

@test 'presence active only calls users.setPresence auto' {
  slk presence active
  [ "$(methods)" = 'users.setPresence' ]
  [ "$(param 0 presence)" = 'auto' ]
}

# --- status -----------------------------------------------------------------------------------

@test 'status edit encodes quotes and backslashes as valid JSON' {
  slk status edit 'At "an" appt \ back soon' ':calendar:'
  [ "$(param 0 profile | jq -r .status_text)" = 'At "an" appt \ back soon' ]
  [ "$(param 0 profile | jq -r .status_emoji)" = ':calendar:' ]
}

@test 'status edit --expires +90m sets status_expiration about 90 minutes out' {
  now=$(date +%s)
  slk status edit 'Away' ':calendar:' --expires +90m
  x=$(param 0 profile | jq -r .status_expiration)
  [ "${x}" -ge $(( now + 5400 )) ]
  [ "${x}" -le $(( now + 5402 )) ]
}

@test 'status edit --expires HH:MM lands on that minute, within the next day' {
  now=$(date +%s)
  slk status edit 'Away' ':calendar:' --expires 09:15
  x=$(param 0 profile | jq -r .status_expiration)
  [ "${x}" -gt "${now}" ]
  [ "${x}" -le $(( now + 86400 )) ]
  [ $(( x % 60 )) -eq 0 ]
}

@test 'status edit --expires accepts epoch seconds' {
  slk status edit 'Away' ':calendar:' --expires 1999999999
  [ "$(param 0 profile | jq -r .status_expiration)" = '1999999999' ]
}

@test 'status edit --expires rejects junk without calling Slack' {
  run slk status edit 'Away' ':calendar:' --expires tomorrowish
  [ "${status}" -eq 1 ]
  [ -z "$(methods)" ]
}

@test 'status clear also clears the expiration' {
  slk status clear
  [ "$(param 0 profile)" = '{"status_text":"","status_emoji":"","status_expiration":0}' ]
}

# --- user lookups -----------------------------------------------------------------------------

@test 'snooze info --user @name follows users.list pagination' {
  respond users.list.1 "${USERS_PAGE_1}"
  respond users.list.2 "${USERS_PAGE_2}"
  slk snooze info --user @jason
  [ "$(param 1 cursor)" = 'page2' ]
  [ "$(param "$(call_index dnd.info)" user)" = 'U002' ]
}

@test 'snooze info --user @name matches display name' {
  respond users.list "${USERS_PAGE_1}"
  slk snooze info --user @Alice
  [ "$(param "$(call_index dnd.info)" user)" = 'U001' ]
}

# --- chat -------------------------------------------------------------------------------------

@test 'chat send @user opens the DM with conversations.open' {
  respond users.list.1 "${USERS_PAGE_1}"
  respond users.list.2 "${USERS_PAGE_2}"
  respond conversations.open '{"ok":true,"channel":{"id":"D999"}}'
  slk chat send 'hi' @jason
  [ "$(param "$(call_index conversations.open)" users)" = 'U002' ]
  [ "$(param "$(call_index chat.postMessage)" channel)" = 'D999' ]
  ! methods | grep -q im.list
}

@test 'chat send encodes quotes in text as valid JSON' {
  slk chat send 'say "hi" \ now' '#general'
  [ "$(param 0 attachments | jq -r '.[0].pretext')" = 'say "hi" \ now' ]
}

@test 'chat send keeps the plain attachment shape when no options are given' {
  slk chat send 'hello' '#general'
  [ "$(param 0 attachments)" = '[{"mrkdwn_in":["pretext"],"fallback":"hello","pretext":"hello"}]' ]
}

@test 'chat send --author-link sets author_link, not title_link' {
  slk chat send 'hello' '#general' --author-link https://example.com/a
  att=$(param 0 attachments)
  [ "$(jq -r '.[0].author_link' <<< "${att}")" = 'https://example.com/a' ]
  [ "$(jq -r '.[0].title_link // "none"' <<< "${att}")" = 'none' ]
}

@test 'chat send --image= takes the value after the equals sign' {
  slk chat send 'hello' '#general' --image=https://example.com/i.png
  [ "$(param 0 attachments | jq -r '.[0].image_url')" = 'https://example.com/i.png' ]
}

@test 'chat send passes --fields JSON through' {
  slk chat send 'hello' '#general' --fields '{"title":"T","value":"V","short":true}'
  [ "$(param 0 attachments | jq -c '.[0].fields')" = '[{"title":"T","value":"V","short":true}]' ]
}

@test 'chat send rejects invalid --fields JSON without calling Slack' {
  run slk chat send 'hello' '#general' --fields '{bad'
  [ "${status}" -eq 1 ]
  [ -z "$(methods)" ]
}

@test 'chat send from stdin keeps real newlines' {
  printf 'line one\nline two' | slk chat send --channel '#general'
  [ "$(param 0 attachments | jq -r '.[0].pretext')" = "$(printf '```line one\nline two```')" ]
}

# --- files ------------------------------------------------------------------------------------

@test 'file upload uses the external upload flow' {
  f="${BATS_TEST_TMPDIR}/note.txt"
  printf 'hello world' > "${f}"
  respond files.getUploadURLExternal '{"ok":true,"upload_url":"https://files.slack.com/upload/v1/abc","file_id":"F123"}'
  respond conversations.list '{"ok":true,"channels":[{"id":"C777","name":"general"}],"response_metadata":{"next_cursor":""}}'
  slk file upload "${f}" '#general,C888' --comment 'see attached' --title 'Note'
  [ "$(methods | tr '\n' ' ')" = 'files.getUploadURLExternal UPLOAD conversations.list files.completeUploadExternal ' ]
  [ "$(param 0 filename)" = 'note.txt' ]
  [ "$(param 0 length)" = '11' ]
  [ "$(jq -rs '.[1].url' "${SHIM_DIR}/calls")" = 'https://files.slack.com/upload/v1/abc' ]
  [ -z "$(jq -rs '.[1].config' "${SHIM_DIR}/calls")" ]
  i=$(call_index files.completeUploadExternal)
  [ "$(param "${i}" files)" = '[{"id":"F123","title":"Note"}]' ]
  [ "$(param "${i}" channels)" = 'C777,C888' ]
  [ "$(param "${i}" initial_comment)" = 'see attached' ]
}

@test 'file upload of piped content uploads it as a file named stdin' {
  respond files.getUploadURLExternal '{"ok":true,"upload_url":"https://files.slack.com/upload/v1/abc","file_id":"F123"}'
  printf 'abc' | slk file upload --channels C888
  [ "$(param 0 filename)" = 'stdin' ]
  [ "$(param 0 length)" = '3' ]
}

@test 'file upload --filetype becomes snippet_type' {
  respond files.getUploadURLExternal '{"ok":true,"upload_url":"https://files.slack.com/upload/v1/abc","file_id":"F123"}'
  printf 'x = 1' | slk file upload --channels C888 --filetype python
  [ "$(param 0 snippet_type)" = 'python' ]
}

@test 'file upload stops when the upload POST fails' {
  respond files.getUploadURLExternal '{"ok":true,"upload_url":"https://files.slack.com/upload/v1/abc","file_id":"F123"}'
  printf '500' > "${SHIM_DIR}/http_code"
  run bash -c "printf abc | '${BATS_TEST_DIRNAME}/../../build/bin/slk' file upload --channels C888"
  [ "${status}" -eq 1 ]
  ! methods | grep -q files.completeUploadExternal
}

@test 'file upload fails on an unknown #channel without completing' {
  respond files.getUploadURLExternal '{"ok":true,"upload_url":"https://files.slack.com/upload/v1/abc","file_id":"F123"}'
  respond conversations.list '{"ok":true,"channels":[],"response_metadata":{"next_cursor":""}}'
  run bash -c "printf abc | '${BATS_TEST_DIRNAME}/../../build/bin/slk' file upload --channels '#nope'"
  [ "${status}" -eq 1 ]
  ! methods | grep -q files.completeUploadExternal
}

# --- timestamps -------------------------------------------------------------------------------

@test 'file list --timestamp-from= takes the value after the equals sign' {
  slk file list --timestamp-from=1700000000 --timestamp-to=1700000100
  [ "$(param 0 ts_from)" = '1700000000' ]
  [ "$(param 0 ts_to)" = '1700000100' ]
}

# --- init -------------------------------------------------------------------------------------

@test 'init writes the token readable by the owner only, even over an existing file' {
  d="${BATS_TEST_TMPDIR}/install"
  make -C "${BATS_TEST_DIRNAME}/../.." install bindir="${d}/bin" etcdir="${d}/etc" >/dev/null
  printf 'old\n' > "${d}/etc/.slack" && chmod 644 "${d}/etc/.slack"
  SLACK_CLI_TOKEN= "${d}/bin/slk" init --token xoxp-init-test
  [ "$(head -1 "${d}/etc/.slack")" = 'xoxp-init-test' ]
  [ "$(ls -l "${d}/etc/.slack" | cut -c1-10)" = '-rw-------' ]
}

@test 'init --trace does not print the token' {
  d="${BATS_TEST_TMPDIR}/install"
  make -C "${BATS_TEST_DIRNAME}/../.." install bindir="${d}/bin" etcdir="${d}/etc" >/dev/null
  run env SLACK_CLI_TOKEN= "${d}/bin/slk" init --token xoxp-init-test --trace
  [[ "${output}" != *xoxp-init-test* ]]
}

# --- dependencies -----------------------------------------------------------------------------

# onpath <executable...>: a PATH holding only bash, dirname and the given executables
function onpath() {
  local d="${BATS_TEST_TMPDIR}/path" e
  mkdir -p "${d}"
  for e in bash dirname "$@"; do ln -sf "$(command -v "${e}")" "${d}/${e}"; done
  echo "${d}"
}

@test 'api commands fail with missing_dependency when jq is not on PATH' {
  run env PATH="$(onpath curl)" "${BATS_TEST_DIRNAME}/../../build/bin/slk" presence away
  [ "${status}" -eq 1 ]
  [ "${output}" = '{"ok": false, "error": "missing_dependency", "dependency": "jq"}' ]
  [ ! -s "${SHIM_DIR}/calls" ]
}

@test 'api commands fail with missing_dependency when curl is not on PATH' {
  run env PATH="$(onpath jq)" "${BATS_TEST_DIRNAME}/../../build/bin/slk" presence away
  [ "${status}" -eq 1 ]
  [ "${output}" = '{"ok": false, "error": "missing_dependency", "dependency": "curl"}' ]
}

@test 'init fails with missing_dependency when jq is not on PATH' {
  run env PATH="$(onpath)" "${BATS_TEST_DIRNAME}/../../build/bin/slk" init --token xoxp-init-test
  [ "${status}" -eq 1 ]
  [ "${output}" = '{"ok": false, "error": "missing_dependency", "dependency": "jq"}' ]
}

@test '--help and --version need neither curl nor jq' {
  run env PATH="$(onpath)" "${BATS_TEST_DIRNAME}/../../build/bin/slk" --version
  [ "${status}" -eq 0 ]
  [ "${output}" = '0.19.0' ]
  run env PATH="$(onpath)" "${BATS_TEST_DIRNAME}/../../build/bin/slk" --help
  [ "${status}" -eq 0 ]
}
