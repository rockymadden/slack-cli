#!/usr/bin/env bats

load suite

@test 'snooze start should succeed' {
  build/bin/slack snooze start 5
}

@test 'snooze info should succeed' {
  build/bin/slack snooze info
}

@test 'snooze end should succeed' {
  build/bin/slack snooze end
}
