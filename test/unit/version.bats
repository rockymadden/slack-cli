#!/usr/bin/env bats

@test '-v should output version' {
  run build/bin/slack -v
  [ ${status} -eq 0 ]
  [ $(expr "${output}" : "0.*") -ne 0 ]
}

@test '--version should output version' {
  run build/bin/slack --version
  [ ${status} -eq 0 ]
  [ $(expr "${output}" : "0.*") -ne 0 ]
}
