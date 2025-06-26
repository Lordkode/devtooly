#!/bin/bash

# Pointe vers le script principal dans src/bin
exec "$(dirname "$0")/src/bin/devtooly.sh" "$@"
