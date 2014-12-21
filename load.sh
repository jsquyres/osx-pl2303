#!/bin/sh

#
# Take a good guess at where XCode built the thing.
# Or, if $1 is supplied, try to use that
#

if test -n "$1"; then
    dir=$1
else
    dir=$HOME/Library/Developer/Xcode/DerivedData
    subdir=`/bin/ls -d $dir/osx-pl2303-*`
    if test -z "$subdir"; then
        echo "==== ERROR: Could not find right subdirectory"
        echo "==== $dir"
        exit 1
    fi
    if test "`echo $subdir | wc -w`" -ne 1; then
        echo "==== ERROR: Found more than one possible subdirectory"
        echo "==== $dir"
        exit 1
    fi
    # For XCode 6.1.1
    dir="$subdir/Build/Products/Debug"
fi

if test ! -d $dir; then
    echo "==== ERROR: directory does not exist"
    echo "==== $dir"
    exit 1
fi

if test $EUID -ne 0; then
    echo "==== ERROR: must run this script as root"
    exit 1
fi

echo "==== Loading the kernel driver..."
set -x

cp -R $dir/osx-pl2303.kext /System/Library/Extensions
cd /System/Library/Extensions
chown -R root:wheel osx-pl2303.kext
chmod -R 755 osx-pl2303.kext
kextcache -e
kextload osx-pl2303.kext

