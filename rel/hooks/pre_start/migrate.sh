#!/bin/sh

echo "Running migrations"
bin/slack_noodling migrate
echo "Migrations run successfully"
