#!/usr/bin/env bats

load suite

@test 'status edit should succeed' {
  build/bin/slack status edit lunch :hamburger:
}
