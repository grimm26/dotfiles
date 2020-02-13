#!/bin/bash

for file in $(find . -type f -print);do
  [[ -s ~/${file} ]] && diff -u $file ~/${file}
done
