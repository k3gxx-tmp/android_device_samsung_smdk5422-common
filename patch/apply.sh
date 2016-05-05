#!/bin/sh

MYABSPATH=$(readlink -f "$0")
PATCHBASE=$(dirname "$MYABSPATH")
CMBASE=$(readlink -f "$PATCHBASE/../../../../")
#
#/cd "$CMBASE/bootable/recovery"
#if git remote -v | grep omnirom; then
 #   TWRP=true
#else
#    TWRP=false
#fi

for i in $(find "$PATCHBASE"/* -type d); do
    PATCHNAME=$(basename "$i")
    PATCHTARGET=$PATCHNAME
    for j in $(seq 4); do
        PATCHTARGET=$(echo $PATCHTARGET | sed 's/_/\//')
        if [ -d "$CMBASE/$PATCHTARGET" ]; then break; fi
    done

    echo
    echo applying $PATCHNAME to $PATCHTARGET
    cd "$CMBASE/$PATCHTARGET" || exit 1

    suffix=".patch"
    if [ $PATCHNAME = "bootable_recovery" -a $TWRP = true ]; then suffix=".twrp.patch"; fi
    if [ $PATCHNAME = "bootable_recovery" -a $TWRP = false ]; then suffix=".cm.patch"; fi
    git am --ignore-whitespace -3 "$PATCHBASE/$PATCHNAME"/*${suffix} || exit 1
done
