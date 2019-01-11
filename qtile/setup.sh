#!/bin/sh
DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if [ ! -f "$DIR/venv/bin/activate" ]; then
    python3 -m venv "$DIR/venv" || exit 1
fi

. "$DIR/venv/bin/activate" || exit 1
pip install --upgrade pip || exit 1
pip install -r "$DIR/requirements.txt" || exit 1

set -x
sudo cp "$DIR/"*.desktop /usr/share/xsessions || echo "WARNING: Unable to install session file"
