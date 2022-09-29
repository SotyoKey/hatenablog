#!bin/bash
set -eu

for file_path in "$@"; do
  if [[ "$file_path" =~ .*\.md ]] ; then
    echo $file_path
    bin/blogsync push $file_path
  fi
done
