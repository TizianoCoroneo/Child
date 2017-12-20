#!/bin/bash

#  install.sh
#  Child
#
#  Created by Tiziano Coroneo on 20/12/2017.
#  

swift build -c release -Xswiftc -static-stdlib
echo "cp .build/release/child /usr/local/bin/child"
cp .build/release/child /usr/local/bin/child
