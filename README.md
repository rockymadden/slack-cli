# slack-cli <sub><sup>| Powerful Slack CLI via pure bash</sup></sub>

[![version](http://img.shields.io/badge/version-0.15.0-blue.svg)](https://github.com/rockymadden/slack-cli/releases)
[![versioning](http://img.shields.io/badge/versioning-semver-blue.svg)](http://semver.org/)
[![branching](http://img.shields.io/badge/branching-github%20flow-blue.svg)](https://guides.github.com/introduction/flow/)
[![license](http://img.shields.io/badge/license-mit-blue.svg)](https://opensource.org/licenses/MIT)
[![circleci](https://circleci.com/gh/rockymadden/slack-cli.svg?style=shield)](https://circleci.com/gh/rockymadden/slack-cli)

A pure bash, pipe friendly, feature rich, command line interface for Slack. Richly formatted
messages are a first class concept, helping you send
[beautiful messages](https://api.slack.com/docs/message-formatting) with ease. Deep integration
with [jq](https://github.com/stedolan/jq) allows for the ability to perform advanced operations
upon JSON responses, helping you perform complex queries and pipe chaining with ease.

__Basic message example:__

```console
$ slack chat send hi @slackbot
```

__Richly formatted message example:__

```console
$ slack chat send \
  --author 'author' \
  --author-icon 'https://assets-cdn.github.com/images/modules/logos_page/Octocat.png' \
  --author-link 'https://github.com/rockymadden/slack-cli' \
  --channel '#channel' \
  --color good \
  --footer 'footer' \
  --footer-icon 'https://assets-cdn.github.com/images/modules/logos_page/Octocat.png' \
  --image 'https://assets-cdn.github.com/images/modules/logos_page/Octocat.png' \
  --pretext 'pretext' \
  --text 'text' \
  --timestamp 123456789 \
  --title 'title' \
  --title-link 'https://github.com/rockymadden/slack-cli'
```

__Pipe chaining example:__

```console
$ # Send a message, update the message, and finally delete the message:
$ slack chat send hello @slackbot --filter '.ts + "\n" + .channel' |
  xargs -n2 slack chat update goodbye --filter '.ts + "\n" + .channel' |
  xargs -n2 slack chat delete
```

## Installation

### Via `brew`

```console
$ brew tap rockymadden/rockymadden
$ brew install rockymadden/rockymadden/slack-cli
```

### Via `curl`

```console
$ curl -O https://raw.githubusercontent.com/rockymadden/slack-cli/master/src/slack
$ chmod +x slack
```

> __PROTIP:__ You are responsible for having `jq` on your `PATH`.

### Via `make`

```console
$ git clone git@github.com:rockymadden/slack-cli.git
$ cd slack-cli
$ make install bindir=/path/to/bin etcdir=/path/to/etc
```

> __PROTIP:__ You are responsible for having `jq` on your `PATH`.

## Configuration

If you want to post from your own account, you need a legacy API token which can be found
[here](https://api.slack.com/custom-integrations/legacy-tokens). If you want to post from a
slackbot, [create one here](https://my.slack.com/services/new/bot). Otherwise, you can create an
app with a [Slack API token](https://api.slack.com/web) and use said API token one of the
following ways:

### Via `init`

```console
$ slack init
```

### Via environment variable

```console
$ export SLACK_CLI_TOKEN='token'
```

## Usage

```console
$ slack --help
Usage:
  slack chat delete [<timestamp> [channel]]
    [--channel|-ch <channel>] [--compact|-c] [--filter|-f <filter>] [--monochrome|-m]
    [--timestamp|-ts <timestamp>] [--trace|-x]

  slack chat send [<text> [channel]]
    [--author|-at <author>] [--author-icon|-ai <author-icon-url>]
    [--author-link|-al <author-link>] [--channel|-ch <channel>] [--color|-cl <color>]
    [--compact|-cp] [--filter|-f <filter>] [--footer|-ft <footer>]
    [--footer-icon|-fi <footer-icon-url>] [--image|-im <image-url>] [--monochrome|-m]
    [--pretext|-pt <pretext>] [--text|-tx <text>] [--thumbnail|-th <thumbnail-url>]
    [--title|-ti <title>] [--title-link|-tl <title-link>] [--trace|-x]

  slack chat update [<text> [<timestamp> [channel]]]
    [--author|-at <author>] [--author-icon|-ai <author-icon-url>]
    [--author-link|-al <author-link>] [--channel|-ch <channel>] [--color|-cl <color>]
    [--compact|-cp] [--filter|-f <filter>] [--footer|-ft <footer>]
    [--footer-icon|-fi <footer-icon-url>] [--image|-im <image-url>] [--monochrome|-m]
    [--pretext|-pt <pretext>] [--text|-tx <text>] [--thumbnail|-th <thumbnail-url>]
    [--timestamp|-ts <timestamp>] [--title|-ti <title>] [--title-link|-tl <title-link>]
    [--trace|-x]

  slack init
    [--compact|-c] [--filter|-f <filter>] [--monochrome|-m] [--token|-tk <token>]
    [--trace|-x]

  slack file delete [file]
    [--compact|-c] [--file|-fl <file>] [--filter|-f <filter>] [--monochrome|-m]
    [--trace|-x]

  slack file info [file]
    [--count|-cn <count>] [--compact|-c] [--file|-fl <file>] [--filter|-f <filter>]
    [--monochrome|-m] [--page|-pg <page>] [--trace|-x]

  slack file list
    [--channel|-ch <channel>] [--count|-cn <count>] [--compact|-c] [--filter|-f <filter>]
    [--monochrome|-m] [--page|-pg <page>] [--timestamp-from|-tf <timetamp>]
    [--timestamp-to|-tt <timestamp>] [--trace|-x] [--types|-ty <types>]
    [--user|-ur <user>]

  slack file upload [<file> [channels]]
    [--channels|-chs <channels>] [--comment|-cm <comment>] [--compact|-c]
    [--file|fl <file>] [--filename|-fn <filename>] [--filter|-f <filter>]
    [--monochrome|-m] [--title|-ti <title>] [--trace|-x]

  slack presence active
    [--compact|-c] [--filter|-f <filter>] [--monochrome|-m] [--trace|-x]

  slack presence away
    [--compact|-c] [--filter|-f <filter>] [--monochrome|-m] [--trace|-x]

  slack reminder add [<user> [<text> [time]]]
    [--compact|-c] [--filter|-f <filter>] [--monochrome|-m] [--text|tx] [--time|tm]
    [--trace|-x] [--user|-ur]

  slack reminder complete [reminder]
    [--compact|-c] [--filter|-f <filter>] [--monochrome|-m] [--reminder|rm] [--trace|-x]

  slack reminder delete [reminder]
    [--compact|-c] [--filter|-f <filter>] [--monochrome|-m] [--reminder|rm] [--trace|-x]

  slack reminder info [reminder]
    [--compact|-c] [--filter|-f <filter>] [--monochrome|-m] [--reminder|rm] [--trace|-x]

  slack reminder list
    [--compact|-c] [--filter|-f <filter>] [--monochrome|-m] [--trace|-x]

  slack snooze end
    [--compact|-c] [--filter|-f <filter>] [--monochrome|-m] [--trace|-x]

  slack snooze info [user]
    [--compact|-c] [--filter|-f <filter>] [--monochrome|-m] [--trace|-x]
    [--user|-ur <user>]

  slack snooze start [minutes]
    [--compact|-c] [--filter|-f <filter>] [--minutes|-mn <minutes>] [--monochrome|-m]
    [--trace|-x]

  slack status edit [<text> [<emoji>]]
    [--compact|-c] [--filter|-f <filter>] [--monochrome|-m] [--trace|-x]

  slack user list

Configuration Commands:
  init    Initialize

Chat Commands:
  chat delete    Delete chat message
  chat send      Send chat message
  chat update    Update chat message

File Commands:
  file delete    Delete file
  file info      Info about file
  file list      List files
  file upload    Upload file

Presence Commands:
  presence active    Active presence
  presence away      Away presence

Reminder Commands:
  reminder add         Add reminder
  reminder complete    Complete reminder
  reminder delete      Delete reminder
  reminder info        Info about reminder
  reminder list        List reminders

Snooze Commands:
  snooze end      End snooze
  snooze info     Info about snooze
  snooze start    Start snooze

Status Commands:
  status edit    Edit status

More Information:
  repo    https://github.com/rockymadden/slack-cli
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

### `chat send`

```console
$ # Send message via prompts:
$ slack chat send
$
$ # Send message via arguments:
$ slack chat send 'Hello world!' '#channel'
$
$ # Send message via options:
$ slack chat send --text 'Hello world!' --channel '#channel'
$
$ # Send message via short form options:
$ slack chat send -tx 'Hello world!' -ch '#channel'
$
$ # Send message via pipe:
$ ls -al | slack chat send --channel '#channel' --pretext 'Directory:' --color good
$
$ # Send message and returning just the timestamp via filter option:
$ slack chat send 'Hello world!' '#channel' --filter '.ts'
```

> __PROTIP:__ See the [Slack attachments documentation](https://api.slack.com/docs/attachments) for
more information about option meanings.

### `chat update`

```console
$ # Update message via prompts:
$ slack chat update
$
$ # Update message via arguments:
$ slack chat update 'Hello world, again!' 1405894322.002768 '#channel'
$
$ # Update message via options:
$ slack chat update --text 'Hello world, again!' --timestamp 1405894322.002768 --channel '#channel'
$
$ # Update message via short form options:
$ slack chat update -tx 'Hello world, again!' -ts 1405894322.002768 -ch '#channel'
$
$ # Send message and immediately update:
$ slack chat send 'Hello world!' '#channel' --filter '.ts + "\n" + .channel' |
  xargs -n2 slack chat update 'Goodbye world!'
```

> __PROTIP:__ See the [Slack attachments documentation](https://api.slack.com/docs/attachments) for
more information about option meanings.

### `chat delete`

```console
$ # Delete message via prompts:
$ slack chat delete
$
$ # Delete message via arguments:
$ slack chat delete 1405894322.002768 '#channel'
$
$ # Delete message via options:
$ slack chat delete --timestamp 1405894322.002768 --channel '#channel'
$
$ # Delete message via short form options:
$ slack chat delete -ts 1405894322.002768 -ch '#channel'
$
$ # Send message and immediately delete:
$ slack chat send 'Hello world!' '#channel' --filter '.ts + "\n" + .channel' |
  xargs -n2 slack chat delete
```

### `file upload`

```console
$ # Upload file via prompts:
$ slack file upload
$
$ # Upload file via arguments:
$ slack file upload README.md '#channel'
$
$ # Upload file via options:
$ slack file upload --file README.md --channels '#channel'
$
$ # Upload file via pipe:
$ ls -al | slack file upload --channels '#channel'
$
$ # Upload file with rich formatting:
$ slack file upload README.md '#channel' --comment 'Comment' --title 'Title'
```

### `file list`

```console
$ # List files:
$ slack file list
$
$ # List files and output only ID and size:
$ slack file list --filter '[.files[] | {id, size}]'
```

### `file info`

```console
$ # Info about file via prompts:
$ slack file info
$
$ # Info about file via arguments:
$ slack file info F2147483862
$
$ # Info about file via options:
$ slack file info --file F2147483862
```

### `file delete`

```console
$ # Delete file via prompts:
$ slack file delete
$
$ # Delete file via arguments:
$ slack file delete F2147483862
$
$ # Delete file via options:
$ slack file delete --file F2147483862
```

### `presence active`

```console
$ # Active presence:
$ slack presence active
```

### `reminder list`

```console
$ # List reminders:
$ slack reminder list
```

### `reminder add`

```console
$ # Add reminder via prompts:
$ slack reminder add
$
$ # Add reminder via arguments:
$ slack reminder add '@slackbot' 'lunch' 1526995300
$
$ # Add reminder via options:
$ slack reminder add --user="@slackbot" --text="lunch" --time=1526995300
```

### `reminder complete`

```console
$ # Complete reminder via prompts:
$ slack reminder complete
$
$ # Complete reminder via arguments:
$ slack reminder complete Rm7MGABKT6
$
$ # Complete reminder via options:
$ slack reminder complete --reminder="Rm7MGABKT6"
```

### `reminder delete`

```console
$ # Complete reminder via prompts:
$ slack reminder delete
$
$ # Complete reminder via arguments:
$ slack reminder delete "Rm7MGABKT6"
$
$ # Complete reminder via options:
$ slack reminder delete --reminder="Rm7MGABKT6"
```

### `reminder info`

```console
$ # Info about reminder via prompts:
$ slack reminder info
$
$ # Info about reminder via arguments:
$ slack reminder info "Rm7MGABKT6"
$
$ # Info about reminder via options:
$ slack reminder info --reminder="Rm7MGABKT6"
```

### `presence away`

```console
$ # Away presence:
$ slack presence away
```

### `snooze start`

```console
$ # Start snooze via prompts:
$ slack snooze start
$
$ # Start snooze via arguments:
$ slack snooze start 60
$
$ # Start snooze via options:
$ slack snooze start --minutes 60
$
$ # Start snooze via short form options:
$ slack snooze start -mn 60
```

### `snooze info`

```console
$ # Info about your own snooze:
$ slack snooze info
$
$ # Info about another user's snooze via argument:
$ slack snooze info @slackbot
$
$ # Info about another user's snooze via options:
$ slack snooze info --user @slackbot
$
$ # Info about another user's snooze via short form options:
$ slack snooze info -ur @slackbot
```

### `snooze end`

```console
$ # End snooze:
$ slack snooze end
```

### `status edit`

```console
$ # Edit status:
$ slack status edit
$
$ # Edit status via arguments:
$ slack status edit lunch :hamburger:
$
$ # Edit status via options:
$ slack status edit --text lunch --emoji :hamburger:
$
$ # Edit status via short form options:
$ slack status edit --tx lunch -em :hamburger:
```

## License

```text
The MIT License (MIT)

Copyright (c) 2018 Rocky Madden (https://rockymadden.com/)

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
