#!/bin/bash

killall polybar -q

polybar -c ~/.config/polybar/config.ini main 2>&1 | tee -a /tmp/polybar.log & disown
