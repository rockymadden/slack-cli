# slack-cli <sub><sup>| Slack on the command line via pure bash</sup></sub>
[![version](http://img.shields.io/badge/version-v0.5.0-blue.svg)](https://github.com/rockymadden/slack-cli/releases)
[![versioning](http://img.shields.io/badge/versioning-semver-blue.svg)](http://semver.org/)
[![branching](http://img.shields.io/badge/branching-github%20flow-blue.svg)](https://guides.github.com/introduction/flow/)
[![license](http://img.shields.io/badge/license-mit-blue.svg)](https://opensource.org/licenses/MIT)
[![circleci](https://circleci.com/gh/rockymadden/slack-cli.svg?style=shield)](https://circleci.com/gh/rockymadden/slack-cli)

## Installation
```bash
$ brew tap rockymadden/rockymadden
$ brew install slack-cli
```
> __PROTIP:__ Your Slack team must have one or more
[incoming webhook integrations](https://api.slack.com/incoming-webhooks)

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
$ slack send 'Hello World!' '@username'
Sending: done

# Sending to specified channel via option:
$ slack send 'Hello World!' --channel='@username'
Sending: done

# Piping text to specified channel:
$ echo 'Hello World!' | slack send --channel='@username'
Sending: done

# Sending to non-existent channel:
$ slack send 'Hello World!' --channel='#nonexistentchannel'
Sending: fail
```

## Recipes

### Send notification of a pull-request merge into master:

__Input:__
```bash
$ git issue | grep 177 | cut -d ']' -f2 | slack send --pretext='Pull request merged into master:' --color=good --channel="#channel"
Sending: done
```

__Output:__
![example](http://share.rockymadden.com/0s3s231n260k/Image%202015-12-17%20at%2012.11.56%20PM.png)

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
