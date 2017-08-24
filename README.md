# Razer Blade Stealth Linux

My personal experiances with a Razer Blade Stealth (late 2016) UHD and Linux.

If you have questions, please contact me at twitter: [@rolandguelle](https://twitter.com/rolandguelle)

* [Ubuntu](#ubuntu)
* [Arch](#arch)

## Preparation

* Run Bios updates via Windows the installed Windows 10
	* http://www.razersupport.com/gaming-systems/razer-blade-stealth/
	* Direct Links:
		* http://dl.razerzone.com/support/BladeStealthH2/BladeStealthUpdater_v1.0.5.3_BIOS6.05.exe.7z
		* http://dl.razerzone.com/support/BladeStealthH2/BladeStealthUpdater_v1.0.5.0.zip

## Ubuntu

* Resize disk with live linux (Ubuntu installation)
* Fresh install (I run an updated 16.10 -> 17.04)

### X11

Switch to 1920x1080 resulution - works best with multiple monitors :)

Alternative:

* Settings -> Monitor -> Scale for menu and title bars: 2


### Wayland (Alternative)

Buggy with multiple Monitors, but my current setup with Gnome.

### Suspend Loop Issue

Suspend loop issue:
* http://askubuntu.com/questions/849888/suspend-not-working-as-intended-on-razer-blade-stealth-running-xubuntu-16-04/849900

This kernel parameter solves the problem:
```shell
$ sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="quiet button.lid_init_state=open"
```

Update grub
```shell
$ sudo update-grub
```

Reference: https://wiki.archlinux.org/index.php/Razer#GRUB

### Keyboard Colors

Install razerutils and polychromatic tools:
```shell
$ sudo add-apt-repository ppa:terrz/razerutils
$ sudo add-apt-repository ppa:lah7/polychromatic
$ sudo apt update
$ sudo apt install python3-razer razer-kernel-modules-dkms razer-daemon razer-doc polychromatic
```

Reference: https://github.com/lah7/polychromatic

### Caps Lock Issue

The RBS crashes randomly if you hit "Caps Lock". The build-in driver causes the problem:
```shell
$ xinput list | grep "Set 2 keyboard"
```
If you get something like **"AT Raw Set 2 keyboard"**, **"AT Translated Set 2 keyboard"** or ... - you have a problem, if you hit _Caps Lock_ :(

There are two possible solutions: Disable build-in keyboard driver or replace capslock.

#### Solution 1: Disable built-in keyboard driver

Get your keyboard description and use it instead of "AT Raw Set 2 keyboard":
```shell
$ xinput list | grep "Set 2 keyboard"
```

[Config](etc/X11/xorg.conf.d/20-razer.conf)
```
Section "InputClass"
    Identifier      "Disable built-in keyboard"
    MatchIsKeyboard "on"
    MatchProduct    "AT Raw Set 2 keyboard"
#	MatchProduct    "AT Translated Set 2 keyboard"
    Option          "Ignore"    "true"
EndSection
```

Re'disable keyboard after suspend, [Script](etc/pm/sleep.d/20_razer):

```shell
#!/bin/sh
# http://askubuntu.com/questions/873626/crash-when-toggling-off-caps-lock

case $1 in
    resume|thaw)
	  xinput set-prop "AT Raw Set 2 keyboard" "Device Enabled" 0
# 	  xinput set-prop "AT Translated Set 2 keyboard" "Device Enabled" 0
    ;;
esac
```

Reference: http://askubuntu.com/questions/873626/crash-when-toggling-off-caps-lock
 
#### Solution 2: replace capslocks

Thanks to https://github.com/xlinbsd

Modify /etc/default/keyboard following line, replacing capslocks by a second ctrl:
```shell
$ sudo nano /etc/default/keyboard 
XKBOPTIONS="ctrl:nocaps"
```

### Wireless

Works out of the box, but I updated the firmware:
* https://wiki.archlinux.org/index.php/Razer#Killer_Wireless_Network_Adapter

### Laptop TLP Tools

```shell
$ sudo apt-get install tlp tlp-rdw
$ sudo systemctl enable tlp
```

### Touchpad

Disable touchpad while typing and some other tunings:
* [50-synaptics.conf](etc/X11/xorg.conf.d/50-synaptics.conf)


#### Gestures

Install [Libinput-gestures](https://github.com/bulletmark/libinput-gestures):

```shell
$ sudo gpasswd -a $USER input
$ sudo apt-get install xdotool wmctrl libinput-tools
$ git clone http://github.com/bulletmark/libinput-gestures
$ cd libinput-gestures
$ sudo ./libinput-gestures-setup install
$ echo "gesture swipe right     xdotool key ctrl+alt+Right" > .config/libinput-gestures.conf
$ echo "gesture swipe left     xdotool key ctrl+alt+Left" >> .config/libinput-gestures.conf
$ libinput-gestures-setup autostart
$ libinput-gestures-setup start
```

Reference: https://github.com/bulletmark/libinput-gestures


### Grafic Card

The [uxa mode](https://wiki.archlinux.org/index.php/Razer#Graphics_Drivers) to avoid flickering isn't needed after updating the intel driver:
* https://01.org/linuxgraphics/downloads/update-tool

### HDMI

Works with kernel update or switch to 17.04, but only the Video signal (not sound).
Sound is detected, but without result on the HDMI screen.
Works on Arch Linux with 4.12.4 kernel.

#### Multiple monitors X11 (failure)

Run an external non HDPI monitor above the internal HDPI display.
I played with this [script](bin/extend.sh), but it is a hack - and breaks my screen :(
    
Wayland looks better and this hack isn't needed. Use Wayland instead of this hack!

References:
* https://wiki.archlinux.org/index.php/HiDPI#Multiple_displays
* http://askubuntu.com/questions/270374/possible-to-run-a-script-when-something-plugged-in-disconnected-from-mini-disp


### Webcam (unsolved)

Working only with 176x in cheese, or 640x480 in guvcview with 15/1 frames.
Unsolved... :(

Reference: https://wiki.archlinux.org/index.php/Razer#Webcam

### Ubuntu Theme tuning

_Has nothing todo with the Razer, but ... :)_

```shell
$ sudo apt install unity-tweak-tool
```

#### Install "Arc Darker" and "Paper" Theme & Icons

The arc-icon-theme needs some additional icons:
```shell
$ sudo add-apt-repository ppa:noobslab/themes
$ sudo add-apt-repository ppa:snwh/pulp
$ sudo apt-get update
$ sudo apt install breeze-cursor-theme arc-theme arc-icon-theme adwaita-icon-theme moka-icon-theme paper-icon-theme paper-gtk-theme breeze-cursor-theme
```
Open Unity Tweak Tool:
* "arc-darker" theme & "paper" icons
* Select "Breeze_cursor" with Unity Tweaks.

Reference: http://www.noobslab.com/2017/01/arc-theme-light-dark-versions-and-arc.html

#### Fonts

* Install clear-sans font (manually): https://01.org/clear-sans/downloads
* Install Cantarell font:
```shell
$ sudo apt install fonts-cantarell
```

Unity Tweak Tool:
* Text scaling factor: 1
* Default: Clear Sans Regular: 12
* Monospace: Monospace Regular: 11
* Document: Clear Sans Regular: 12
* Title: Clear Sans Bold: 11

## Arch

I installed [Antergos](https://antergos.com/) Arch, but should be work with other Arch distros.

### Suspend Loop Issue

```shell
$ sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="quiet button.lid_init_state=open"
```

Update Grub
```shell
$ grub-mkconfig -o /boot/grub/grub.cfg
```

Reference: https://wiki.archlinux.org/index.php/razer#GRUB

### Laptop TLP Tools

Install TLP tools:
```shell
$ sudo pacman -S tlp tlp-rdw
```

Enable TLP tools:
```shell
$ sudo systemctl enable tlp
$ sudo systemctl enable tlp-sleep
```

Reference: https://wiki.archlinux.org/index.php/TLP

### Keyboard Colors

There are problems after resume, where the keyboard lighting won't work.
Without drivers, keyboard lighting works :)

### Gnome, Workspaces, Gestures

Install libinput-gestures via software package manager:
* libinput-gesture

Setup libinput gesture:
```shell
$ sudo gpasswd -a $USER input
```
logout, login:
```
$ libinput-gestures-setup start
$ libinput-gestures-setup autostart
```

Configuration files are at:
   /etc/libinput-gestures.conf (system wide default)
   $HOME/.config/libinput-gestures.conf (optional per user)

```shell
$ nano .config/libinput-gestures.conf
gesture swipe down      _internal ws_upWa
gesture swipe up        _internal ws_down
```
_(if you prefer natural scrolling, change up/down)_

Restart libinput-gestures
```shell
$ libinput-gestures-setup restart
```

### Wireless

Works out of the box.

### Multiple monitors, libinput, HDPI, Wayland

I tried Wayland, libinput and HDPI, but (sadly) I must agree to "Vuv" comment:
* https://insider.razerzone.com/index.php?threads/arch-linux-on-the-2017-razer-blade.24833/#post-371727


Switch back to:
* X11
* 1920x1080 resulution
* Synaptics driver

Use this config for "Disable touchpad while typing" tunings:
* [50-synaptics.conf](etc/X11/xorg.conf.d/50-synaptics.conf)


### Webcam

Working only with 176x in cheese, or 640x480 in guvcview with 15/1 frames.
Unsolved... :(

Reference: https://wiki.archlinux.org/index.php/Razer#Webcam

The suggested solution does not work:

```shell
$ nano /etc/modprobe.d/uvcvideo.conf
## fix issue with built-in webcam
options uvcvideo quirks=512
```

### Gnome Theme

#### Appeareance

* GTK+ Theme: Arc-Darker
* Icons: Numix-Square
* Cursor: Capitaine
* Shell theme: Paper

