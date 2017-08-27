#!/bin/bash
# extend non-HiDPI external display on DP* above HiDPI internal display eDP*
# see also https://wiki.archlinux.org/index.php/HiDPI
# you may run into https://bugs.freedesktop.org/show_bug.cgi?id=39949
#                  https://bugs.launchpad.net/ubuntu/+source/xorg-server/+bug/883319

# DON't use this script! Switch to non HDPI resulution (eg 1920x1080).

function getScreenParameters() {
    EXT=`xrandr --current | sed 's/^\(.*\) connected.*$/\1/p;d' | grep -v ^eDP | head -n 1`
    INT=`xrandr --current | sed 's/^\(.*\) connected.*$/\1/p;d' | grep -v ^DP | head -n 1`
    ext_h=`xrandr | sed 's/^'"${EXT}"' [^0-9]* [0-9]\+x\([0-9]\+\).*$/\1/p;d'`
}

getScreenParameters
xrandr --output "${INT}" --auto --pos 0x${ext_h} --scale 1x1  --output "${EXT}" --auto --scale 2x2 --pos 0x0
# this must be a bug, but the first run the external scaling isn't 2x2
# to run this script without any pre-scaling detections, do this twice
getScreenParameters
xrandr --output "${INT}" --auto --pos 0x${ext_h} --scale 1x1  --output "${EXT}" --auto --scale 2x2 --pos 0x0
