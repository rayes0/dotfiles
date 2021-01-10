#!/bin/bash

autorandr --change
wmctrl -s 0
wmctrl -s 1
wmctrl -s 2
wmctrl -s 0
nitrogen --restore
