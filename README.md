# Razer Blade Stealth Linux

Razer Blade Stealth (late 2016) HiDPI Linux installation & configuration.

Work in progress...

## Preparation

* Bios Updates: http://www.razersupport.com/gaming-systems/razer-blade-stealth/
 * http://dl.razerzone.com/support/BladeStealthH2/BladeStealthUpdater_v1.0.5.3_BIOS6.05.exe.7z
 * http://dl.razerzone.com/support/BladeStealthH2/BladeStealthUpdater_v1.0.5.0.zip
 
## Ubuntu 16.10

* Disk resize & fresh install
* Settings -> Monitor -> Scale for menu and title bars: 2

### Suspend

Suspend loop issue:
* http://askubuntu.com/questions/849888/suspend-not-working-as-intended-on-razer-blade-stealth-running-xubuntu-16-04/849900

Grub kernel parameter solves the problem.

Configuration: /etc/default/grub
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet button.lid_init_state=open"
```

Update grub
```
sudo update-grub
```

Reference: https://wiki.archlinux.org/index.php/Razer#GRUB

### Keyboard Colors

Install razer utils and polychromatic tools:
```
sudo add-apt-repository ppa:terrz/razerutils
sudo apt update
sudo apt install python3-razer razer-kernel-modules-dkms razer-daemon razer-doc
sudo add-apt-repository ppa:lah7/polychromatic
sudo apt update
sudo apt install polychromatic
```

Reference: https://github.com/lah7/polychromatic

### Caps Lock Issue

The RBS crashes randomly if you hit Caps Lock. The build in driver causes the problem:
```
xinput list
```
If you get "AT Raw Set 2 keyboard", you have a problem if you hit _Caps Lock_.


How to fix it?

Config: /etc/X11/xorg.conf.d/20-razer.conf 
```
Section "InputClass"
    Identifier      "Disable built-in keyboard"
    MatchIsKeyboard "on"
    MatchProduct    "AT Raw Set 2 keyboard"
    Option          "Ignore"    "true"
EndSection
```

Re'disable keyboard after suspend:

Script: /etc/pm/sleep.d/20_razer 
```
#!/bin/sh
# http://askubuntu.com/questions/873626/crash-when-toggling-off-caps-lock

case $1 in
     suspend|suspend_hybrid|hibernate)
	# everything is fine
        ;;
     resume|thaw)
	 xinput set-prop "AT Raw Set 2 keyboard" "Device Enabled" 0
        ;;
esac
```

Reference: http://askubuntu.com/questions/873626/crash-when-toggling-off-caps-lock


### Grafic Card

#### uxa mode (not needed after update)

File: /etc/X11/xorg.conf.d/20-intel.conf 

```
Section "Device"
  Identifier  "Intel Graphics"
  Driver      "intel"
  Option      "AccelMethod"  "uxa"
  #Option      "AccelMethod"  "sna"
EndSection
```

Reference: https://wiki.archlinux.org/index.php/Razer#Graphics_Drivers


#### update linuxgraphics

After installing and updating with:
* https://01.org/linuxgraphics/downloads/update-tool

the problems are gone and the Razer runs **without** this setting in "sna" mode.


### wireless (not used)

Reference: https://wiki.archlinux.org/index.php/Razer#Killer_Wireless_Network_Adapter

### HDMI Output


The HDMI works when I boot with an external monitor, but not when plugging it into a running ubuntu :(

Swithing Ubuntu to the 4.10.3 kernel solves the problem:


```
sudo add-apt-repository -y ppa:teejee2008/ppa
sudo apt update
sudo apt install ukuu
```

open ukuu and install new kernel

Reference: https://www.linuxbabe.com/ubuntu/install-linux-kernel-4-10-ubuntu-16-04-ukuu

### Multiple monitors

I run the external monitor above the internal display.

Script: extend.sh
```
EXT=`xrandr --current | sed 's/^\(.*\) connected.*$/\1/p;d' | grep -v ^eDP | head -n 1`
INT=`xrandr --current | sed 's/^\(.*\) connected.*$/\1/p;d' | grep -v ^DP | head -n 1`
ext_h=`xrandr | sed 's/^'"${EXT}"' [^0-9]* [0-9]\+x\([0-9]\+\).*$/\1/p;d'`
xrandr --output "${INT}" --auto --pos 0x${ext_h} --scale 1x1  --output "${EXT}" --auto --scale 2x2 --pos 0x0
```

Reference: https://wiki.archlinux.org/index.php/HiDPI#Multiple_displays


### Webcam (unsolved)

Working only with 176x in cheese, or 640x480 in other tools

Reference: https://wiki.archlinux.org/index.php/Razer#Webcam

### Theme tuning

_Has nothing todo with the Razer, but ... :)_

```
sudo apt install unity-tweak-tool
```

#### Install Arc Darker Theme

```
sudo add-apt-repository ppa:noobslab/themes
sudo apt install breeze-cursor-theme
sudo apt install arc-theme arc-icon-theme
```

the arc-icon-theme need this icons:
```
sudo apt install adwaita-icon-theme
sudo apt install moka-icon-theme
```

Open Unity Tweak Tool, choose arc-darker Theme

Reference: http://www.noobslab.com/2017/01/arc-theme-light-dark-versions-and-arc.html

#### Fonts

* Install clear-sans font: https://01.org/clear-sans/downloads
* Install Cantarell font:
```
sudo apt install fonts-cantarell
```

Unity Tweak Tool:
* Text scaling factor: 1,25
* Default: Clear Sans Regular: 10
* Monospace: Monospace Regular: 10
* Document: Cantarell Regular: 10
* Title: Clear Sans Regular: 8


#### Cursor

```
sudo apt install breeze-cursor-theme
```

Select "Breeze_cursor" with Unity Tweaks.


### Laptop TLP Tools

```
sudo apt-get install tlp tlp-rdw
sudo systemctl enable tlp
```

### Ad Blocker

https://github.com/StevenBlack/hosts

## Arch (WIP)

Using Apricityos: https://apricityos.com/download

No caps lock or gfx issues & HDMI works :)

Current status:
* suspend loop (solved)
* web cam (unsolved)

### Suspend loop

Added kernel parameter to GRUB
```
button.lid_init_state=open
```
https://wiki.archlinux.org/index.php/razer#GRUB

### Webcam (unsolved)

status like ubuntu :(

