# slack-cli <sub><sup>| Powerful Slack messaging CLI via pure bash</sup></sub>
[![version](http://img.shields.io/badge/version-v0.7.2-blue.svg)](https://github.com/rockymadden/slack-cli/releases)
[![versioning](http://img.shields.io/badge/versioning-semver-blue.svg)](http://semver.org/)
[![branching](http://img.shields.io/badge/branching-github%20flow-blue.svg)](https://guides.github.com/introduction/flow/)
[![license](http://img.shields.io/badge/license-mit-blue.svg)](https://opensource.org/licenses/MIT)
[![circleci](https://circleci.com/gh/rockymadden/slack-cli.svg?style=shield)](https://circleci.com/gh/rockymadden/slack-cli)

Full support for [rich message formatting](https://api.slack.com/docs/attachments) and extremely
pipe friendly. Listening a-la `fswatch` currently in development.

## Installation
```bash
$ brew tap rockymadden/rockymadden
$ brew install slack-cli
```
> __PROTIP:__ Your Slack team must have one or more
[incoming webhook integrations](https://api.slack.com/incoming-webhooks).

## Usage

```bash
$ slack --help
Usage:
  slack init [--channel|-c <channel>] [--icon|-i <icon>] [--silent|-s]
    [--username|-u <username>] [--webhook|-w <webhook>]
  slack send <text> [channel] [--author|-a <author>] [--author-icon|-I <author-icon-url>]
    [--author-link|-L <author-link>] [--channel|-c <channel>] [--color|-C <color>]
    [--image|-i <image-url>] [--pretext|-p <pretext>] [--silent|-s]
    [--thumbnail|-H <thumbnail-url>] [--title|-t <title>] [--title-link|-l <title-link>]

Setup Commands:
  init     Initialize

Core Commands:
  send     Send message
```

> __PROTIP:__ See the [Slack attachments documentation](https://api.slack.com/docs/attachments) for
more information about `send` option meanings.

> __PROTIP:__ All commands prompt for required arguments which were not provided via options or
arguments. This allows for both traditional usage and prompt-based usage.

### Initialize:

```bash
$ slack init
Enter webhook (e.g. https://hooks.slack.com/services/XXX/XXX/XXX): https://hooks.slack.com/services/XXX/XXX/XXX
Enter default channel (e.g. #general): #general
Enter username (e.g. username-bot): username-bot
Enter icon (e.g. :robot_face:, https://avatars3.githubusercontent.com/u/XXX): :robot_face:
Initializing: done
```

### Send message:

```bash
# Sending to default channel:
$ slack send 'Hello World!'
Sending: done

# Sending to specified channel via argument:
$ slack send 'Hello World!' #channel
Sending: done

# Sending to specified channel via option:
$ slack send 'Hello World!' --channel='#channel'
Sending: done

# Piping echo:
$ echo 'Hello World!' | slack send --channel='#channel'
Sending: done

# Piping ls:
$ ls -al | slack send --channel='#channel' --pretext='Directory:' --color=good
Sending: done

# Piping cat:
$ cat today.log | slack send --channel='#channel' --pretext='Prod issues:' --color=danger
Sending: done

# Sending to non-existent channel:
$ slack send 'Hello World!' --channel='#nonexistentchannel'
Sending: fail
$ echo $?
1
```

### Listen for messages a-la `fswatch`:

> __NOTE:__ Currently in development.

```bash
$ slack listen | while read -d "" message \
  do \
    case "${message}" in \
      'hey') slack send 'hey to you' ;; \
      'server is on fire') restart-server ;; \
    esac \
  done
```

## Useful Functions

### Send notification of a pull-request merge into master:

#### Function:
```bash
function slack-pull-request() {
  local url=$(git browse -u)
  local repo=$(git browse -u | sed -e 's|https://github.com/||g')
  local desc=$(git issue | grep "${1}" | cut -d ']' -f2)

  slack send "*Pull request merged into master:* ${desc}" \
    --author="${repo}" \
    --author-icon='https://assets-cdn.github.com/images/modules/logos_page/Octocat.png' \
    --author-link="${url}" \
    --channel="${2}" \
    --color=good
}
```

#### Function Usage:
```bash
$ slack-pull-request 177 #channel
Sending: done
```

### Send notification of a collaborator state change:

#### Function:
```bash
function slack-collaborator() {
  local url=$(git browse -u)
  local repo=$(git browse -u | sed -e 's|https://github.com/||g')

  slack send "*Collaborator state change:* ${1}" \
    --author="${repo}" \
    --author-icon='https://assets-cdn.github.com/images/modules/logos_page/Octocat.png' \
    --author-link="${url}" \
    --channel="${2}" \
    --color=good
}
```

#### Function Usage:
```bash
$ slack-collaborator 'Added rockymadden' #channel
Sending: done
```

## License
```
The MIT License (MIT)

Copyright (c) 2016 Rocky Madden (https://rockymadden.com/)

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
