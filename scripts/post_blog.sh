#!bin/bash
set -eu

for file_path in "$@"; do
  if ! expr $file_path : '*.md' > /dev/null ; then
    continue
  fi
  echo $file_path
  bin/blogsync push $file_path
done
