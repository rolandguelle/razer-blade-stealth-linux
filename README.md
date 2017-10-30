# Razer Blade Stealth Linux

Personal experiences with a Razer Blade Stealth (late 2016) UHD and Linux.
Contact me at twitter [@rolandguelle](https://twitter.com/rolandguelle) for questions.

Solved issues:
* Suspend loop
* Caps-Lock freeze
* Disabled touchpad after suspend
* Wifi connection lost randomly

Unsolved issues:
* Webcam

Distros:
* [Ubuntu](#ubuntu)
* [Arch](#arch)

## Preparation

* Run Bios updates via installed Windows 10
	* http://www.razersupport.com/gaming-systems/razer-blade-stealth/
	* Direct Links:
		* http://dl.razerzone.com/support/BladeStealthH2/BladeStealthUpdater_v1.0.5.3_BIOS6.05.exe.7z
		* http://dl.razerzone.com/support/BladeStealthH2/BladeStealthUpdater_v1.0.5.0.zip

## Ubuntu 17.10

* Resize disk on Windows
    * https://www.howtogeek.com/101862/how-to-manage-partitions-on-windows-without-downloading-any-other-software/ 
* Fresh install, reboot
* Software & Updates
	* Additional Drivers: Using Processor microcode firmware for Intel CPUs from intel-microcode (proprietary)

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

### Caps Lock Issue

The RBS crashes randomly if you hit "Caps Lock". The build-in driver causes the problem.

#### Wayland & X11: disable capslocks

Thanks to https://github.com/xlinbsd

Modify /etc/default/keyboard following line, replacing capslocks by a second ctrl:
```shell
$ sudo nano /etc/default/keyboard 
XKBOPTIONS="ctrl:nocaps"
```

#### X11: Disable built-in keyboard driver

Get your keyboard description and use it instead of "AT Raw Set 2 keyboard":
```shell
$ xinput list | grep "Set 2 keyboard"
```

[Config](etc/X11/xorg.conf.d/20-razer.conf)
```
Section "InputClass"
    Identifier      "Disable built-in keyboard"
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

### Laptop TLP Tools

```shell
$ sudo apt-get install tlp tlp-rdw
$ sudo systemctl enable tlp
```

### Touchpad Suspend Issue

#### Wayland: libinput

Touchpad fails resuming from suspend with:

```
rmi4_physical rmi4-00: rmi_driver_reset_handler: Failed to read current IRQ mask.
dpm_run_callback(): i2c_hid_resume+0x0/0x120 [i2c_hid] returns -11
PM: Device i2c-15320205:00 failed to resume async: error -11
```

##### Temporary fix

```shell
$ sudo rmmod i2c_hid && sudo modprobe i2c_hid
```

##### Permanent fix + Gestures

Install [Libinput-gestures](https://github.com/bulletmark/libinput-gestures) solves the problem:

```shell
$ sudo gpasswd -a $USER input
$ sudo apt install xdotool wmctrl libinput-tools
$ git clone http://github.com/bulletmark/libinput-gestures
$ cd libinput-gestures
$ sudo ./libinput-gestures-setup install
```

Logout - Login (if not, you get an error)

```shell
$ nano .config/libinput-gestures.conf
gesture swipe down      _internal ws_up
gesture swipe up        _internal ws_down
$ libinput-gestures-setup autostart
$ libinput-gestures-setup start
```
_(if you prefer natural scrolling, change up/down)_

Reference: https://github.com/bulletmark/libinput-gestures

##### Tweaks

macOS touchpad feeling:

```shell
$ sudo apt install gnome-tweak-tool
```
* Keyboard & Mouse
* Click Method: Fingers

#### X11: synaptics 

Disable touchpad while typing and some other tunings:
* [50-synaptics-ubuntu.conf](etc/X11/xorg.conf.d/50-synaptics-ubuntu.conf)

##### Gestures

libinput-gestures work also great with Synaptics / X11 :)

Install [Libinput-gestures](https://github.com/bulletmark/libinput-gestures):

```shell
$ sudo gpasswd -a $USER input
$ sudo apt-get install xdotool wmctrl libinput-tools
$ git clone http://github.com/bulletmark/libinput-gestures
$ cd libinput-gestures
$ sudo ./libinput-gestures-setup install
```

Logout - Login (if not, you get an error)

```shell
$ echo "gesture swipe right     xdotool key ctrl+alt+Right" > .config/libinput-gestures.conf
$ echo "gesture swipe left     xdotool key ctrl+alt+Left" >> .config/libinput-gestures.conf
$ libinput-gestures-setup autostart
$ libinput-gestures-setup start
```

Reference: https://github.com/bulletmark/libinput-gestures

### Keyboard Colors

Currently not installed.

Issue: (settings are lost after suspend):
* https://github.com/openrazer/openrazer/issues/342
(Gnome, Wayland)

### Wireless Issue

Connection gets lost randomly, updating the firmeware helps:

* Backup /lib/firmware/ath10k/QCA6174/hw3.0/
* Download & Update Firmware:
```shell
$ wget https://github.com/kvalo/ath10k-firmware/raw/master/QCA6174/hw3.0/board.bin
$ sudo cp board.bin /lib/firmware/ath10k/QCA6174/hw3.0/board.bin
$ wget https://github.com/kvalo/ath10k-firmware/raw/master/QCA6174/hw3.0/board-2.bin
$ sudo cp board-2.bin /lib/firmware/ath10k/QCA6174/hw3.0/board-2.bin
$ wget https://github.com/kvalo/ath10k-firmware/raw/master/QCA6174/hw3.0/4.4.1/firmware-6.bin_WLAN.RM.4.4.1-00065-QCARMSWP-1
$ sudo cp firmware-6.bin_WLAN.RM.4.4.1-00065-QCARMSWP-1 /lib/firmware/ath10k/QCA6174/hw3.0/firmware-6.bin
```

### Graphic Card

Works out of the box.

### HDMI

Works out of the box.

#### Multiple monitors

Switch to 1920x1080 resulution on your internal HDPi display when using multiple monitors.
HDPi scaling is currently frustrating.

### Webcam (unsolved)

Working only with 176x in cheese, or 640x480 in guvcview with 15/1 frames.
Unsolved... :(

Reference: https://wiki.archlinux.org/index.php/Razer#Webcam

## Arch

I use [Antergos](https://antergos.com/) Arch, but should be work with other Arch distros.

### Suspend Loop Issue

```shell
$ sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="quiet button.lid_init_state=open"
```

Update Grub
```shell
$ sudo grub-mkconfig -o /boot/grub/grub.cfg
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

The keyboard lighting won't work after reboot:

* https://github.com/openrazer/openrazer/issues/342


### Gnome, Workspaces, Gestures

Install libinput-gestures via software package manager:
* libinput-gesture

Setup libinput gesture:
```shell
$ sudo gpasswd -a $USER input
```

Logout - Login (if not, you get an error)

```
$ libinput-gestures-setup start
$ libinput-gestures-setup autostart
```

Configuration files are at:
   /etc/libinput-gestures.conf (system wide default)
   $HOME/.config/libinput-gestures.conf (optional per user)

```shell
$ nano .config/libinput-gestures.conf
gesture swipe down      _internal ws_up
gesture swipe up        _internal ws_down
```
_(if you prefer natural scrolling, change up/down)_

Restart libinput-gestures
```shell
$ libinput-gestures-setup restart
```

### Wireless

Works out of the box.

### Touchpad

#### Synaptics (X11)

Disable touchpad while typing and some other tunings:
* [50-synaptics-arch.conf](etc/X11/xorg.conf.d/50-synaptics-arch.conf)

#### libinput (X11)

"libinput" configration for X11 [60-libinput.conf](etc/X11/xorg.conf.d/60-libinput.conf)

#### Wayland

Adjust "libinput" coordinate ranges for absolute axes:
* [61-evdev-local.hwdb](etc/udev/hwdb.d/61-evdev-local.hwdb)

```shell
$ sudo cp etc/udev/hwdb.d/61-evdev-local.hwdb /etc/udev/hwdb.d/61-evdev-local.hwdb
```

Update settings:
```shell
$ sudo systemd-hwdb update
$ sudo udevadm trigger /dev/input/event*
```

References:
* https://wayland.freedesktop.org/libinput/doc/latest/absolute_coordinate_ranges.html
* https://github.com/systemd/systemd/pull/6730

### Multiple Monitors

HDPI is still a problem, 1920x1080 seems to be the best solution.

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


