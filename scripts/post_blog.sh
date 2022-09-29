#!bin/bash
set -eu

for file_path in "$@"; do
  if ! expr $file_path : '*.md' > /dev/null ; then
    continue
  fi
  bin/blogsync push file_path
done
