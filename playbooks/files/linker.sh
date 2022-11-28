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

parent="$(dirname "$src")"
if [ ! -e "$parent" ]; then
    echo Creating directory "$parent"
    mkdir -p "$parent" || exit 1
fi

# Does the link already exist and point to the correct location?
current_target=$(readlink "$src")
if [[ "$current_target" != "$target" ]]; then
    echo "Linking $src => $target"
    rm -rf "$src" || exit 1
    ln -s "$target" "$src" || exit 1
fi
