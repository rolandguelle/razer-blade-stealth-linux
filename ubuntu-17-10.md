# 1. Razer Blade Stealth Linux & Ubuntu 17.10

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) Ubuntu Linux 17.10.

<!-- TOC -->

- [1. Razer Blade Stealth Linux & Ubuntu 17.10](#1-razer-blade-stealth-linux--ubuntu-1710)
- [2. Install](#2-install)
- [3. Works](#3-works)
  - [3.1. Graphic Card](#31-graphic-card)
  - [3.2. HDMI](#32-hdmi)
  - [3.3. Thunderbolt / USB-C](#33-thunderbolt--usb-c)
- [4. Issues](#4-issues)
  - [4.1. Suspend Loop](#41-suspend-loop)
    - [4.1.1. Grub Kernel Parameter](#411-grub-kernel-parameter)
  - [4.2. Caps-Lock Crash](#42-caps-lock-crash)
    - [4.2.1. Disable Capslocks](#421-disable-capslocks)
    - [4.2.2. X11: Disable Built-In Keyboard Driver](#422-x11-disable-built-in-keyboard-driver)
  - [4.3. Touchpad Suspend](#43-touchpad-suspend)
    - [4.3.1. Libinput-gestures](#431-libinput-gestures)
  - [4.4. Touchpad Temporary Freezes](#44-touchpad-temporary-freezes)
  - [4.5. Touchscreen & Firefox](#45-touchscreen--firefox)
    - [4.5.1. XINPUT2](#451-xinput2)
  - [4.6. Unstable WIFI](#46-unstable-wifi)
    - [4.6.1. Update Firmware](#461-update-firmware)
  - [4.7. Onscreen Keyboard](#47-onscreen-keyboard)
    - [4.7.1. Block caribou](#471-block-caribou)
      - [4.7.1.1. Startup Applications](#4711-startup-applications)
      - [4.7.1.2. Extension](#4712-extension)
  - [4.8. Multiple Monitors](#48-multiple-monitors)
    - [4.8.1. Switch to 1920x1080](#481-switch-to-1920x1080)
- [5. Unsolved Issues](#5-unsolved-issues)
  - [5.1. Keyboard Colors & Openrazer](#51-keyboard-colors--openrazer)
  - [5.2. Webcam](#52-webcam)
- [6. Tweaks](#6-tweaks)
  - [6.1. Power Management](#61-power-management)
  - [6.2. Touchpad](#62-touchpad)
    - [6.2.1. Click, Tap, Move](#621-click-tap-move)
  - [6.3. Display Scaling](#63-display-scaling)
  - [6.4. Theme](#64-theme)
    - [6.4.1. "Capitaine" Cursors](#641-capitaine-cursors)
    - [6.4.2. Applicatioins Theme](#642-applicatioins-theme)
    - [6.4.3. Dock & Top Bar](#643-dock--top-bar)
    - [6.4.4. Fonts](#644-fonts)
    - [6.4.5. Workspace Grid](#645-workspace-grid)
- [7. Razer Core](#7-razer-core)
  - [7.1. Thunderbolt](#71-thunderbolt)
    - [7.1.1. Cable](#711-cable)
    - [7.1.2. User Authorization](#712-user-authorization)
  - [7.2. Discrete NVIDIA GPU](#72-discrete-nvidia-gpu)
    - [7.2.1. NVIDIA Prime](#721-nvidia-prime)
    - [7.2.2. NVIDIA GPU Driver](#722-nvidia-gpu-driver)
    - [7.2.3. Bumblebee](#723-bumblebee)
    - [7.2.4. Test GPU With optirun](#724-test-gpu-with-optirun)
    - [7.2.5. Run Extremetuxracer With primusrun](#725-run-extremetuxracer-with-primusrun)
  - [7.3. razercore](#73-razercore)
  - [7.4. External Display](#74-external-display)
    - [7.4.1. Connected At Laptop HDMI](#741-connected-at-laptop-hdmi)
    - [7.4.2. Connected At External GPU](#742-connected-at-external-gpu)
      - [7.4.2.1. Expand Display](#7421-expand-display)
      - [7.4.2.2. Run Applications 'Only' On External Screen](#7422-run-applications-only-on-external-screen)
        - [7.4.2.2.1. Automatic Setup](#74221-automatic-setup)
        - [7.4.2.2.2. Manual Setup](#74222-manual-setup)

<!-- /TOC -->

# 2. Install

- Fresh Ubuntu 17.10 installation, reboot
- Software & Updates
  - Additional Drivers: Using Processor microcode firmware for Intel CPUs from intel-microcode (proprietary)
    - (Secure boot was disabled during installation, but is now activated)
  - Packages: main, universe, restricted, multiverse, artful-proposed

# 3. Works

Other tutorials reports issues for some topics/components, but on my machine these are running fine.

## 3.1. Graphic Card

Works out of the box **without** the Kernel parameter:

- i915.enable_rc6=0

or X11 UXA mode:

- "AccelMethod"  "uxa"

## 3.2. HDMI

Since 4.10.6 kernel, HDMI works out of the box.

## 3.3. Thunderbolt / USB-C

USB & video works on my 27'' Dell monitor with a (Apple) USB-C (HDMI, USB) adapter, without modifications (since 4.13.x kernel).
Including USB to ethernet.

# 4. Issues

## 4.1. Suspend Loop

After resume, the system loops back in suspend.
The system send an ACPI event where the [kernel defaults](https://patchwork.kernel.org/patch/9512307/) are different.

### 4.1.1. Grub Kernel Parameter

Change kernel defaults:

```shell
sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="button.lid_init_state=open"
```

Update grub

```shell
sudo update-grub
```

## 4.2. Caps-Lock Crash

The RBS crashes ~~randomly~~ mostly if you hit "Caps Lock", causes by the build-in driver.

### 4.2.1. Disable Capslocks

Modify /etc/default/keyboard, replacing capslocks by a second ctrl:

```shell
sudo nano /etc/default/keyboard
XKBOPTIONS="ctrl:nocaps"
```

### 4.2.2. X11: Disable Built-In Keyboard Driver

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

## 4.3. Touchpad Suspend

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

### 4.3.1. Libinput-gestures

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

## 4.4. Touchpad Temporary Freezes

The touchpad [temporary freezes](https://insider.razer.com/index.php?threads/ubuntu-17-10-blade-stealth-late-2017-issues.28967/) with libinput.
Manual update libinput & kernel make it _less worse_, but it is still buggy.

Switching from Wayland to X11 and libinput to Synaptics solves the problem.

```shell
sudo apt install xserver-xorg-input-synaptics
```

Edit Synaptics configuration: [50-synaptics.conf](etc/X11/xorg.conf.d/50-synaptics.conf)

Restart and login with X11.

## 4.5. Touchscreen & Firefox

Firefox doesn't seem to care about the touchscreen at all.

### 4.5.1. XINPUT2

Tell Firefox to use xinput2

```shell
sudo nano /etc/environment
MOZ_USE_XINPUT2=1
```

Logout - Login.

## 4.6. Unstable WIFI

Wireless connection gets lost randomly.

### 4.6.1. Update Firmware

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

## 4.7. Onscreen Keyboard

Everytime the touchscreen is used, an onscreen keyboard opens.

### 4.7.1. Block caribou

#### 4.7.1.1. Startup Applications

Disable caribou (the on screen keyboard) in "Startup Applications".

Display "hidden apps":

```shell
sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop
```

Open "Startup Applications", disable caribou (and maybe Desktop Sharing, Backup Monitor and some others).

#### 4.7.1.2. Extension

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

## 4.8. Multiple Monitors

Using a HiDPI and "normal" monitor works on _some_ applications with Wayland, but not in Firefox & Chrome.

### 4.8.1. Switch to 1920x1080

Switch the internal HiDPI screen to **1920x1080** when using your RBS together with a non HiDPI external monitor.
Gnome _remembers_ the monitor and switch back to 4k when unplugging the screen.

# 5. Unsolved Issues

## 5.1. Keyboard Colors & Openrazer

Currently not used.

[Issue](https://github.com/openrazer/openrazer/issues/342): Settings are lost after suspend (Gnome, Wayland).

But maybe it works for you:

* https://openrazer.github.io/

## 5.2. Webcam

Working only with 176x in cheese, or 640x480 in guvcview with 15/1 frames.

[This](https://wiki.archlinux.org/index.php/Razer_Blade#Webcam) fix not really helped:

```shell
/etc/modprobe.d/uvcvideo.conf

## fix issue with built-in webcam
options uvcvideo quirks=512
```

# 6. Tweaks

## 6.1. Power Management

TLP is an advanced power management tool for Linux that tries to apply tweaks for you automatically, depending on your Linux distribution and hardware.

```shell
sudo apt-get install tlp tlp-rdw
sudo systemctl enable tlp
```

## 6.2. Touchpad

### 6.2.1. Click, Tap, Move

macOS touchpad feeling.

```shell
sudo apt install gnome-tweak-tool
```

- Keyboard & Mouse
- Click Method: Fingers

## 6.3. Display Scaling

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

## 6.4. Theme

My Ubuntu/Gnome tweaks :)

### 6.4.1. "Capitaine" Cursors

- Install ["Capitaine" Cursors](https://github.com/keeferrourke/capitaine-cursors)
- Select via tweaks tool, Appearance, Themes, Cursor

### 6.4.2. Applicatioins Theme

- apt install numix-gtk-theme numix-icon-theme gnome-icon-theme gnome-icon-theme-extras
- Select via tweaks tool, Appearance, Themes, Application (Numix), Icons (Numix-Light)

Current Theme: [Adapta-Eta](https://github.com/adapta-project/adapta-gtk-theme)

### 6.4.3. Dock & Top Bar

- Dock (Settings)
    - Auto-hide the Dock
    - Position on the screen: bottom

### 6.4.4. Fonts

- Window-Title: Garuda Regular 11
- Interface: Ubuntu Regular 12
- Document: Sans Regular 13
- Monospace: Monospace Regular 13

### 6.4.5. Workspace Grid

Switch vertical though your workspaces.

Install Workspace Grid:

* https://github.com/zakkak/workspace-grid

My setup have just vertical workspaces, swipe left/right for switching workspaces:

```shell
# .config/libinput.conf
gesture swipe left      _internal ws_down
gesture swipe right     _internal ws_up
```

# 7. Razer Core

Running a thunderbolt 3 device like the [Razer Core](https://www.razerzone.com/gaming-laptops/razer-core-v2) with Linux sounds like fun :)

## 7.1. Thunderbolt

The Razer Core is connected via Thunderbold 3 with your RBS.

### 7.1.1. Cable

This [**2m** cable](https://www.amazon.de/CalDigit-Thunderbolt-3-Kabel-Zertifiziert-Typ-C-kompatibel/dp/B01N4MFG7J/) works without problems. I measured no (performance) differences compared with the included _very_ short cable (tested on Windows & Linux).

### 7.1.2. User Authorization

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

## 7.2. Discrete NVIDIA GPU

Goal is a setup like:

- Run a _normal_ setup (Wayland, Gnome) - without connected Razer Core
- Hotplug Razer Core (without reboot, login/logout)
- Run selected applications with Razer Core on external NVIDIA GPU
- Unplug the Razer Core - without freezing the system

### 7.2.1. NVIDIA Prime

Install NVIDIA Prime and set it to "intel":

```shell
sudo apt install nvidia-prime
sudo prime-select intel
```

### 7.2.2. NVIDIA GPU Driver

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

### 7.2.3. Bumblebee

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

### 7.2.4. Test GPU With optirun

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

### 7.2.5. Run Extremetuxracer With primusrun

Replace "etr" (Extremetuxracer) with your favorite 3D application/game ;)

```shell
PRIMUS_SYNC=1 vblank_mode=0 primusrun etr
```

- PRIMUS_SYNC sync between NVIDIA and Intel
    - 0: no sync, 1: D lags behind one frame, 2: fully synced
- ignore the refresh rate of your monitor and just try to reach the maximux fps
    - vblank_mode=0

Tested with "Extremetuxracer" and different games on "Steam" (Saints Row IV, Life is Strange and others) with 4k resolution on Wayland & X11.

## 7.3. razercore

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

## 7.4. External Display

Use eGPU on external displays.

### 7.4.1. Connected At Laptop HDMI

Switch to "Single Display" for gaming:

- Settings, Devices, Single Display

Tested with Samsung TV, XBox 360 controller (plugged in Razer Core) and Steam.

### 7.4.2. Connected At External GPU

Unsolved: Dynamic expand external display:

- https://unix.stackexchange.com/questions/326362/bumblebee-dual-monitor-mirror-fedora-25

#### 7.4.2.1. Expand Display

Permanent expand display with external screen, connected at GPU / Razer Core:

- BIOS: Disable Thunderbold Security
- Connect Razer Core via Thunderbold
- Login with Xorg Session
- Keep Thunderbold connected

#### 7.4.2.2. Run Applications 'Only' On External Screen

Check if your monitor is detected:

```shell
nvidia-xconfig --query-gpu-info
```

##### 7.4.2.2.1. Automatic Setup

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

##### 7.4.2.2.2. Manual Setup

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

