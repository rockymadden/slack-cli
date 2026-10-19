# Modernization plan

## Status (2026-10-19)

Defects 1-6 fixed in `src/slk` 0.19.0, plus `chat send` JSON quoting, `jqify` glob expansion, and four option-parsing bugs, `init` token permissions and trace. 34 tests green (`make test`: unit + offline shim). Installed at `~/.local/bin/slk`, token at `~/.config/slk/.slack` (600). Live-checked on Busie with own records: DM send/update/delete, file upload/info/delete, status edit `--expires` + clear, presence active, snooze info `--user @jason`. Cleaned up except two test reminders the API cannot delete (see below). Reminders: `add` works, but `info`/`list`/`delete` return `not_found` even via raw curl; Slack-side since Save it for Later, documented, not fixable here.

Fork: `jasonpaulso/slack-cli`, identical to `rockymadden/slack-cli` master (`46d2274`, 2018-11-06; 0 ahead, 0 behind, checked 2026-10-19). Remotes: `origin` = the fork, `upstream` = rockymadden. Upstream is dormant (38 open issues, no commits since 2018), so fixes land here and stay here.

## Baseline

- The installed copy (`/opt/homebrew/Cellar/slack-cli/0.18.0`, tap `rockymadden/rockymadden`) is **older than master**. Master already adds `--actions`/`--fields` on `chat send`, a `~/.slack` / `/etc/.slack` token fallback, display-name matching, and the `.members` fix in `luser`. The installed `--user @name` is broken live (`jq: Cannot index boolean with string "name"`); master's code is not yet run.
- Token: user token (`xoxp-`) in `/opt/homebrew/etc/slack-cli/.slack`. Scopes cover every method the CLI calls (probed 2026-10-19).

## Defects to fix

| # | Command | Defect | Evidence | Fix |
|---|---|---|---|---|
| 1 | `file upload` | `files.upload` retired, returns `method_deprecated` | live probe | `files.getUploadURLExternal` → POST bytes to returned URL → `files.completeUploadExternal` (with `channel_id`, `initial_comment`, `title`) |
| 2 | `chat send @user` | `lchannel` resolves DMs via `im.list`, retired (`method_deprecated`; Slack's message names `conversations.list` / `users.conversations`) | live probe | `conversations.open users=<id>` returns the DM channel id in one call (`im:write`, granted) |
| 3 | `status edit` | profile JSON built by string interpolation, so `"` or `\` in text breaks it; no expiry | code read | build with `jq -n --arg`; add `--expires <epoch\|HH:MM\|+90m>` → `status_expiration` |
| 4 | every command | token sent as a curl argument (`--data-urlencode "token=…"`), visible in `ps` while curl runs | code read | one `api()` helper sending `Authorization: Bearer` via `curl -H @-` or `--config` from stdin |
| 5 | `presence active` | also calls `users.setActive`, a deprecated no-op | live probe returns ok; Slack documents it as a no-op | drop the call |
| 6 | `@name` lookups | `users.list` read without pagination; large workspaces miss users | code read; Busie is small, low priority | follow `response_metadata.next_cursor`, or `users.lookupByEmail` when given an email |

Not defects, but worth doing in the same pass: one `api()` helper replacing ~20 hand-rolled curl blocks (also the place for #4 and for surfacing `response_metadata.messages` warnings); exit non-zero when `ok:false`. Exit-code behaviour on failure is unverified today and gets a test first.

## Binary name (decide before install)

Slack's official app-developer CLI (Homebrew cask `slack-cli`, v4.10) also installs `slack`. A future `brew install` can shadow or overwrite this one. Proposal: rename the binary to `slk` (repo name stays), install with `make install bindir=~/.local/bin etcdir=~/.config/slk`, and uninstall the brew formula once `slk` passes. Alternatives: keep `slack` and pin PATH order; a personal tap.

## Tests

- Install `bats-core` (not present). Unit tests (`test/unit`: help, version) run as-is.
- The integration tests (`test/integration/*.bats`) post real messages to `#slack-cli`, `#slack-cli-private` and DM `@rockymadden`. They never run against the Busie workspace. Replace the network with a `curl` shim on `PATH` that records the request (method, headers, form fields) and replays canned responses, so every command is tested offline: request shape asserted, token absent from argv, `ok:false` → exit 1.
- Red first: a shim test per defect above goes red on current master, then green.
- Live check after green, Busie rules: read-only calls freely; writes only on records we create (a DM to Jason himself, a test reminder, a test file) and deleted afterwards; status changes restore the prior state, as the `away` live check did.

## Follow-on

- `~/.claude/skills/away/away.sh` becomes three `slk` calls (`status edit --expires`, `presence away`, `snooze start`) plus its presence-restore job.
- Update memory note (slack CLI dead paths) once #1 and #2 ship.

## Decisions

1. ~~Binary name~~ **Decided 2026-10-19: `slk`.**
2. ~~Install target~~ **Decided 2026-10-19: `make install bindir=~/.local/bin etcdir=~/.config/slk`** (on PATH ahead of Homebrew). The Makefile `rsync`s `src/` verbatim, so it needs a step that installs `src/slack` as `slk`.
3. ~~Where fixes land~~ **Decided 2026-10-19: straight to `master`**, no branch.
