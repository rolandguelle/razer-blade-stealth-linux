# Razer Blade Stealth Linux

My personal guide / howto / experiances with a Razer Blade Stealth (late 2016) UHD and Linux.
If you have questions, please contact me: [@rolandguelle](https://twitter.com/rolandguelle)

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

### X11 / Unity

* Settings -> Monitor -> Scale for menu and title bars: 2

### Suspend Issue

Suspend loop issue:
* http://askubuntu.com/questions/849888/suspend-not-working-as-intended-on-razer-blade-stealth-running-xubuntu-16-04/849900

A grub kernel parameter solves the problem.

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

Install razerutils and polychromatic tools:
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

The RBS crashes randomly if you hit "Caps Lock". The build-in driver causes the problem:
```
xinput list
```
If you get "AT Raw Set 2 keyboard", you have a problem if you hit _Caps Lock_ :(

There are two possible solutions: Disable the build-in keyboard driver or replace capslock.

#### Solution 1: Disable built-in keyboard driver

When you install the the razer keyboard driver for linux which you can find [here on GitHub](https://terrycain.github.io/razer-drivers/), you can disable the build-in keyboard driver.

[Config](etc/X11/xorg.conf.d/20-razer.conf)
```
Section "InputClass"
    Identifier      "Disable built-in keyboard"
    MatchIsKeyboard "on"
    MatchProduct    "AT Raw Set 2 keyboard"
    Option          "Ignore"    "true"
EndSection
```
Re'disable keyboard after suspend, [Script](etc/pm/sleep.d/20_razer):

```bash
#!/bin/sh
# http://askubuntu.com/questions/873626/crash-when-toggling-off-caps-lock

case $1 in
    resume|thaw)
	  xinput set-prop "AT Raw Set 2 keyboard" "Device Enabled" 0
    ;;
esac
```

Reference: http://askubuntu.com/questions/873626/crash-when-toggling-off-caps-lock

#### Solution 2: replacing capslocks

Feels like a workaround, but simple solutions are always nice :)
(Thanks to https://github.com/xlinbsd)

Modify /etc/default/keyboard following line, replacing capslocks by a second ctrl, better than nothing:
```
XKBOPTIONS="ctrl:nocaps"
```

### Wireless

Works out of the box, but I updated the firmware: https://wiki.archlinux.org/index.php/Razer#Killer_Wireless_Network_Adapter

### Laptop TLP Tools

```
sudo apt-get install tlp tlp-rdw
sudo systemctl enable tlp
```

### Touchpad

Disable touchpad while typing and some other tunings.

* [50-synaptics.conf](etc/X11/xorg.conf.d/50-synaptics.conf)


#### Gestures

Install [Libinput-gestures](https://github.com/bulletmark/libinput-gestures):

```bash
sudo gpasswd -a $USER input
sudo apt-get install xdotool wmctrl
sudo apt-get install libinput-tools
git clone http://github.com/bulletmark/libinput-gestures
cd libinput-gestures
sudo ./libinput-gestures-setup install
echo "gesture swipe right     xdotool key ctrl+alt+Right" > .config/libinput-gestures.conf
echo "gesture swipe left     xdotool key ctrl+alt+Left" >> .config/libinput-gestures.conf
libinput-gestures-setup autostart
libinput-gestures-setup start
```

Reference: https://github.com/bulletmark/libinput-gestures


### Grafic Card

The [uxa mode](https://wiki.archlinux.org/index.php/Razer#Graphics_Drivers) to avoid flickering isn't needed after updating the intel driver:
* https://01.org/linuxgraphics/downloads/update-tool

#### Multiple monitors X11 (WIP)

Run an external non HDPI monitor above the internal HDPI display.

Actually, I run this [script](bin/extend.sh) manually, but it is a hack - and breaks my screen :(

* TODO: automatic run this script & find a better solution
    * http://askubuntu.com/questions/270374/possible-to-run-a-script-when-something-plugged-in-disconnected-from-mini-disp
    
Wayland looks better and this hack isn't needed. Use Wayland instead of this hack!

Reference: https://wiki.archlinux.org/index.php/HiDPI#Multiple_displays

### Webcam (unsolved)

Working only with 176x in cheese, or 640x480 in guvcview with 15/1 frames.
Unsolved... :(

Reference: https://wiki.archlinux.org/index.php/Razer#Webcam

### Ubuntu Theme tuning

_Has nothing todo with the Razer, but ... :)_

```
sudo apt install unity-tweak-tool
```

#### Install "Arc Darker" and "Paper" Theme & Icons

The arc-icon-theme needs some additional icons:
```
sudo add-apt-repository ppa:noobslab/themes
sudo add-apt-repository ppa:snwh/pulp
sudo apt-get update
sudo apt install breeze-cursor-theme
sudo apt install arc-theme arc-icon-theme
sudo apt install adwaita-icon-theme
sudo apt install moka-icon-theme
sudo apt-get install paper-icon-theme
sudo apt-get install paper-gtk-theme
sudo apt install breeze-cursor-theme
```
Open Unity Tweak Tool:
* "arc-darker" theme & "paper" icons
* Select "Breeze_cursor" with Unity Tweaks.

Reference: http://www.noobslab.com/2017/01/arc-theme-light-dark-versions-and-arc.html

#### Fonts

* Install clear-sans font (manually): https://01.org/clear-sans/downloads
* Install Cantarell font:
```
sudo apt install fonts-cantarell
```

Unity Tweak Tool:
* Text scaling factor: 1
* Default: Clear Sans Regular: 12
* Monospace: Monospace Regular: 11
* Document: Clear Sans Regular: 12
* Title: Clear Sans Bold: 11

## Arch

I use [Antergos](https://antergos.com/) for my Arch experiances, because mostly everything works out-of-the box.
TODO: _Real_ arch installation: https://wiki.archlinux.org/index.php/installation_guide

* Disk resize & fresh install

### Suspend Loop

```
sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="quiet button.lid_init_state=open"
grub-mkconfig -o /boot/grub/grub.cfg
```

Reference: https://wiki.archlinux.org/index.php/razer#GRUB

### Laptop TLP Tools

Install tlp and tlp-rwd

```
sudo systemctl enable tlp
sudo systemctl enable tlp-sleep
```

Reference: https://wiki.archlinux.org/index.php/TLP

### Keyboard Colors (WIP)

Install via pacman:
* python-notify2
* linux-headers
* openrazer-meta


### Gnome, Workspaces, Gestures

I want the same behavior like on my macOS setup, vertical workspaces and gestures for switching.

Install Gnome Extension for vertical worksace alignment:
* https://extensions.gnome.org/extension/484/workspace-grid/
* (setup only vertical workspaces)

Install libinput-gestures via pacman
* .config/libinput-gestures.conf
```
gesture swipe right	_internal ws_up
gesture swipe left	_internal ws_down
gesture swipe down	_internal --col=2 ws_up
gesture swipe up	_internal --col=2 ws_down
```
(looks strange, but this does what it should for me)

Restart libinput-gestures
* libinput-gestures-setup restart

### Multiple monitors (WIP)

Works on Wayland.
But scaling fails on apps chromium, firefox, chrome, ... :(

### Webcam (unsolved)

Unsolved, like Ubuntu

* TODO open...

