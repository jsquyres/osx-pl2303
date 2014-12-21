#!/bin/sh

if test $EUID -ne 0; then
    echo ==== ERROR: must run this script as root
    exit 1
fi

cd /tmp
kextunload osx-pl2303.kext
rm -rf osx-pl2303.kext

