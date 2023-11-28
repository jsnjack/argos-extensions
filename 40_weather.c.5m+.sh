#!/usr/bin/env bash
# Get the location of the current script
DIR="$(dirname $BASH_SOURCE)"
invenv -s -- $DIR/weather.py
