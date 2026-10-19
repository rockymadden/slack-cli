#!/usr/bin/env bats

load suite

@test 'snooze start should succeed' {
  build/bin/slk snooze start 5
}

@test 'snooze info should succeed' {
  build/bin/slk snooze info
}

@test 'snooze end should succeed' {
  build/bin/slk snooze end
}
