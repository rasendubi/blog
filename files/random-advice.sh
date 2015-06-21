#!/bin/sh
export DISPLAY=:0
CAPTION="Random advice"
PHRASES=$HOME/phrases.txt
cat "$PHRASES" | sed '/^$/d' | sort -R | head -n 1 | tr -d '\n' | xargs -0 notify-send "$CAPTION"
