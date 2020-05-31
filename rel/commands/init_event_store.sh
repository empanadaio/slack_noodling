#!/bin/sh

release_ctl eval --mfa "SlackNoodling.ReleaseTask.init_event_store/1" --argv -- "$@"

