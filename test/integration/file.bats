#!/usr/bin/env bats

load suite

@test 'file upload should succeed' {
  ls -al | build/bin/slack file upload --channel '#slack-cli'
}

@test 'file list should succeed' {
  build/bin/slack file list
}

@test 'file info should succeed' {
  build/bin/slack file list --filter '.files[1] | .id' | xargs build/bin/slack file info
}

@test 'file delete should succeed' {
  ls -al | build/bin/slack file upload --channel '#slack-cli' --filter '.file .id' |
    xargs build/bin/slack file delete
}
