# slack-cli <sub><sup>| Powerful Slack messaging CLI via pure bash</sup></sub>
[![version](http://img.shields.io/badge/version-v0.8.0-blue.svg)](https://github.com/rockymadden/slack-cli/releases)
[![versioning](http://img.shields.io/badge/versioning-semver-blue.svg)](http://semver.org/)
[![branching](http://img.shields.io/badge/branching-github%20flow-blue.svg)](https://guides.github.com/introduction/flow/)
[![license](http://img.shields.io/badge/license-mit-blue.svg)](https://opensource.org/licenses/MIT)
[![circleci](https://circleci.com/gh/rockymadden/slack-cli.svg?style=shield)](https://circleci.com/gh/rockymadden/slack-cli)

The premise is simple: provide a unixy, extremely pipe friendly, focused, yet feature rich, command
line interface for sending and listening for Slack messages with your own account. With it, you can:

* __Send [richly formatted messages](https://api.slack.com/docs/attachments), allowing you to:__
  * Automate your development workflows (e.g. Using [github/hub](https://github.com/github/hub),
    send a notification to your team that you are accepting a pull request and close it -- all in
    one line)
  * Automate your devops workflows (e.g. Send a notification that you are starting server
    maintenance, perform said maintenance, and send a notification of completion -- all in one line)
* __Listen for messages, a-la `fswatch`, allowing you to:__
  * Create your own personal bot (e.g. Listen for messages conforming to a specific pattern and
    reply back).
  * Create your own event stream processor (e.g. Listen for messages coming from DataDog stating a
    server is down and automatically restart said server)

## Installation
```bash
$ brew tap rockymadden/rockymadden
$ brew install slack-cli
```
> __PROTIP:__ You must have a [Slack API bearer token issued](https://api.slack.com/web) for your
account.

## Usage

```bash
$ slack --help
Usage:
  slack init [--channel|-c <channel>] [--silent|-s] [--token|-t <token>]
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
Enter token: token
Enter default channel (e.g. #general): #general
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

![example](http://share.rockymadden.com/123Q1W1b200H/Image%202015-12-26%20at%202.13.54%20PM.png)

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
$ slack-pull-request 16 #general
Sending: done
```

### Send notification of a collaborator state change:

![example](http://share.rockymadden.com/3i3B3y2t2v0o/Image%202015-12-26%20at%202.15.02%20PM.png)

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
$ slack-collaborator 'added <https://github.com/rockymadden|rockymadden> as admin' #general
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
