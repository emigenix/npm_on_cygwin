#!/bin/bash
# Use with:
# $ mv /bin/git /bin/gitbin
# $ vim /bin/git

declare -a ARGS
for arg in "$@"; do
  if [[ $arg == *"\\"* ]]; then
    ARGS+=("$(cygpath "$arg")");
  else
    ARGS+=("$arg");
  fi
done
command /bin/gitbin "${ARGS[@]}"
