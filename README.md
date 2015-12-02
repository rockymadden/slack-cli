# slack-cli <sub><sup>| Slack via the command line</sup></sub>
[![version](http://img.shields.io/badge/version-v0.0.0-blue.svg)](https://github.com/rockymadden/slack-cli/releases)
[![versioning](http://img.shields.io/badge/versioning-semver-blue.svg)](http://semver.org/)
[![branching](http://img.shields.io/badge/branching-github%20flow-blue.svg)](https://guides.github.com/introduction/flow/)
[![license](http://img.shields.io/badge/license-mit-blue.svg)](https://opensource.org/licenses/MIT)
[![status](http://img.shields.io/badge/status-working-brightgreen.svg)](#)

## Installation
```bash
$ brew tap rockymadden/rockymadden
$ brew install slack-cli
$ slack init
```
> __NOTE:__ Also requires that your Slack team has one or more [incoming webhook integrations](https://api.slack.com/incoming-webhooks)

## Usage

All subcommands prompt for required arguments which were not provided via options. This allows for
both traditional option-based usage and also prompt-based usage.

### Send message:
```bash
$ slack send
Enter message (e.g. Hello World!): Hello World!
$ slack send -c '#general'
Enter message (e.g. Hello World!): Hello World!
$ slack send --channel='@username'
Enter message (e.g. Hello World!): Hello World!
$ slack send -m 'Checkout this <https://github.com/rockymadden/slack-cli|repo>!'
$ slack send --message='Checkout this <https://github.com/rockymadden/slack-cli|repo>!'
$ slack send -c '#general' -m 'Checkout this <https://github.com/rockymadden/slack-cli|repo>!'
$ slack send --channel='@username' --message='Checkout this <https://github.com/rockymadden/slack-cli|repo>!'
```

---

## License
```
The MIT License (MIT)

Copyright (c) 2015 Rocky Madden (https://rockymadden.com/)

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
