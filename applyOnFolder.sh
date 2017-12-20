#!/bin/bash

#  applyOnFolder.sh
#  Child
#
#  Created by Tiziano Coroneo on 20/12/2017.
#  

DIRECTORY="$1"

shift

if test -d "$DIRECTORY"Generated
then rm -r "$DIRECTORY"Generated
fi

mkdir "$DIRECTORY"Generated

for file in "$DIRECTORY"*.json
  do
    filename="${file##*/}"
    filenameWithoutExtension="${filename%.*}"
    echo "${@:1}"
    child -i "$file" "${@:1}" > "$DIRECTORY"Generated/"$filenameWithoutExtension".swift
  done
