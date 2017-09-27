#!/usr/bin/env bats

load suite

@test 'presence active should succeed' {
  build/bin/slack presence active
}

@test 'presence away should succeed' {
  build/bin/slack presence away
}
