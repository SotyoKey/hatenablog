#!bin/bash
set -eu

for file_path in "$@"; do
  if expr $file_path : '*\.md' > /dev/null ; then
    echo $file_path
    bin/blogsync push $file_path
  fi
done
