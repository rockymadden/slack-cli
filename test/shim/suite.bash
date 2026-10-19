#!/usr/bin/env bash
# Offline harness: a fake curl on PATH records every request; nothing reaches Slack.

TOKEN='xoxp-shim-test-token'

function setup() {
  export SHIM_DIR="${BATS_TEST_TMPDIR}"
  mkdir -p "${SHIM_DIR}/responses"
  : > "${SHIM_DIR}/calls"
  export PATH="${BATS_TEST_DIRNAME}/bin:${PATH}"
  export SLACK_CLI_TOKEN="${TOKEN}"
}

# respond <method>[.<n>] <json>
function respond() {
  printf '%s' "${2}" > "${SHIM_DIR}/responses/${1}"
}

# methods: every Slack method called, in order, one per line
function methods() {
  jq -r '.method' "${SHIM_DIR}/calls"
}

# param <call-index> <name>: value of a --data-urlencode/--form field on the n-th call (0-based)
function param() {
  jq -rs --argjson n "${1}" --arg k "${2}" '
    .[$n].argv as $a
    | [range(0; $a | length) | select($a[.] == "--data-urlencode" or $a[.] == "-F" or $a[.] == "--form") | $a[. + 1]]
    | map(capture("^(?<key>[^=]*)=(?<value>.*)$"; "s")) | from_entries | .[$k] // empty' "${SHIM_DIR}/calls"
}

# call_index <method>: 0-based index of the first call to <method>
function call_index() {
  jq -rs --arg m "${1}" 'map(.method) | index($m) // empty' "${SHIM_DIR}/calls"
}

function slk() {
  "${BATS_TEST_DIRNAME}/../../build/bin/slk" "$@"
}
