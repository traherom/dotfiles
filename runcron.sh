#!/bin/bash
# Always set up env correctly
source $HOME/.profile
echo Running "$@"
exec "$@"

