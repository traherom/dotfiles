#!/bin/sh
DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
echo "Launching from $DIR"

if [ -f "$DIR/venv/bin/activate" ]; then
    . "$DIR/venv/bin/activate"
else
    sh "$DIR/setup.sh" || exit 1
fi

qtile
