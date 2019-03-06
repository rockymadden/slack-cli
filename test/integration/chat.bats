#!/usr/bin/env bats

load suite

@test 'chat send to public channel should succeed' {
  build/bin/slack chat send 'chat send to public channel should succeed' '#slack-cli'
}

@test 'chat send to private channel should succeed' {
  build/bin/slack chat send 'chat send to private channel should succeed' '#slack-cli-private'
}

@test 'chat send to direct channel via should succeed' {
  build/bin/slack chat send 'chat send to direct channel should succeed' @rockymadden
}

@test 'chat send to direct channel via email should succeed' {
  build/bin/slack chat send 'chat send to direct channel via email should succeed' github@rockymadden.com
}

@test 'chat send to invalid channel should fail' {
  run build/bin/slack chat send 'chat send to invalid channel should fail' '#invalid'
  [ ${status} -eq 1 ]
}

@test 'chat send via arguments should succeed' {
  build/bin/slack chat send 'chat send via arguments should succeed' '#slack-cli'
}

@test 'chat send via options should succeed' {
  build/bin/slack chat send --text 'chat send via options should succeed' --channel '#slack-cli'
}

@test 'chat send via pipe should succeed' {
  ls -al | build/bin/slack chat send --pretext 'chat send via pipe should succeed' --channel '#slack-cli'
}

@test 'chat send with rich formatting should succeed' {
  build/bin/slack chat send 'text' '#slack-cli' --pretext 'chat send with rich formatting should succeed'
}

@test 'chat update should succeed' {
  build/bin/slack chat send 'chat update should not fail' '#slack-cli' --filter '.ts + "\n" + .channel' |
    xargs -n2 build/bin/slack chat update 'chat update should succeed'
}

@test 'chat delete should succeed' {
  build/bin/slack chat send 'chat delete should not fail' '#slack-cli' --filter '.ts + "\n" + .channel' |
    xargs -n2 build/bin/slack chat delete
}
