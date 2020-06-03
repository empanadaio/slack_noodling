#!/bin/sh

echo "Running migrations"
bin/slack_noodling rpc "SlackNoodling.ReleaseTask.migrate"
echo "Migrations run successfully"
