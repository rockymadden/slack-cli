#!/usr/bin/env bash

function skip-env() {
  if [ -z "${SLACK_CLI_TOKEN}" ]; then skip 'project environment variables should be available'; fi
}

function setup() {
  sleep 2
  skip-env
  echo "${SLACK_CLI_TOKEN}" | build/bin/slack init
}
