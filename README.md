# Razer Blade Stealth Linux

**Razer Blade Stealth** (late 2016, UHD / HiDPI) Linux ([Ubuntu](#ubuntu-1710) & [Arch (Antergos)](#arch-antergos)) setup, including **[Razer Core](#razer-core)** with [discrete NVIDIA GPU](#discrete-nvidia-gpu) setup connected on [thunderbolt](#thunderbolt-1).

Contact me at twitter [@rolandguelle](https://twitter.com/rolandguelle) for questions.

My current setup is Ubuntu 17.10 & Wayland, but you find some (maybe) outdated infos about X11 & Arch in this tutorial.

<!-- TOC -->

- [Razer Blade Stealth Linux](#razer-blade-stealth-linux)
- [Preparation](#preparation)
- [Ubuntu 17.10](#ubuntu-1710)
    - [Install](#install)
    - [Works](#works)
        - [Graphic Card](#graphic-card)
        - [HDMI](#hdmi)
        - [Thunderbolt / USB-C](#thunderbolt--usb-c)
    - [Issues](#issues)
        - [Suspend Loop](#suspend-loop)
            - [Grub Kernel Parameter](#grub-kernel-parameter)
        - [Caps-Lock Crash](#caps-lock-crash)
            - [Disable Capslocks](#disable-capslocks)
            - [X11: Disable Built-In Keyboard Driver](#x11-disable-built-in-keyboard-driver)
        - [Touchpad Suspend](#touchpad-suspend)
            - [Libinput-gestures](#libinput-gestures)
        - [Touchscreen & Firefox](#touchscreen--firefox)
            - [XINPUT2](#xinput2)
        - [Unstable WIFI](#unstable-wifi)
            - [Update Firmware](#update-firmware)
        - [Onscreen Keyboard](#onscreen-keyboard)
            - [Block caribou](#block-caribou)
        - [Multiple Monitors](#multiple-monitors)
            - [Switch to 1920x1080](#switch-to-1920x1080)
    - [Unsolved Issues](#unsolved-issues)
        - [Keyboard Colors](#keyboard-colors)
        - [Webcam](#webcam)
    - [Tweaks](#tweaks)
        - [Power Management](#power-management)
        - [Touchpad](#touchpad)
            - [Click, Tap, Move](#click-tap-move)
            - [X11: Synaptics Configuration](#x11-synaptics-configuration)
        - [Display Scaling](#display-scaling)
        - [Theme](#theme)
            - ["Capitaine" Cursors](#capitaine-cursors)
            - [Applicatioins Theme](#applicatioins-theme)
            - [Fonts](#fonts)
    - [Razer Core](#razer-core)
        - [Thunderbolt](#thunderbolt)
            - [Cable](#cable)
            - [User Authorization](#user-authorization)
        - [Discrete NVIDIA GPU](#discrete-nvidia-gpu)
            - [NVIDIA Prime](#nvidia-prime)
            - [NVIDIA GPU Driver](#nvidia-gpu-driver)
            - [Bumblebee](#bumblebee)
            - [Test GPU With optirun](#test-gpu-with-optirun)
            - [Run Extremetuxracer With primusrun](#run-extremetuxracer-with-primusrun)
        - [razercore](#razercore)
- [Arch (Antergos)](#arch-antergos)
    - [Suspend Loop](#suspend-loop-1)
    - [Power Management](#power-management-1)
    - [Keyboard Colors](#keyboard-colors-1)
    - [Gnome, Workspaces, Gestures](#gnome-workspaces-gestures)
    - [Touchpad](#touchpad-1)
        - [Synaptics (X11)](#synaptics-x11)
        - [libinput (X11)](#libinput-x11)
        - [libinput (Wayland)](#libinput-wayland)
    - [Multiple Monitors](#multiple-monitors-1)
- [Credits](#credits)

<!-- /TOC -->

# Preparation

- [BIOS updates](http://www.razersupport.com/gaming-systems/razer-blade-stealth/) via Windows 10
- Direct Links:
    - [BladeStealthUpdater_v1.0.5.3_BIOS6.05.exe.7z](http://dl.razerzone.com/support/BladeStealthH2/BladeStealthUpdater_v1.0.5.3_BIOS6.05.exe.7z)
    - [BladeStealthUpdater_v1.0.5.0.zip](http://dl.razerzone.com/support/BladeStealthH2/BladeStealthUpdater_v1.0.5.0.zip)

# Ubuntu 17.10

## Install

- [Resize disk](https://www.howtogeek.com/101862/how-to-manage-partitions-on-windows-without-downloading-any-other-software/) via Windows 10
- Fresh Ubuntu 17.10 installation, reboot
- Software & Updates
    - Additional Drivers: Using Processor microcode firmware for Intel CPUs from intel-microcode (proprietary)
        - (Secure boot was disabled during installation, but is now activated)
    - Packages: main, universe, restricted, multiverse, artful-proposed

## Works

Other tutorials reports issues for some topics/components, but on my machine these are running fine.

### Graphic Card

Works out of the box **without** the Kernel parameter:

- i915.enable_rc6=0

or X11 UXA mode:

- "AccelMethod"  "uxa"

### HDMI

Since 4.10.6 kernel, HDMI works out of the box.

### Thunderbolt / USB-C

USB & video works on my 27'' Dell monitor with a (Apple) USB-C (HDMI, USB) adapter, without modifications (since 4.13.x kernel).
Including USB to ethernet.

## Issues

### Suspend Loop

After resume, the system loops back in suspend.
The system send an ACPI event where the [kernel defaults](https://patchwork.kernel.org/patch/9512307/) are different.

#### Grub Kernel Parameter

Change kernel defaults:

```shell
sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="button.lid_init_state=open"
```

Update grub

```shell
sudo update-grub
```

### Caps-Lock Crash

The RBS crashes ~~randomly~~ mostly if you hit "Caps Lock", causes by the build-in driver.

#### Disable Capslocks

Modify /etc/default/keyboard, replacing capslocks by a second ctrl:

```shell
sudo nano /etc/default/keyboard
XKBOPTIONS="ctrl:nocaps"
```

#### X11: Disable Built-In Keyboard Driver

Get your keyboard description and use it instead of "AT Raw Set 2 keyboard":

```shell
xinput list | grep "Set 2 keyboard"
```

[Config](etc/X11/xorg.conf.d/20-razer.conf)

```shell
Section "InputClass"
    Identifier      "Disable built-in keyboard"
    MatchProduct    "AT Raw Set 2 keyboard"
#   MatchProduct    "AT Translated Set 2 keyboard"
    Option          "Ignore"    "true"
EndSection
```

[Re'disable](etc/pm/sleep.d/20_razer) keyboard after suspend:

```shell
#!/bin/sh
# http://askubuntu.com/questions/873626/crash-when-toggling-off-caps-lock

case $1 in
    resume|thaw)
        xinput set-prop "AT Raw Set 2 keyboard" "Device Enabled" 0
#       xinput set-prop "AT Translated Set 2 keyboard" "Device Enabled" 0
    ;;
esac
```

### Touchpad Suspend

Touchpad fails resuming from suspend with:

```shell
rmi4_physical rmi4-00: rmi_driver_reset_handler: Failed to read current IRQ mask.
dpm_run_callback(): i2c_hid_resume+0x0/0x120 [i2c_hid] returns -11
PM: Device i2c-15320205:00 failed to resume async: error -11
```

Temporary fix:

```shell
sudo rmmod i2c_hid && sudo modprobe i2c_hid
```

#### Libinput-gestures

[Libinput-gestures](https://github.com/bulletmark/libinput-gestures) solves the problem:

```shell
sudo gpasswd -a $USER input
sudo apt install xdotool wmctrl libinput-tools
git clone http://github.com/bulletmark/libinput-gestures
cd libinput-gestures
sudo ./libinput-gestures-setup install
libinput-gestures-setup autostart
```

My [config](config/libinput-gestures.conf).
(If you prefer _natural scrolling_, change up/down)

Logout - Login

### Touchscreen & Firefox

Firefox doesn't seem to care about the touchscreen at all.

#### XINPUT2

Tell Firefox to use xinput2

```shell
sudo nano /etc/environment
MOZ_USE_XINPUT2=1
```

Logout - Login.

### Unstable WIFI

Wireless connection gets lost randomly.

#### Update Firmware

Updating the firmeware:

- Backup /lib/firmware/ath10k/QCA6174/hw3.0/
- Download & Update Firmware:

```shell
wget https://github.com/kvalo/ath10k-firmware/raw/master/QCA6174/hw3.0/board.bin
sudo mv board.bin /lib/firmware/ath10k/QCA6174/hw3.0/board.bin
wget https://github.com/kvalo/ath10k-firmware/raw/master/QCA6174/hw3.0/board-2.bin
sudo mv board-2.bin /lib/firmware/ath10k/QCA6174/hw3.0/board-2.bin
wget https://github.com/kvalo/ath10k-firmware/raw/master/QCA6174/hw3.0/4.4.1.c1/firmware-6.bin_RM.4.4.1.c1-00035-QCARMSWP-1
sudo mv firmware-6.bin_RM.4.4.1.c1-00035-QCARMSWP-1 /lib/firmware/ath10k/QCA6174/hw3.0/firmware-6.bin
```

### Onscreen Keyboard

Everytime the touchscreen is used, an onscreen keyboard opens.

#### Block caribou

Disable caribou (the on screen keyboard) in "Startup Applications".

Display "hidden apps":

```shell
sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop
```

Open "Startup Applications", disable caribou (and maybe Desktop Sharing, Backup Monitor and some others).

### Multiple Monitors

Using a HiDPI and "normal" monitor works on _some_ applications with Wayland, but not in Firefox & Chrome.

#### Switch to 1920x1080

Switch the internal HiDPI screen to **1920x1080** when using your RBS together with a non HiDPI external monitor.
Gnome _remembers_ the monitor and switch back to 4k when unplugging the screen.

## Unsolved Issues

### Keyboard Colors

Currently not used.

[Issue](https://github.com/openrazer/openrazer/issues/342): Settings are lost after suspend (Gnome, Wayland).

### Webcam

Working only with 176x in cheese, or 640x480 in guvcview with 15/1 frames.

[This](https://wiki.archlinux.org/index.php/Razer_Blade#Webcam) fix not really helped:

```shell
/etc/modprobe.d/uvcvideo.conf

## fix issue with built-in webcam
options uvcvideo quirks=512
```

## Tweaks

### Power Management

TLP is an advanced power management tool for Linux that tries to apply tweaks for you automatically, depending on your Linux distribution and hardware.

```shell
sudo apt-get install tlp tlp-rdw
sudo systemctl enable tlp
```

### Touchpad

#### Click, Tap, Move

macOS touchpad feeling.

```shell
sudo apt install gnome-tweak-tool
```

- Keyboard & Mouse
- Click Method: Fingers

#### X11: Synaptics Configuration

Disable touchpad while typing and some other tunings:

- [50-synaptics-ubuntu.conf](etc/X11/xorg.conf.d/50-synaptics-ubuntu.conf)

### Display Scaling

At native resolution, the internal HiDPI 4K display with 100% scale might be too tiny and frustrating for some, and with 200% scale is too large to be useful, luckily with Ubuntu 17.10 shipping with Gnome3, a native screen scaling solution is provided, however it's limited to 2 options: `100%` and `200%`.

To enable more scaling options run the following command:

```shell
gsettings set org.gnome.mutter experimental-features "['scale-monitor-framebuffer']"
```

After login/logout, you'll get more scaling options under Settings > Devices > Displays.

If the fonts are blurry (on my setup), reset this setting:

```shell
gsettings reset-recursively org.gnome.mutter
```

### Theme

My Ubuntu/Gnome tweaks :)

#### "Capitaine" Cursors

- Install ["Capitaine" Cursors](https://github.com/keeferrourke/capitaine-cursors)
- Select via tweaks tool, Appearance, Themes, Cursor

#### Applicatioins Theme

- apt install arc-theme
- Select (Arc-Darker) via tweaks tool, Appearance, Themes, Application

#### Fonts

- Window-Title: Garuda Regular 11
- Interface: Ubuntu Regular 12
- Document: Sans Regular 13
- Monospace: Monospace Regular 13

## Razer Core

### Thunderbolt

#### Cable

This [**2m** cable](https://www.amazon.de/CalDigit-Thunderbolt-3-Kabel-Zertifiziert-Typ-C-kompatibel/dp/B01N4MFG7J/) works without problems. I measured no (performance) differences compared with the included _very_ short cable (tested on Windows & Linux).

#### User Authorization

- BIOS Setting: Thunderbolt security: User
- Authorize thunderbolt:

```shell
echo "1" | sudo tee /sys/bus/thunderbolt/devices/0-0/0-1/authorized
```

or with [razercore start](#razercore).

Razer Core USB & Ethernet now works!

### Discrete NVIDIA GPU

Goal is the _same_ setup like Windows:

- Run a _normal_ setup (Wayland, Gnome) - without connected Razer Core
- Hotplug Razer Core (without reboot, login/logout)
- Run selected applications with Razer Core on external NVIDIA GPU
- Unplug the Razer Core - without freezing the system

#### NVIDIA Prime

Install NVIDIA Prime and set it to "intel":

```shell
sudo apt install nvidia-prime
sudo prime-select intel
```

#### NVIDIA GPU Driver

Update driver (I use the latest NVIDIA drivers & Ubuntu 'pre-released updates'):

```shell
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
sudo apt install nvidia-387
```

Add missing NVIDIA symlinks (? not sure if this is only my local problem)

```shell
ln -s /usr/lib/nvidia-387/bin/nvidia-persistenced /usr/bin/nvidia-persistenced
ln -s /usr/lib/nvidia-387/libnvidia-cfg.so.1 /usr/lib/libnvidia-cfg.so.1
```

#### Bumblebee

Install Bumblebee:

```shell
sudo apt-get install bumblebee bumblebee-nvidia primus linux-headers-generic
sudo gpasswd -a $USER bumblebee
```

Update bumblebee [config](etc/bumblebee/bumblebee.conf)

```shell
sudo nano /etc/bumblebee/bumblebee.conf
```

Changes:

```shell
Driver=nvidia
KernelDriver=nvidia-387
LibraryPath=/usr/lib/nvidia-387:/usr/lib32/nvidia-387
XorgModulePath=/usr/lib/nvidia-387/xorg,/usr/lib/xorg/modules
```

#### Test GPU With optirun

Reboot with NVIDIA kernel drivers.

Check if NVIDIA driver is used:

```shell
$ optirun glxinfo | grep OpenGL
OpenGL vendor string: NVIDIA Corporation
```

#### Run Extremetuxracer With primusrun

Replace "etr" (Extremetuxracer) with your favorite 3D application/game ;)

```shell
PRIMUS_SYNC=1 vblank_mode=0 primusrun etr
```

- PRIMUS_SYNC sync between NVIDIA and Intel
    - 0: no sync, 1: D lags behind one frame, 2: fully synced
- ignore the refresh rate of your monitor and just try to reach the maximux fps
    - vblank_mode=0

Tested with "Extremetuxracer" and different games on "Steam" (Saints Row IV, Life is Strange and others) with 4k resolution on Wayland & X11.

### razercore

This (ugly) script helps with the typical tasks.
Copy [razercore](bin/razercore) into ~/bin or somewhere else in your path and make it executable.

Usage:

- razercore start
    - PCI rescan
    - Authorize thunderbolt
    - Check status (aka razercore status)
- razercore status
    - status of connection
- razercore stop
    - remove PCI device
- razercore restart
    - stop & start
- razercore exec "prog"
    - start prog on external gpu
    - example: razercore exec steam

# Arch (Antergos)

Tested with [Antergos](https://antergos.com/) Arch, but other Arch distros should work too.
Maybe outdated.

## Suspend Loop

Add kernel parameter:

```shell
$ sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="quiet button.lid_init_state=open"
```

Update Grub:

```shell
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## Power Management

Install TLP tools:

```shell
sudo pacman -S tlp tlp-rdw
```

Enable TLP tools:

```shell
sudo systemctl enable tlp
sudo systemctl enable tlp-sleep
```

## Keyboard Colors

See Ubuntu Setup

## Gnome, Workspaces, Gestures

See Ubuntu Setup

## Touchpad

### Synaptics (X11)

Disable touchpad while typing and some other tunings:

- [50-synaptics-arch.conf](etc/X11/xorg.conf.d/50-synaptics-arch.conf)

### libinput (X11)

"libinput" configration for X11 [60-libinput.conf](etc/X11/xorg.conf.d/60-libinput.conf)

### libinput (Wayland)

Adjust "libinput" coordinate ranges for absolute axes:

- [61-evdev-local.hwdb](etc/udev/hwdb.d/61-evdev-local.hwdb)

```shell
sudo cp etc/udev/hwdb.d/61-evdev-local.hwdb /etc/udev/hwdb.d/61-evdev-local.hwdb
```

Update settings:

```shell
sudo systemd-hwdb update
sudo udevadm trigger /dev/input/event*
```

## Multiple Monitors

See Ubuntu Setup

# Credits

- References
    - https://wiki.archlinux.org/index.php/Razer
    - https://wayland.freedesktop.org/libinput/doc/latest/absolute_coordinate_ranges.html
    - https://github.com/systemd/systemd/pull/6730
    - https://wiki.archlinux.org/index.php/TLP
    - http://www.webupd8.org/2016/08/how-to-install-and-configure-bumblebee.html
    - https://extensions.gnome.org/extension/1326/block-caribou/
    - https://github.com/bulletmark/libinput-gestures
    - http://askubuntu.com/questions/849888/suspend-not-working-as-intended-on-razer-blade-stealth-running-xubuntu-16-04/849900
    - http://askubuntu.com/questions/873626/crash-when-toggling-off-caps-lock
- Thanks
    - https://github.com/xlinbsd
    - https://github.com/tomsquest
    - https://github.com/ahmadnassri
    - https://github.com/lucaszanella
