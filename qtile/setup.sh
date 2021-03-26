#!/bin/sh
DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if [ ! -f "$DIR/venv/bin/activate" ]; then
    python3 -m venv "$DIR/venv" || exit 1
fi

# Needed packages: 
# Fedora: libffi-devel cairo-devel pango-devel

. "$DIR/venv/bin/activate" || exit 1
pip install --upgrade pip || exit 1
pip install wheel || exit 1
pip install xcffib || exit 1
pip install cairocffi || exit 1
# pip install python-dbus || exit 1
# pip install dbus-python || exit 1
# pip install python-gobject || exit 1
pip install qtile==0.16.1 || exit 1

set -x
sudo cp "$DIR/"*.desktop /usr/share/xsessions || echo "WARNING: Unable to install session file"
