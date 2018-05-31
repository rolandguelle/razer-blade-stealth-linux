# Razer Blade Stealth Linux

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) Linux ([Ubuntu](#ubuntu-1710) & [Arch (Antergos)](#arch-antergos)) setup, including **[Razer Core](#razer-core)** with [discrete NVIDIA GPU](#discrete-nvidia-gpu) setup connected via [thunderbolt](#thunderbolt-1).

Contact me at twitter [@rolandguelle](https://twitter.com/rolandguelle) for questions or open an issue.

My current setup is Ubuntu 17.10 (Ubuntu Gnome + X11) or Arch (Antergos + Gnome + Wayland).

<!-- TOC -->

- [Razer Blade Stealth Linux](#razer-blade-stealth-linux)
- [Preparation](#preparation)
    - [Meltdown, Spectre & TPM Updates](#meltdown-spectre--tpm-updates)
    - [Disk Resize](#disk-resize)
- [Ubuntu 18.04](#ubuntu-1804)
    - [Update](#update)
    - [Install](#install)
        - [Issues & Fixes](#issues--fixes)
        - [WIP](#wip)
- [Ubuntu 17.10](#ubuntu-1710)
    - [Install](#install-1)
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
        - [Touchpad Temporary Freezes](#touchpad-temporary-freezes)
        - [Touchscreen & Firefox](#touchscreen--firefox)
            - [XINPUT2](#xinput2)
        - [Unstable WIFI](#unstable-wifi)
            - [Update Firmware](#update-firmware)
        - [Onscreen Keyboard](#onscreen-keyboard)
            - [Block caribou](#block-caribou)
                - [Startup Applications](#startup-applications)
                - [Extension](#extension)
        - [Multiple Monitors](#multiple-monitors)
            - [Switch to 1920x1080](#switch-to-1920x1080)
    - [Unsolved Issues](#unsolved-issues)
        - [Keyboard Colors & Openrazer](#keyboard-colors--openrazer)
        - [Webcam](#webcam)
    - [Tweaks](#tweaks)
        - [Power Management](#power-management)
        - [Touchpad](#touchpad)
            - [Click, Tap, Move](#click-tap-move)
        - [Display Scaling](#display-scaling)
        - [Theme](#theme)
            - ["Capitaine" Cursors](#capitaine-cursors)
            - [Applicatioins Theme](#applicatioins-theme)
            - [Dock & Top Bar](#dock--top-bar)
            - [Fonts](#fonts)
            - [Workspace Grid](#workspace-grid)
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
        - [External Display](#external-display)
            - [Connected At Laptop HDMI](#connected-at-laptop-hdmi)
            - [Connected At External GPU](#connected-at-external-gpu)
                - [Expand Display](#expand-display)
                - [Run Applications 'Only' On External Screen](#run-applications-only-on-external-screen)
                    - [Automatic Setup](#automatic-setup)
                    - [Manual Setup](#manual-setup)
- [Arch (Antergos)](#arch-antergos)
    - [Works](#works-1)
    - [Suspend Loop](#suspend-loop-1)
    - [Touchpad](#touchpad-1)
        - [Libinput-gestures](#libinput-gestures-1)
        - [Synaptics (X11)](#synaptics-x11)
        - [Libinput Coordinates](#libinput-coordinates)
    - [More](#more)
    - [Razer Core](#razer-core-1)
        - [Installation](#installation)
        - [Setup](#setup)
        - [Bash Alias razerrun](#bash-alias-razerrun)
        - [Thunderbolt](#thunderbolt-1)
    - [Tweaks](#tweaks-1)
        - [Top Icon Plus](#top-icon-plus)
        - [Gdm](#gdm)
        - [Theme](#theme-1)
        - [Power Management](#power-management-1)
- [Other Models](#other-models)
    - [Razer Blade Stealth Late 2017](#razer-blade-stealth-late-2017)
        - [Screen flickering](#screen-flickering)
        - [External monitor randomly going blank](#external-monitor-randomly-going-blank)
- [Credits](#credits)

<!-- /TOC -->

# Preparation

- [BIOS updates](http://www.razersupport.com/gaming-systems/razer-blade-stealth/) via Windows 10
- Direct Links:
    - [BladeStealthUpdater_v1.0.5.3_BIOS6.05.exe.7z](http://dl.razerzone.com/support/BladeStealthH2/BladeStealthUpdater_v1.0.5.3_BIOS6.05.exe.7z)
    - [BladeStealthUpdater_v1.0.5.0.zip](http://dl.razerzone.com/support/BladeStealthH2/BladeStealthUpdater_v1.0.5.0.zip)
- [Fix for INTEL-SA-00086 Intel Management Engine Critical Firmware Update](https://insider.razerzone.com/index.php?threads/fix-for-intel-sa-00086-intel-management-engine-critical-firmware-update.29116/)
    - [RazerUpdater_v1.0.6.2_ME-11.8.50.3425.exe.7z](http://razerdrivers.s3.amazonaws.com/drivers/RazerUpdater_v1.0.6.2_ME-11.8.50.3425.exe.7z)

## Meltdown, Spectre & TPM Updates

* [Razer Blade Stealth (2016) - Intel 7500U](http://drivers.razersupport.com//index.php?_m=downloads&_a=view&parentcategoryid=605&pcid=604&nav=0,350,604)
    * Meltdown and Spectre Vulnerabilities Updater - Razer BIOS customer updater (02 Apr 2018 06:44 PM)
    * Razer TPM Firmware Updater (13 Feb 2018 03:32 AM)

## Disk Resize

[Resize disk](https://www.howtogeek.com/101862/how-to-manage-partitions-on-windows-without-downloading-any-other-software/) via Windows 10

# Ubuntu 18.04

## Update

Udating my 17.10 installation works without issues. I run X11 with the Synaptics driver.

## Install

To check what fixes are needed at 18.04, I try a fresh install.
Running the live session and starting the installation segfaults, starting direct (boot) into the setup works.

- Minimal installation, include 3rd party
- Install Intel Microcode

```shell
sudo apt install intel-microcode
```

### Issues & Fixes

Check if the issues still exist and the fixes works:

- Caps-Lock
- Suspend-Loop
- Touchpad Temporary Freezes
- Touchscreen & Firefox
- Libinput-gestures
- Power Management
- "Capitaine" Cursors
- Theme: apt install numix-gtk-theme numix-icon-theme gnome-icon-theme
    - Selected Theme: "Numix"

### WIP

- Synaptics settings
- Razer Core

# Ubuntu 17.10

## Install

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

Only needed if you run X11 instead of Wayland and enabled Capslock.

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

### Touchpad Temporary Freezes

The touchpad [temporary freezes](https://insider.razer.com/index.php?threads/ubuntu-17-10-blade-stealth-late-2017-issues.28967/) with libinput.
Manual update libinput & kernel make it _less worse_, but it is still buggy.

Switching from Wayland to X11 and libinput to Synaptics solves the problem.

```shell
sudo apt install xserver-xorg-input-synaptics
```

Edit Synaptics configuration: [50-synaptics-ubuntu.conf](etc/X11/xorg.conf.d/50-synaptics-ubuntu.conf)

Restart and login with X11.

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
wget https://github.com/kvalo/ath10k-firmware/raw/master/QCA6174/hw3.0/4.4.1/firmware-6.bin_WLAN.RM.4.4.1-00079-QCARMSWPZ-1
sudo mv firmware-6.bin_WLAN.RM.4.4.1-00079-QCARMSWPZ-1 /lib/firmware/ath10k/QCA6174/hw3.0/firmware-6.bin
```

### Onscreen Keyboard

Everytime the touchscreen is used, an onscreen keyboard opens.

#### Block caribou

##### Startup Applications

Disable caribou (the on screen keyboard) in "Startup Applications".

Display "hidden apps":

```shell
sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop
```

Open "Startup Applications", disable caribou (and maybe Desktop Sharing, Backup Monitor and some others).

##### Extension

Remove caribou from "Startup Applications" is not enough :(

Blocks caribou (the on screen keyboard) from popping up when you use a touchscreen with a Gnome extension.

Manual installation:

```shell
mkdir -p ~/.local/share/gnome-shell/extensions/cariboublocker@git.keringar.xyz
cd ~/.local/share/gnome-shell/extensions/cariboublocker@git.keringar.xyz
wget https://github.com/keringar/cariboublocker/raw/master/extension.js
wget https://github.com/keringar/cariboublocker/raw/master/metadata.json
cd
gsettings get org.gnome.shell enabled-extensions
```

Add Gnome extension (add the new extension to your existing extensions):

```shell
gsettings set org.gnome.shell enabled-extensions "['cariboublocker@git.keringar.xyz']"
```

Logout - Login.

### Multiple Monitors

Using a HiDPI and "normal" monitor works on _some_ applications with Wayland, but not in Firefox & Chrome.

#### Switch to 1920x1080

Switch the internal HiDPI screen to **1920x1080** when using your RBS together with a non HiDPI external monitor.
Gnome _remembers_ the monitor and switch back to 4k when unplugging the screen.

## Unsolved Issues

### Keyboard Colors & Openrazer

Currently not used.

[Issue](https://github.com/openrazer/openrazer/issues/342): Settings are lost after suspend (Gnome, Wayland).

But maybe it works for you:

* https://openrazer.github.io/

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

- apt install numix-gtk-theme numix-icon-theme gnome-icon-theme gnome-icon-theme-extras
- Select via tweaks tool, Appearance, Themes, Application (Numix), Icons (Numix-Light)

Current Theme: [Adapta-Eta](https://github.com/adapta-project/adapta-gtk-theme)

#### Dock & Top Bar

- Dock (Settings)
    - Auto-hide the Dock
    - Position on the screen: bottom

#### Fonts

- Window-Title: Garuda Regular 11
- Interface: Ubuntu Regular 12
- Document: Sans Regular 13
- Monospace: Monospace Regular 13

#### Workspace Grid

Switch vertical though your workspaces.

Install Workspace Grid:

* https://github.com/zakkak/workspace-grid

My setup have just vertical workspaces, swipe left/right for switching workspaces:

```shell
# .config/libinput.conf
gesture swipe left      _internal ws_down
gesture swipe right     _internal ws_up
```

## Razer Core

Running a thunderbolt 3 device like the [Razer Core](https://www.razerzone.com/gaming-laptops/razer-core-v2) with Linux sounds like fun :)

### Thunderbolt

The Razer Core is connected via Thunderbold 3 with your RBS.

#### Cable

This [**2m** cable](https://www.amazon.de/CalDigit-Thunderbolt-3-Kabel-Zertifiziert-Typ-C-kompatibel/dp/B01N4MFG7J/) works without problems. I measured no (performance) differences compared with the included _very_ short cable (tested on Windows & Linux).

#### User Authorization

- BIOS Setting: Thunderbolt security: User
- Authorize thunderbolt, install: [Thunderbolt user-space components](https://github.com/01org/thunderbolt-software-user-space)

```shell
git clone https://github.com/01org/thunderbolt-software-user-space.git
cd thunderbolt-software-user-space
apt install cmake libboost-filesystem-dev txt2tags
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr
cmake --build .
sudo cmake --build . --target install
```

tbtadm:

```shell
$ tbtadm devices
0-1 Razer	Core	non-authorized	not in ACL
```

- Add Razer Core to ACL:

```shell
sudo tbtadm approve 0-1
```

Razer Core USB & Ethernet now works.

### Discrete NVIDIA GPU

Goal is a setup like:

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

NVIDIA Settings

```shell
optirun -b none /usr/bin/nvidia-settings  -c :8
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

- razercore status
    - Status of connection
- razercore intern "application"
    - run application on external GPU & render at internal or laptop HDMI connected screen
    - Example: razercore intern etr
- razercore extern "application"
    - run application on external GPU & render at Razer Core connected screen
    - Example: razercore extern etr
    - Example: razercore extern fluxbox
    - razercore reset
        - reset (maybe) broken settings (disabled touchpad on Wayland, wrong bumblebee.conf) from "run-ext"
    - razercore intern-on, razercore intern-off
        - enable / disable internal screen

### External Display

Use eGPU on external displays.

#### Connected At Laptop HDMI

Switch to "Single Display" for gaming:

- Settings, Devices, Single Display

Tested with Samsung TV, XBox 360 controller (plugged in Razer Core) and Steam.

#### Connected At External GPU

Unsolved: Dynamic expand external display:

- https://unix.stackexchange.com/questions/326362/bumblebee-dual-monitor-mirror-fedora-25

##### Expand Display

Permanent expand display with external screen, connected at GPU / Razer Core:

- BIOS: Disable Thunderbold Security
- Connect Razer Core via Thunderbold
- Login with Xorg Session
- Keep Thunderbold connected

##### Run Applications 'Only' On External Screen

Check if your monitor is detected:

```shell
nvidia-xconfig --query-gpu-info
```

###### Automatic Setup

**NOTICE:**

- razercore overwrites /etc/bumblebee/bumblebee.conf
- razercore disables touchpad while running a shared Wayland / Xorg session

Create/Copy/Modify additional bumblebee and NVIDIA configuration:

```shell
sudo cp etc/bumblebee/* /etc/bumblebee/
```

Install Synaptics Xorg driver:

```shell
sudo apt install xserver-xorg-input-synaptics
```

Start an application on the external display:

```shell
razercore extern etr
```

Extreme Tuxracer should now run on your external screen.

I run fluxbox on the external screen and start (mostly games) in this window manager.
With a lightweight wm, games like 'Counter Strike', 'Life is Strange' or 'Steam in Big Picture Mode' runs fine.

```shell
razercore extern fluxbox
```

Modify and create your monitor settings, stored in /etc/bumblebee/xorg.conf.external:

```shell
optirun /usr/bin/nvidia-settings -c :8
```

###### Manual Setup

Modify [bumblebee.conf](etc/bumblebee/bublebee-external.conf) and store in etc/bumblebee/bublebee.conf:

```
KeepUnusedXServer=true
PMMethod=none
```

Modify [xorg.conf.nvidia](etc/bumblebee/xorg.conf.external)

```
# Option "AutoAddDevices" "false"
# Option "UseEDID" "false"
```

Run

```shell
/etc/init.d/bumblebee restart # 'razercore restart' is also possible, ignore error messages
export DISPLAY=:8 LD_LIBRARY_PATH=/usr/lib/nvidia-387:$LD_LIBRARY_PATH
optirun true # start X server
etr # replace this with steam or whatever
```

Extreme Tuxracer should now run on your external screen.

# Arch (Antergos)

Tested with [Antergos](https://antergos.com/) (Wayland & Gnome) Arch, but other Arch based distros should work too.

## Works

Sames as Ubuntu:

- [Graphic Card](#graphic-card)
- [HDMI](#hdmi)
- [Thunderbolt / USB-C](#thunderbolt--usb-c)

Arch (4.15.2-2-ARCH kernel):

- Caps-Lock fix is not needed
- No touchpad issues

## Suspend Loop

Add kernel parameter:

```shell
$ sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="button.lid_init_state=open"
```

Update Grub:

```shell
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## Touchpad

Works, without suspend issues.

### Libinput-gestures

Install Libinput-gestures, my [config](config/libinput-gestures.conf).
(If you prefer _natural scrolling_, change up/down)

### Synaptics (X11)

Disable touchpad while typing and some other tunings:

- [50-synaptics-arch.conf](etc/X11/xorg.conf.d/50-synaptics-arch.conf)

### Libinput Coordinates

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

## More

- [Onscreen Keyboard](#onscreen-keyboard)
    - [Block caribou](#block-caribou)
        - [Extension](#extension)
- [Touchscreen & Firefox](#touchscreen--firefox)
    - [XINPUT2](#xinput2)
- [Unstable WIFI](#unstable-wifi)
    - [Update Firmware](#update-firmware)
- [Multiple Monitors](#multiple-monitors)
    - [Switch to 1920x1080](#switch-to-1920x1080)

## Razer Core

### Installation

Install NVIDIA & bumblebee:

```shell
sudo pacman -S bumblebee primus nvidia nvidia-utils virtualgl
```

Install 32bit driver for steam:

```shell
sudo pacman -S lib32-virtualgl lib32-nvidia-utils
```

### Setup

Add user to bumblebee group:

```shell
sudo gpasswd -a $USER bumblebee
```

Set driver to nvidia:

```shell
$ sudo nano /etc/bumblebee/bumblebee.conf
Driver=nvidia
```

TODO / WIP:

- xorg.conf.external, bumblebee-external.conf to /etc/bumblebee/ for external setup

More: https://wiki.archlinux.org/index.php/bumblebee#Installation

### Bash Alias razerrun

Bash Alias:

```shell
$ nano .bashrc
alias razerrun='PRIMUS_SYNC=1 vblank_mode=0 primusrun'
```

Test:

```shell
razerrun glxinfo | grep OpenGL
```

### Thunderbolt

Install "bolt" for thunderbolt management:

```shell
sudo pacman -S bolt
# Authorize and store a device in the database
boltctl enroll
```

Nice (but useless) Gnome extension: https://github.com/gicmo/bolt-extension

## Tweaks

- [Dock & Top Bar](#dock--top-bar)

### Top Icon Plus

https://github.com/phocean/TopIcons-plus

### Gdm

```shell
systemctl disable lightdm.service
pacman -Rs lightdm-webkit2-greeter light-locker-settings light-locker lightdm
pacman -S gdm
pacman -S gtk-engines
systemctl enable gdm.service
pacman -Rs xscreensaver
pacman -S gnome-screensaver
```

More: https://forum.antergos.com/topic/5081/switching-from-lightdm-to-gdm-no-lock-screen

### Theme

gnome-tweak-tool / Appearance

- Appplications: Arc-Darker
- Cursor: Capitaine-cursors
- Icons: Flat-Remix
- Shell: Arc-Dark

gnome-tweak-tool / Fonts

- Window Title: Ubuntu Bold 12
- Interface: Ubuntu Regular 13
- Document: Sans Regular 13
- Monospace: Ubuntu Mono Regular 15
- Hinting: Slight

gnome-tweak-tool / Keyboard & Mouse / Touchpad

- Click Method: Fingers
- Disable While Typing: True

### Power Management

Install TLP tools:

```shell
sudo pacman -S tlp tlp-rdw
```

Enable TLP tools:

```shell
sudo systemctl enable tlp
sudo systemctl enable tlp-sleep
```

Bumblebee with NVIDIA driver

```shell
sudo nano /etc/default/tlp
# Bumblebee with NVIDIA driver
# https://wiki.archlinux.org/index.php/TLP#Bumblebee_with_NVIDIA_driver
RUNTIME_PM_BLACKLIST="07:00.0 07:00.1"
```

# Other Models

Some fixes, tips & tweaks for other models.

## Razer Blade Stealth Late 2017

### Screen flickering

Add kernel param:
```
i915.edp_vswing=2
```

More: https://wiki.archlinux.org/index.php/Razer_Blade#Late-2017_version_Razer_Blade_Stealth

### External monitor randomly going blank

Workaround:
Change output channel to "HDMI / DisplayPort - Built in Audio" or connect headphones to the stereo jack.

Discussion: #18

# Credits

- References
    - https://wiki.archlinux.org/index.php/Razer
    - https://wayland.freedesktop.org/libinput/doc/latest/absolute_coordinate_ranges.html
    - https://github.com/systemd/systemd/pull/6730
    - https://wiki.archlinux.org/index.php/TLP
    - http://www.webupd8.org/2016/08/how-to-install-and-configure-bumblebee.html
    - https://github.com/bulletmark/libinput-gestures
    - http://askubuntu.com/questions/849888/suspend-not-working-as-intended-on-razer-blade-stealth-running-xubuntu-16-04/849900
    - http://askubuntu.com/questions/873626/crash-when-toggling-off-caps-lock
    - https://github.com/Bumblebee-Project/Bumblebee/wiki/Multi-monitor-setup
- Thanks
    - https://github.com/xlinbsd
    - https://github.com/tomsquest
    - https://github.com/ahmadnassri
    - https://github.com/lucaszanella
    - https://github.com/brendanrankin
    - https://github.com/benjob
