#!/usr/bin/env bats

load suite

@test 'status edit should succeed' {
  build/bin/slk status edit lunch :hamburger:
}
