#!/bin/sh
# extend non-HiDPI external display on DP* above HiDPI internal display eDP*
# see also https://wiki.archlinux.org/index.php/HiDPI
# you may run into https://bugs.freedesktop.org/show_bug.cgi?id=39949
#                  https://bugs.launchpad.net/ubuntu/+source/xorg-server/+bug/883319

EXT=`xrandr --current | sed 's/^\(.*\) connected.*$/\1/p;d' | grep -v ^eDP | head -n 1`
INT=`xrandr --current | sed 's/^\(.*\) connected.*$/\1/p;d' | grep -v ^DP | head -n 1`

#ext_w=`xrandr | sed 's/^'"${EXT}"' [^0-9]* \([0-9]\+\)x.*$/\1/p;d'`
ext_h=`xrandr | sed 's/^'"${EXT}"' [^0-9]* [0-9]\+x\([0-9]\+\).*$/\1/p;d'`
#int_w=`xrandr | sed 's/^'"${INT}"' [^0-9]* \([0-9]\+\)x.*$/\1/p;d'`
#int_h=`xrandr | sed 's/^'"${INT}"' [^0-9]* [0-9]\+x\([0-9]\+\).*$/\1/p;d'`

#xrandr --output "${INT}" --auto --pos ${off_w}x${ext_h} --scale 1x1  --output "${EXT}" --auto --scale 2x2 --pos 0x0
xrandr --output "${INT}" --auto --pos 0x${ext_h} --scale 1x1  --output "${EXT}" --auto --scale 2x2 --pos 0x0
