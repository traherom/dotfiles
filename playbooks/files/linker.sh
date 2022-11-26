#!/bin/bash
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <target> <name>"
    exit 1
fi

target="$1"
src="$2"

if [ ! -e "$target" ]; then
    echo "$target does not exist but a link to it was requested"
    exit 2
fi

if [[ "$(id -u)" == "0" ]]; then
    hard_link="yes"
else
    hard_link=""
fi

parent="$(dirname "$src")"
if [ ! -e "$parent" ]; then
    echo Creating directory "$parent"
    mkdir -p "$parent" || exit 1
fi

# Does the link already exist and point to the correct location?
# For hard links, this won't work and we'll always re-created it
# We could maybe do a stat check to see the inode count
# (stat -c %h -- "$file"), but that seems like a lot of extra complication
# given that we still won't know for sure that the inode points
# to the file we copied over
current_target=$(readlink "$src")
if [[ "$current_target" != "$target" ]]; then
    echo "Linking $src => $target"
    rm -rf "$src" || exit 1

    # For root, do a hard link. The goal is to avoid any warning from systems that are
    # senstive about how protected files are
    if [ -z "$hard_link" ]; then
        ln "$target" "$src" || exit 1
    else
        ln -s "$target" "$src" || exit 1
    fi
fi
