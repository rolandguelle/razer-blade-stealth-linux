# Razer Blade Stealth Linux & Ubuntu 17.10

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) Ubuntu Linux 17.10.

- [Razer Blade Stealth Linux & Ubuntu 17.10](#razer-blade-stealth-linux--ubuntu-1710)
  - [1. Issues](#1-issues)
    - [1.1. Suspend Loop](#11-suspend-loop)
    - [1.2. Caps-Lock Crash](#12-caps-lock-crash)
    - [1.3. Touchpad Suspend](#13-touchpad-suspend)
    - [1.4. Touchpad Temporary Freezes](#14-touchpad-temporary-freezes)
    - [1.5. Touchscreen & Firefox](#15-touchscreen--firefox)
    - [1.6. Unstable WIFI](#16-unstable-wifi)
    - [1.7. Onscreen Keyboard](#17-onscreen-keyboard)
    - [1.8. Multiple Monitors](#18-multiple-monitors)
  - [2. Tweaks](#2-tweaks)
    - [2.1. Power Management](#21-power-management)
    - [2.2. Touchpad](#22-touchpad)
    - [2.3. Display Scaling](#23-display-scaling)
    - [2.4. "Capitaine" Cursors](#24-%22capitaine%22-cursors)
    - [2.5. Applicatioins Theme](#25-applicatioins-theme)
    - [2.6. Dock & Top Bar](#26-dock--top-bar)
    - [2.7. Fonts](#27-fonts)
    - [2.8. Workspace Grid](#28-workspace-grid)
  - [3. Razer Core](#3-razer-core)
    - [3.1. Thunderbolt](#31-thunderbolt)
      - [3.1.1. Cable](#311-cable)
      - [3.1.2. User Authorization](#312-user-authorization)
    - [3.2. Discrete NVIDIA GPU](#32-discrete-nvidia-gpu)
      - [3.2.1. NVIDIA Prime](#321-nvidia-prime)
      - [3.2.2. NVIDIA GPU Driver](#322-nvidia-gpu-driver)
      - [3.2.3. Bumblebee](#323-bumblebee)
      - [3.2.4. Test GPU With optirun](#324-test-gpu-with-optirun)
      - [3.2.5. Run Extremetuxracer With primusrun](#325-run-extremetuxracer-with-primusrun)
    - [3.3. "razercore" Script](#33-%22razercore%22-script)
    - [3.4. External Display](#34-external-display)
      - [3.4.1. Connected At Laptop HDMI](#341-connected-at-laptop-hdmi)
      - [3.4.2. Connected At External GPU](#342-connected-at-external-gpu)
      - [3.4.3. Expand Display](#343-expand-display)
      - [3.4.4. Run Applications 'Only' On External Screen](#344-run-applications-only-on-external-screen)
        - [3.4.4.1. Automatic Setup](#3441-automatic-setup)
        - [3.4.4.2. Manual Setup](#3442-manual-setup)
  - [4. Unsolved Issues](#4-unsolved-issues)
    - [4.1. Keyboard Colors & Openrazer](#41-keyboard-colors--openrazer)
    - [4.2. Webcam](#42-webcam)

## 1. Issues

Other tutorials reports issues for some topics/components, but on my machine these are running fine.

- Graphic Card
  - Works out of the box **without** the Kernel parameter
  - i915.enable_rc6=0
  - or X11 UXA mode: "AccelMethod"  "uxa"
- HDMI
  - Since 4.10.6 kernel, HDMI works out of the box.

### 1.1. Suspend Loop

After resume, the system loops back in suspend.
The system send an ACPI event where the [kernel defaults](https://patchwork.kernel.org/patch/9512307/) are different.

Change kernel defaults:

```shell
sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="button.lid_init_state=open"
```

Update grub

```shell
sudo update-grub
```

### 1.2. Caps-Lock Crash

The RBS crashes ~~randomly~~ mostly if you hit "Caps Lock", causes by the build-in driver.

**Disable Capslocks:**

Modify /etc/default/keyboard, replacing capslocks by a second ctrl:

```shell
sudo nano /etc/default/keyboard
XKBOPTIONS="ctrl:nocaps"
```

**X11: Disable Built-In Keyboard Driver:**

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

### 1.3. Touchpad Suspend

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

### 1.4. Touchpad Temporary Freezes

The touchpad [temporary freezes](https://insider.razer.com/index.php?threads/ubuntu-17-10-blade-stealth-late-2017-issues.28967/) with libinput.
Manual update libinput & kernel make it _less worse_, but it is still buggy.

Switching from Wayland to X11 and libinput to Synaptics solves the problem.

```shell
sudo apt install xserver-xorg-input-synaptics
```

Edit Synaptics configuration: [50-synaptics.conf](etc/X11/xorg.conf.d/50-synaptics.conf)

Restart and login with X11.

### 1.5. Touchscreen & Firefox

Firefox doesn't seem to care about the touchscreen at all.

Tell Firefox to use xinput2:

```shell
sudo nano /etc/environment
MOZ_USE_XINPUT2=1
```

Logout - Login.

### 1.6. Unstable WIFI

Wireless connection gets lost randomly.

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

### 1.7. Onscreen Keyboard

Everytime the touchscreen is used, an onscreen keyboard opens.
Disable caribou (the on screen keyboard) in "Startup Applications".

Display "hidden apps":

```shell
sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop
```

Open "Startup Applications", disable caribou (and maybe Desktop Sharing, Backup Monitor and some others).

**Remove caribou from "Startup Applications" is not enough:**

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

### 1.8. Multiple Monitors

Using a HiDPI and "normal" monitor works on _some_ applications with Wayland, but not in Firefox & Chrome.

Switch the internal HiDPI screen to **1920x1080** when using your RBS together with a non HiDPI external monitor.
Gnome _remembers_ the monitor and switch back to 4k when unplugging the screen.

## 2. Tweaks

### 2.1. Power Management

TLP is an advanced power management tool for Linux that tries to apply tweaks for you automatically, depending on your Linux distribution and hardware.

```shell
sudo apt-get install tlp tlp-rdw
sudo systemctl enable tlp
```

### 2.2. Touchpad

macOS touchpad feeling.

```shell
sudo apt install gnome-tweak-tool
```

- Keyboard & Mouse
- Click Method: Fingers

### 2.3. Display Scaling

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

### 2.4. "Capitaine" Cursors

- Install ["Capitaine" Cursors](https://github.com/keeferrourke/capitaine-cursors)
- Select via tweaks tool, Appearance, Themes, Cursor

### 2.5. Applicatioins Theme

- apt install numix-gtk-theme numix-icon-theme gnome-icon-theme gnome-icon-theme-extras
- Select via tweaks tool, Appearance, Themes, Application (Numix), Icons (Numix-Light)

Current Theme: [Adapta-Eta](https://github.com/adapta-project/adapta-gtk-theme)

### 2.6. Dock & Top Bar

- Dock (Settings)
  - Auto-hide the Dock
  - Position on the screen: bottom

### 2.7. Fonts

- Window-Title: Garuda Regular 11
- Interface: Ubuntu Regular 12
- Document: Sans Regular 13
- Monospace: Monospace Regular 13

### 2.8. Workspace Grid

Switch vertical though your workspaces.

Install [Workspace Grid](https://github.com/zakkak/workspace-grid).
My setup have just vertical workspaces, swipe left/right for switching workspaces:

```shell
# .config/libinput.conf
gesture swipe left      _internal ws_down
gesture swipe right     _internal ws_up
```

## 3. Razer Core

Running a thunderbolt 3 device like the [Razer Core](https://www.razerzone.com/gaming-laptops/razer-core-v2) with Linux sounds like fun :)

### 3.1. Thunderbolt

The Razer Core is connected via Thunderbold 3 with your RBS.

#### 3.1.1. Cable

This [**2m** cable](https://www.amazon.de/CalDigit-Thunderbolt-3-Kabel-Zertifiziert-Typ-C-kompatibel/dp/B01N4MFG7J/) works without problems. I measured no (performance) differences compared with the included _very_ short cable (tested on Windows & Linux).

#### 3.1.2. User Authorization

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
0-1 Razer Core non-authorized not in ACL
```

- Add Razer Core to ACL:

```shell
sudo tbtadm approve 0-1
```

Razer Core USB & Ethernet now works.

### 3.2. Discrete NVIDIA GPU

Goal is a setup like:

- Run a _normal_ setup (Wayland, Gnome) - without connected Razer Core
- Hotplug Razer Core (without reboot, login/logout)
- Run selected applications with Razer Core on external NVIDIA GPU
- Unplug the Razer Core - without freezing the system

#### 3.2.1. NVIDIA Prime

Install NVIDIA Prime and set it to "intel":

```shell
sudo apt install nvidia-prime
sudo prime-select intel
```

#### 3.2.2. NVIDIA GPU Driver

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

#### 3.2.3. Bumblebee

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

#### 3.2.4. Test GPU With optirun

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

#### 3.2.5. Run Extremetuxracer With primusrun

Replace "etr" (Extremetuxracer) with your favorite 3D application/game ;)

```shell
PRIMUS_SYNC=1 vblank_mode=0 primusrun etr
```

- PRIMUS_SYNC sync between NVIDIA and Intel
  - 0: no sync, 1: D lags behind one frame, 2: fully synced
- ignore the refresh rate of your monitor and just try to reach the maximux fps
  - vblank_mode=0

Tested with "Extremetuxracer" and different games on "Steam" (Saints Row IV, Life is Strange and others) with 4k resolution on Wayland & X11.

### 3.3. "razercore" Script

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

### 3.4. External Display

Use eGPU on external displays.

#### 3.4.1. Connected At Laptop HDMI

Switch to "Single Display" for gaming:

- Settings, Devices, Single Display

Tested with Samsung TV, XBox 360 controller (plugged in Razer Core) and Steam.

#### 3.4.2. Connected At External GPU

Unsolved: [Dynamic expand external display](https://unix.stackexchange.com/questions/326362/bumblebee-dual-monitor-mirror-fedora-25)

#### 3.4.3. Expand Display

Permanent expand display with external screen, connected at GPU / Razer Core:

- BIOS: Disable Thunderbold Security
- Connect Razer Core via Thunderbold
- Login with Xorg Session
- Keep Thunderbold connected

#### 3.4.4. Run Applications 'Only' On External Screen

Check if your monitor is detected:

```shell
nvidia-xconfig --query-gpu-info
```

##### 3.4.4.1. Automatic Setup

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

##### 3.4.4.2. Manual Setup

Modify [bumblebee.conf](etc/bumblebee/bublebee-external.conf):

```shell
KeepUnusedXServer=true
PMMethod=none
```

Modify [xorg.conf.nvidia](etc/bumblebee/xorg.conf.external)

```shell
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

## 4. Unsolved Issues

### 4.1. Keyboard Colors & Openrazer

Currently [Openrazer](https://openrazer.github.io/) not used.

[Issue](https://github.com/openrazer/openrazer/issues/342): Settings are lost after suspend (Gnome, Wayland).

But maybe it works for you:

### 4.2. Webcam

Working only with 176x in cheese, or 640x480 in guvcview with 15/1 frames.

[This](https://wiki.archlinux.org/index.php/Razer_Blade#Webcam) fix not really helped:

```shell
/etc/modprobe.d/uvcvideo.conf

## fix issue with built-in webcam
options uvcvideo quirks=512
```
