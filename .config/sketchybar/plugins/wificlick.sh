#!/bin/bash
launchctl asuser $(id -u) open -a kitty --args -e btop
