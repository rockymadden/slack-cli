# slack-cli <sub><sup>| Powerful Slack CLI via pure bash</sup></sub>
[![version](http://img.shields.io/badge/version-v0.9.0-blue.svg)](https://github.com/rockymadden/slack-cli/releases)
[![versioning](http://img.shields.io/badge/versioning-semver-blue.svg)](http://semver.org/)
[![branching](http://img.shields.io/badge/branching-github%20flow-blue.svg)](https://guides.github.com/introduction/flow/)
[![license](http://img.shields.io/badge/license-mit-blue.svg)](https://opensource.org/licenses/MIT)
[![pm](http://img.shields.io/badge/pm-zenhub-blue.svg)](https://www.zenhub.io/)
[![chat](http://img.shields.io/badge/chat-slack-blue.svg)](https://rockymadden-slack.herokuapp.com/)
[![circleci](https://circleci.com/gh/rockymadden/slack-cli.svg?style=shield)](https://circleci.com/gh/rockymadden/slack-cli)

A pure bash, pipe friendly, feature rich, command line interface for Slack. Deep integration with
[jq](https://github.com/stedolan/jq) allows for the ability to perform complex
declarative/higher-order operations on responses, helping you perform complex compositional
operations with relative ease.

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
  slack chat send <text> [--author|-a <author>] [--author-icon|-I <author-icon-url>]
    [--author-link|-L <author-link>] [--channel|-c <channel>] [--color|-C <color>]
    [--compact|-c] [--filter|-f <filter>] [--image|-i <image-url>] [--monochrome|-m]
    [--pretext|-p <pretext>] [--thumbnail|-H <thumbnail-url>] [--title|-t <title>]
    [--title-link|-l <title-link>]
  slack chat update <text> [--author|-a <author>] [--author-icon|-I <author-icon-url>]
    [--author-link|-L <author-link>] [--channel|-c <channel>] [--color|-C <color>]
    [--compact|-c] [--filter|-f <filter>] [--image|-i <image-url>] [--monochrome|-m]
    [--pretext|-p <pretext>] [--thumbnail|-H <thumbnail-url>]
    [--timestamp|-ts <timestamp>] [--title|-t <title>] [--title-link|-l <title-link>]
  slack init [--channel|-c <channel>] [--compact|-c] [--filter|-f <filter>]
    [--monochrome|-m] [--token|-t <token>]

Configuration Commands:
  init    Initialize

Chat Commands:
  chat send      Send chat message
  chat update    Update chat message
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

### `chat send`:

```bash
$ # Sending message to default channel:
$ slack chat send 'Hello World!'

$ # Sending message to channel via option:
$ slack chat send 'Hello World!' --channel '#channel'

$ # Sending message via piped echo:
$ echo 'Hello World!' | slack chat send --channel '#channel'

$ # Sending message via piped ls:
$ ls -al | slack chat send --channel '#channel' --pretext 'Directory:' --color good

$ # Sending message via piped cat:
$ cat today.log | slack chat send --channel '#channel' --pretext 'Prod issues:' --color danger
```

> __PROTIP:__ See the [Slack attachments documentation](https://api.slack.com/docs/attachments) for
more information about option meanings.

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
