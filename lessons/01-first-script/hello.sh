#!/usr/bin/env bash
# A tiny first script: print who is running it and where.
printf 'Hello from Bash!\n'
printf 'Current user: %s\n' "${USER:-unknown}"
printf 'Current directory: %s\n' "$PWD"
