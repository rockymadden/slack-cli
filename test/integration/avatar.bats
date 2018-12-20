#!/usr/bin/env bats

load suite

@test 'avatar upload should succeed' {
  build/bin/slack avatar upload test/assets/avatar.png
}

@test 'avatar delete should succeed' {
  build/bin/slack avatar delete
}
