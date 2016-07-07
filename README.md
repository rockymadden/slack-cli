# slack-cli <sub><sup>| Powerful Slack messaging CLI via pure bash</sup></sub>
[![version](http://img.shields.io/badge/version-v0.9.0-blue.svg)](https://github.com/rockymadden/slack-cli/releases)
[![versioning](http://img.shields.io/badge/versioning-semver-blue.svg)](http://semver.org/)
[![branching](http://img.shields.io/badge/branching-github%20flow-blue.svg)](https://guides.github.com/introduction/flow/)
[![license](http://img.shields.io/badge/license-mit-blue.svg)](https://opensource.org/licenses/MIT)
[![pm](http://img.shields.io/badge/pm-zenhub-blue.svg)](https://www.zenhub.io/)
[![chat](http://img.shields.io/badge/chat-slack-blue.svg)](https://rockymadden-slack.herokuapp.com/)
[![circleci](https://circleci.com/gh/rockymadden/slack-cli.svg?style=shield)](https://circleci.com/gh/rockymadden/slack-cli)

The premise is simple: A pure bash, pipe friendly, focused, yet feature rich, command line
interface for sending and listening for Slack messages. Deep integration with
[jq](https://github.com/stedolan/jq) allows for the ability to perform complex
declarative/higher-order operations on responses, helping you perform complex compositional
operations with relative ease.

With `slack-cli`, you can:

* __Send [richly formatted messages](https://api.slack.com/docs/attachments), allowing you to:__
  * Automate your development workflows
  * Automate your devops workflows
  * Create your own CLI-based notification bots
* __Listen for messages, a-la `fswatch`, allowing you to:__
  * Create your own CLI-based conversational bots
  * Create your own CLI-based event stream processors

## Installation
```bash
$ # Install from tap:
$ brew tap rockymadden/rockymadden
$ brew install slack-cli

$ # Initialize:
$ slack init
```
> __PROTIP:__ Ensure you have a [Slack API token](https://api.slack.com/web).

## Usage

```bash
$ slack --help
Usage:
  slack init [--channel|-c <channel>] [--compact|-c] [--filter|-f <filter>]
    [--monochrome|-m] [--token|-t <token>]
  slack send <text> [channel] [--author|-a <author>] [--author-icon|-I <author-icon-url>]
    [--author-link|-L <author-link>] [--channel|-c <channel>] [--color|-C <color>]
    [--compact|-c] [--filter|-f <filter>] [--image|-i <image-url>] [--monochrome|-m]
    [--pretext|-p <pretext>] [--thumbnail|-H <thumbnail-url>] [--title|-t <title>]
    [--title-link|-l <title-link>]

Configuration Commands:
  init    Initialize

Core Commands:
  send    Send message
```

> __PROTIPS:__
* The `--compact` option is a wrapper around the [jq](https://stedolan.github.io/jq/manual/)
  `--compact-output` option
* The `--filter` option is passed directly to [jq](https://stedolan.github.io/jq/manual/) as a
  filter
* The `--monochrome` option a wrapper around the [jq](https://stedolan.github.io/jq/manual/)
  `--monochrome-output` option
* All commands prompt for required arguments which were not provided via options or arguments. This
allows for both traditional usage and prompt-based usage.


## Examples and Recipes

### `send`:

```bash
$ # Sending to default channel:
$ slack send 'Hello World!'

$ # Sending to specified channel via argument:
$ slack send 'Hello World!' '#channel'

$ # Sending to specified channel via option:
$ slack send 'Hello World!' --channel='#channel'

$ # Piping echo:
$ echo 'Hello World!' | slack send --channel='#channel'

$ # Piping ls:
$ ls -al | slack send --channel='#channel' --pretext='Directory:' --color=good

$ # Piping cat:
$ cat today.log | slack send --channel='#channel' --pretext='Prod issues:' --color=danger
```

> __PROTIP:__ See the [Slack attachments documentation](https://api.slack.com/docs/attachments) for
more information about option meanings.

### `listen`:

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
