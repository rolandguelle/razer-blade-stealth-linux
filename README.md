# 1. Razer Blade Stealth Linux

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) Linux ([Ubuntu](#ubuntu-1810) & [Arch (Antergos)](#arch-antergos)) setup, including **[Razer Core](#razer-core)** with [discrete NVIDIA GPU](#discrete-nvidia-gpu) setup connected via [thunderbolt](#thunderbolt-1).

Contact me at twitter [@rolandguelle](https://twitter.com/rolandguelle) for questions or open an issue.

My current setup is Ubuntu 18.10 (Ubuntu, Gnome, Wayland & libinput touchpad driver) and Arch (Antergos, Gnome, Wayland & libinput touchpad driver).

<!-- TOC -->

- [1. Razer Blade Stealth Linux](#1-razer-blade-stealth-linux)
- [2. Preparation](#2-preparation)
  - [2.1. Meltdown, Spectre & TPM Updates](#21-meltdown-spectre--tpm-updates)
  - [2.2. Disk Resize](#22-disk-resize)
- [3. Ubuntu 18.10](#3-ubuntu-1810)
  - [3.1. Install](#31-install)
  - [3.2. WIP](#32-wip)
- [4. Ubuntu 18.04](#4-ubuntu-1804)
  - [4.1. Update](#41-update)
  - [4.2. Install](#42-install)
    - [4.2.1. Issues & Fixes](#421-issues--fixes)
    - [4.2.2. Touchpad](#422-touchpad)
    - [4.2.3. WIP](#423-wip)
      - [4.2.3.1. Razer Core](#4231-razer-core)
        - [4.2.3.1.1. Auth](#42311-auth)
        - [4.2.3.1.2. bumblebee](#42312-bumblebee)
    - [4.2.4. Tweaks](#424-tweaks)
      - [4.2.4.1. Dual Boot Antergos](#4241-dual-boot-antergos)
      - [4.2.4.2. Grub](#4242-grub)
      - [4.2.4.3. Plymouth](#4243-plymouth)
      - [4.2.4.4. Gnome Theme](#4244-gnome-theme)
      - [4.2.4.5. Steam Interface](#4245-steam-interface)
- [5. Ubuntu 17.10](#5-ubuntu-1710)
  - [5.1. Install](#51-install)
  - [5.2. Works](#52-works)
    - [5.2.1. Graphic Card](#521-graphic-card)
    - [5.2.2. HDMI](#522-hdmi)
    - [5.2.3. Thunderbolt / USB-C](#523-thunderbolt--usb-c)
  - [5.3. Issues](#53-issues)
    - [5.3.1. Suspend Loop](#531-suspend-loop)
      - [5.3.1.1. Grub Kernel Parameter](#5311-grub-kernel-parameter)
    - [5.3.2. Caps-Lock Crash](#532-caps-lock-crash)
      - [5.3.2.1. Disable Capslocks](#5321-disable-capslocks)
      - [5.3.2.2. X11: Disable Built-In Keyboard Driver](#5322-x11-disable-built-in-keyboard-driver)
    - [5.3.3. Touchpad Suspend](#533-touchpad-suspend)
      - [5.3.3.1. Libinput-gestures](#5331-libinput-gestures)
    - [5.3.4. Touchpad Temporary Freezes](#534-touchpad-temporary-freezes)
    - [5.3.5. Touchscreen & Firefox](#535-touchscreen--firefox)
      - [5.3.5.1. XINPUT2](#5351-xinput2)
    - [5.3.6. Unstable WIFI](#536-unstable-wifi)
      - [5.3.6.1. Update Firmware](#5361-update-firmware)
    - [5.3.7. Onscreen Keyboard](#537-onscreen-keyboard)
      - [5.3.7.1. Block caribou](#5371-block-caribou)
        - [5.3.7.1.1. Startup Applications](#53711-startup-applications)
        - [5.3.7.1.2. Extension](#53712-extension)
    - [5.3.8. Multiple Monitors](#538-multiple-monitors)
      - [5.3.8.1. Switch to 1920x1080](#5381-switch-to-1920x1080)
  - [5.4. Unsolved Issues](#54-unsolved-issues)
    - [5.4.1. Keyboard Colors & Openrazer](#541-keyboard-colors--openrazer)
    - [5.4.2. Webcam](#542-webcam)
  - [5.5. Tweaks](#55-tweaks)
    - [5.5.1. Power Management](#551-power-management)
    - [5.5.2. Touchpad](#552-touchpad)
      - [5.5.2.1. Click, Tap, Move](#5521-click-tap-move)
    - [5.5.3. Display Scaling](#553-display-scaling)
    - [5.5.4. Theme](#554-theme)
      - [5.5.4.1. "Capitaine" Cursors](#5541-capitaine-cursors)
      - [5.5.4.2. Applicatioins Theme](#5542-applicatioins-theme)
      - [5.5.4.3. Dock & Top Bar](#5543-dock--top-bar)
      - [5.5.4.4. Fonts](#5544-fonts)
      - [5.5.4.5. Workspace Grid](#5545-workspace-grid)
  - [5.6. Razer Core](#56-razer-core)
    - [5.6.1. Thunderbolt](#561-thunderbolt)
      - [5.6.1.1. Cable](#5611-cable)
      - [5.6.1.2. User Authorization](#5612-user-authorization)
    - [5.6.2. Discrete NVIDIA GPU](#562-discrete-nvidia-gpu)
      - [5.6.2.1. NVIDIA Prime](#5621-nvidia-prime)
      - [5.6.2.2. NVIDIA GPU Driver](#5622-nvidia-gpu-driver)
      - [5.6.2.3. Bumblebee](#5623-bumblebee)
      - [5.6.2.4. Test GPU With optirun](#5624-test-gpu-with-optirun)
      - [5.6.2.5. Run Extremetuxracer With primusrun](#5625-run-extremetuxracer-with-primusrun)
    - [5.6.3. razercore](#563-razercore)
    - [5.6.4. External Display](#564-external-display)
      - [5.6.4.1. Connected At Laptop HDMI](#5641-connected-at-laptop-hdmi)
      - [5.6.4.2. Connected At External GPU](#5642-connected-at-external-gpu)
        - [5.6.4.2.1. Expand Display](#56421-expand-display)
        - [5.6.4.2.2. Run Applications 'Only' On External Screen](#56422-run-applications-only-on-external-screen)
          - [5.6.4.2.2.1. Automatic Setup](#564221-automatic-setup)
          - [5.6.4.2.2.2. Manual Setup](#564222-manual-setup)
- [6. Arch (Antergos)](#6-arch-antergos)
  - [6.1. Works](#61-works)
  - [6.2. Suspend Loop](#62-suspend-loop)
  - [6.3. Touchpad](#63-touchpad)
    - [6.3.1. Libinput-gestures](#631-libinput-gestures)
    - [6.3.2. Synaptics (X11)](#632-synaptics-x11)
    - [6.3.3. Libinput Coordinates](#633-libinput-coordinates)
  - [6.4. More](#64-more)
  - [6.5. Razer Core](#65-razer-core)
    - [6.5.1. Installation](#651-installation)
    - [6.5.2. Setup](#652-setup)
    - [6.5.3. Bash Alias razerrun](#653-bash-alias-razerrun)
    - [6.5.4. Thunderbolt](#654-thunderbolt)
  - [6.6. Tweaks](#66-tweaks)
    - [6.6.1. Top Icon Plus](#661-top-icon-plus)
    - [6.6.2. Gdm](#662-gdm)
    - [6.6.3. Theme](#663-theme)
    - [6.6.4. Power Management](#664-power-management)
- [7. Other Models](#7-other-models)
  - [7.1. Razer Blade Stealth Late 2017](#71-razer-blade-stealth-late-2017)
    - [7.1.1. Screen flickering](#711-screen-flickering)
    - [7.1.2. External monitor randomly going blank](#712-external-monitor-randomly-going-blank)
    - [7.1.3. Touchpad deadzones](#713-touchpad-deadzones)
  - [7.2. Razer Blade Stealth Early 2018](#72-razer-blade-stealth-early-2018)
    - [7.2.1. Screen flickering](#721-screen-flickering)
- [8. Oher Distros](#8-oher-distros)
  - [8.1. Elementary OS](#81-elementary-os)
- [9. Credits](#9-credits)

<!-- /TOC -->

# 2. Preparation

- [BIOS updates](http://www.razersupport.com/gaming-systems/razer-blade-stealth/) via Windows 10
- Direct Links:
    - [BladeStealthUpdater_v1.0.5.3_BIOS6.05.exe.7z](http://dl.razerzone.com/support/BladeStealthH2/BladeStealthUpdater_v1.0.5.3_BIOS6.05.exe.7z)
    - [BladeStealthUpdater_v1.0.5.0.zip](http://dl.razerzone.com/support/BladeStealthH2/BladeStealthUpdater_v1.0.5.0.zip)
- [Fix for INTEL-SA-00086 Intel Management Engine Critical Firmware Update](https://insider.razerzone.com/index.php?threads/fix-for-intel-sa-00086-intel-management-engine-critical-firmware-update.29116/)
    - [RazerUpdater_v1.0.6.2_ME-11.8.50.3425.exe.7z](http://razerdrivers.s3.amazonaws.com/drivers/RazerUpdater_v1.0.6.2_ME-11.8.50.3425.exe.7z)

## 2.1. Meltdown, Spectre & TPM Updates

* [Razer Blade Stealth (2016) - Intel 7500U](http://drivers.razersupport.com//index.php?_m=downloads&_a=view&parentcategoryid=605&pcid=604&nav=0,350,604)
    * Meltdown and Spectre Vulnerabilities Updater - Razer BIOS customer updater (02 Apr 2018 06:44 PM)
    * Razer TPM Firmware Updater (13 Feb 2018 03:32 AM)

## 2.2. Disk Resize

[Resize disk](https://www.howtogeek.com/101862/how-to-manage-partitions-on-windows-without-downloading-any-other-software/) via Windows 10

# 3. Ubuntu 18.10

Udating my 18.04 installation works without issues (Wayland & libinput touchpad driver).

## 3.1. Install

- Minimal installation, include 3rd party


## 3.2. WIP

- [Caps-Lock Crash](#caps-lock-crash)
- [Suspend Loop](#suspend-loop)
- [Touchscreen & Firefox](#touchscreen--firefox)
- [Libinput-gestures](#libinput-gestures)
- ["Capitaine" Cursors](#capitaine-cursors)
sudo add-apt-repository ppa:dyatlov-igor/la-capitaine
sudo apt update
sudo apt install la-capitaine-cursor-theme


# 4. Ubuntu 18.04

## 4.1. Update

Udating my 17.10 installation works without issues (X11 & Synaptics touchpad driver).
(Currently) I'm running a fresh install based on this tutorial.

## 4.2. Install

Running the live session and starting the installation ends with segfaults.
Select "installation" while boot (Grub / USB Stick) works.

- Minimal installation, include 3rd party

After installation, update and install Intel Microcode

```shell
sudo apt install intel-microcode
```

### 4.2.1. Issues & Fixes

These issues still exist and neeed fixes (including some tweaks):

- [Caps-Lock Crash](#caps-lock-crash)
- [Suspend Loop](#suspend-loop)
- [Touchpad Suspend](#touchpad-suspend)
- [Touchpad Temporary Freezes](#touchpad-temporary-freezes)
- [Touchscreen & Firefox](#touchscreen--firefox)
- [Power Management](#power-management)
- [Touchpad](#touchpad-1)
- ["Capitaine" Cursors](#capitaine-cursors)

### 4.2.2. Touchpad

With libinput, the pointer "jumps" while moving. The synaptics driver hasn't this issue.
Other users with RBS late 2017 reports dead zones, I'm not sure if they have tested the synaptics driver.
Maybe 4.17-1 kernel solves this problem (https://github.com/rolandguelle/razer-blade-stealth-linux/issues/19).

**Note:** 18.10 (beta) works out-of-the-box with libinput.

For me, synaptics works:

```shell
sudo apt install xserver-xorg-input-synaptics
sudo cp etc/X11/xorg.conf.d/50-synaptics.conf /etc/X11/xorg.conf.d/50-synaptics.conf
```

Reboot

Check if synaptics driver is running:

```shell
xinput list-props 'Synaptics TM2438-005'
```

At boot and after suspend, the settings "TapButton3=0 ClickFinger3=0" are gone.
Workaround:

```shell
sudo cp etc/pm/sleep.d/30_synaptics /etc/pm/sleep.d/30_synaptics
cp config/autostart/synaptics.desktop ~/.config/autostart/synaptics.desktop
```

### 4.2.3. WIP

#### 4.2.3.1. Razer Core

##### 4.2.3.1.1. Auth

bolt is installed

$ boltctl list
get <uuid>
$ boltctl enroll <uuid> 

activating with "nouveau" crashes the system.

Trial on error:

- installing nvidia-driver-396
- when insert thundderbolt, nouveau is loaded?
- sudo rmmod nouveau

##### 4.2.3.1.2. bumblebee

$ sudo apt-get install bumblebee bumblebee-nvidia primus linux-headers-generic

PKCS#7 signature not signed wth a trusted key

sudo apt install mesa-utils

sudo apt-get install nvidia-driver-396

tlp suspend // see arch setup

https://github.com/Bumblebee-Project/Bumblebee/issues/951

### 4.2.4. Tweaks

#### 4.2.4.1. Dual Boot Antergos

"update-grub" add only /boot/intel-ucode.img to initrd.
(Maybe) a hack, but works well on my system.

```shell
patch /etc/grub.d/30_os-prober etc/grub.d/os-prober.patch
```

#### 4.2.4.2. Grub

WIP // Razer Grub Theme for RBS 4k

```shell
sudo cp -r themes/grub /boot/grub/themes/razer
sudo cp etc/default/grub /etc/default/grub
sudo update-grub
```

#### 4.2.4.3. Plymouth

WIP // Razer Plymouth Theme

```shell
sudo cp -r themes/plymouth /usr/share/plymouth/themes/razer
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/razer/razer.plymouth 90
sudo update-alternatives --config default.plymouth
sudo update-initramfs -u
```

#### 4.2.4.4. Gnome Theme

My current favorite :)

```shell
apt install numix-gtk-theme numix-icon-theme gnome-icon-theme
```

- Theme Application (Tweaks, Theme): "Numix" (✓)
- Theme Icons (Tweaks, Theme): "Yaru" (✓)
- Theme Sound (Tweaks, Theme): "Yaru" (✓)

#### 4.2.4.5. Steam Interface

Change Steam interface enlargement based on monitor size:

- Settings, Interface, Enlarge text and icons based on monitor size (✓)


# 5. Ubuntu 17.10

## 5.1. Install

- Fresh Ubuntu 17.10 installation, reboot
- Software & Updates
    - Additional Drivers: Using Processor microcode firmware for Intel CPUs from intel-microcode (proprietary)
        - (Secure boot was disabled during installation, but is now activated)
    - Packages: main, universe, restricted, multiverse, artful-proposed

## 5.2. Works

Other tutorials reports issues for some topics/components, but on my machine these are running fine.

### 5.2.1. Graphic Card

Works out of the box **without** the Kernel parameter:

- i915.enable_rc6=0

or X11 UXA mode:

- "AccelMethod"  "uxa"

### 5.2.2. HDMI

Since 4.10.6 kernel, HDMI works out of the box.

### 5.2.3. Thunderbolt / USB-C

USB & video works on my 27'' Dell monitor with a (Apple) USB-C (HDMI, USB) adapter, without modifications (since 4.13.x kernel).
Including USB to ethernet.

## 5.3. Issues

### 5.3.1. Suspend Loop

After resume, the system loops back in suspend.
The system send an ACPI event where the [kernel defaults](https://patchwork.kernel.org/patch/9512307/) are different.

#### 5.3.1.1. Grub Kernel Parameter

Change kernel defaults:

```shell
sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="button.lid_init_state=open"
```

Update grub

```shell
sudo update-grub
```

### 5.3.2. Caps-Lock Crash

The RBS crashes ~~randomly~~ mostly if you hit "Caps Lock", causes by the build-in driver.

#### 5.3.2.1. Disable Capslocks

Modify /etc/default/keyboard, replacing capslocks by a second ctrl:

```shell
sudo nano /etc/default/keyboard
XKBOPTIONS="ctrl:nocaps"
```

#### 5.3.2.2. X11: Disable Built-In Keyboard Driver

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

### 5.3.3. Touchpad Suspend

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

#### 5.3.3.1. Libinput-gestures

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

### 5.3.4. Touchpad Temporary Freezes

The touchpad [temporary freezes](https://insider.razer.com/index.php?threads/ubuntu-17-10-blade-stealth-late-2017-issues.28967/) with libinput.
Manual update libinput & kernel make it _less worse_, but it is still buggy.

Switching from Wayland to X11 and libinput to Synaptics solves the problem.

```shell
sudo apt install xserver-xorg-input-synaptics
```

Edit Synaptics configuration: [50-synaptics.conf](etc/X11/xorg.conf.d/50-synaptics.conf)

Restart and login with X11.

### 5.3.5. Touchscreen & Firefox

Firefox doesn't seem to care about the touchscreen at all.

#### 5.3.5.1. XINPUT2

Tell Firefox to use xinput2

```shell
sudo nano /etc/environment
MOZ_USE_XINPUT2=1
```

Logout - Login.

### 5.3.6. Unstable WIFI

Wireless connection gets lost randomly.

#### 5.3.6.1. Update Firmware

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

### 5.3.7. Onscreen Keyboard

Everytime the touchscreen is used, an onscreen keyboard opens.

#### 5.3.7.1. Block caribou

##### 5.3.7.1.1. Startup Applications

Disable caribou (the on screen keyboard) in "Startup Applications".

Display "hidden apps":

```shell
sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop
```

Open "Startup Applications", disable caribou (and maybe Desktop Sharing, Backup Monitor and some others).

##### 5.3.7.1.2. Extension

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

### 5.3.8. Multiple Monitors

Using a HiDPI and "normal" monitor works on _some_ applications with Wayland, but not in Firefox & Chrome.

#### 5.3.8.1. Switch to 1920x1080

Switch the internal HiDPI screen to **1920x1080** when using your RBS together with a non HiDPI external monitor.
Gnome _remembers_ the monitor and switch back to 4k when unplugging the screen.

## 5.4. Unsolved Issues

### 5.4.1. Keyboard Colors & Openrazer

Currently not used.

[Issue](https://github.com/openrazer/openrazer/issues/342): Settings are lost after suspend (Gnome, Wayland).

But maybe it works for you:

* https://openrazer.github.io/

### 5.4.2. Webcam

Working only with 176x in cheese, or 640x480 in guvcview with 15/1 frames.

[This](https://wiki.archlinux.org/index.php/Razer_Blade#Webcam) fix not really helped:

```shell
/etc/modprobe.d/uvcvideo.conf

## fix issue with built-in webcam
options uvcvideo quirks=512
```

## 5.5. Tweaks

### 5.5.1. Power Management

TLP is an advanced power management tool for Linux that tries to apply tweaks for you automatically, depending on your Linux distribution and hardware.

```shell
sudo apt-get install tlp tlp-rdw
sudo systemctl enable tlp
```

### 5.5.2. Touchpad

#### 5.5.2.1. Click, Tap, Move

macOS touchpad feeling.

```shell
sudo apt install gnome-tweak-tool
```

- Keyboard & Mouse
- Click Method: Fingers

### 5.5.3. Display Scaling

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

### 5.5.4. Theme

My Ubuntu/Gnome tweaks :)

#### 5.5.4.1. "Capitaine" Cursors

- Install ["Capitaine" Cursors](https://github.com/keeferrourke/capitaine-cursors)
- Select via tweaks tool, Appearance, Themes, Cursor

#### 5.5.4.2. Applicatioins Theme

- apt install numix-gtk-theme numix-icon-theme gnome-icon-theme gnome-icon-theme-extras
- Select via tweaks tool, Appearance, Themes, Application (Numix), Icons (Numix-Light)

Current Theme: [Adapta-Eta](https://github.com/adapta-project/adapta-gtk-theme)

#### 5.5.4.3. Dock & Top Bar

- Dock (Settings)
    - Auto-hide the Dock
    - Position on the screen: bottom

#### 5.5.4.4. Fonts

- Window-Title: Garuda Regular 11
- Interface: Ubuntu Regular 12
- Document: Sans Regular 13
- Monospace: Monospace Regular 13

#### 5.5.4.5. Workspace Grid

Switch vertical though your workspaces.

Install Workspace Grid:

* https://github.com/zakkak/workspace-grid

My setup have just vertical workspaces, swipe left/right for switching workspaces:

```shell
# .config/libinput.conf
gesture swipe left      _internal ws_down
gesture swipe right     _internal ws_up
```

## 5.6. Razer Core

Running a thunderbolt 3 device like the [Razer Core](https://www.razerzone.com/gaming-laptops/razer-core-v2) with Linux sounds like fun :)

### 5.6.1. Thunderbolt

The Razer Core is connected via Thunderbold 3 with your RBS.

#### 5.6.1.1. Cable

This [**2m** cable](https://www.amazon.de/CalDigit-Thunderbolt-3-Kabel-Zertifiziert-Typ-C-kompatibel/dp/B01N4MFG7J/) works without problems. I measured no (performance) differences compared with the included _very_ short cable (tested on Windows & Linux).

#### 5.6.1.2. User Authorization

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

### 5.6.2. Discrete NVIDIA GPU

Goal is a setup like:

- Run a _normal_ setup (Wayland, Gnome) - without connected Razer Core
- Hotplug Razer Core (without reboot, login/logout)
- Run selected applications with Razer Core on external NVIDIA GPU
- Unplug the Razer Core - without freezing the system

#### 5.6.2.1. NVIDIA Prime

Install NVIDIA Prime and set it to "intel":

```shell
sudo apt install nvidia-prime
sudo prime-select intel
```

#### 5.6.2.2. NVIDIA GPU Driver

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

#### 5.6.2.3. Bumblebee

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

#### 5.6.2.4. Test GPU With optirun

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

#### 5.6.2.5. Run Extremetuxracer With primusrun

Replace "etr" (Extremetuxracer) with your favorite 3D application/game ;)

```shell
PRIMUS_SYNC=1 vblank_mode=0 primusrun etr
```

- PRIMUS_SYNC sync between NVIDIA and Intel
    - 0: no sync, 1: D lags behind one frame, 2: fully synced
- ignore the refresh rate of your monitor and just try to reach the maximux fps
    - vblank_mode=0

Tested with "Extremetuxracer" and different games on "Steam" (Saints Row IV, Life is Strange and others) with 4k resolution on Wayland & X11.

### 5.6.3. razercore

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

### 5.6.4. External Display

Use eGPU on external displays.

#### 5.6.4.1. Connected At Laptop HDMI

Switch to "Single Display" for gaming:

- Settings, Devices, Single Display

Tested with Samsung TV, XBox 360 controller (plugged in Razer Core) and Steam.

#### 5.6.4.2. Connected At External GPU

Unsolved: Dynamic expand external display:

- https://unix.stackexchange.com/questions/326362/bumblebee-dual-monitor-mirror-fedora-25

##### 5.6.4.2.1. Expand Display

Permanent expand display with external screen, connected at GPU / Razer Core:

- BIOS: Disable Thunderbold Security
- Connect Razer Core via Thunderbold
- Login with Xorg Session
- Keep Thunderbold connected

##### 5.6.4.2.2. Run Applications 'Only' On External Screen

Check if your monitor is detected:

```shell
nvidia-xconfig --query-gpu-info
```

###### 5.6.4.2.2.1. Automatic Setup

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

###### 5.6.4.2.2.2. Manual Setup

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

# 6. Arch (Antergos)

Tested with [Antergos](https://antergos.com/) (Wayland & Gnome) Arch, but other Arch based distros should work too.

## 6.1. Works

Sames as Ubuntu:

- [Graphic Card](#graphic-card)
- [HDMI](#hdmi)
- [Thunderbolt / USB-C](#thunderbolt--usb-c)

Arch (4.15.2-2-ARCH kernel):

- Caps-Lock fix is not needed
- No touchpad issues

## 6.2. Suspend Loop

Add kernel parameter:

```shell
$ sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="button.lid_init_state=open"
```

Update Grub:

```shell
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## 6.3. Touchpad

Works, without suspend issues.

### 6.3.1. Libinput-gestures

Install Libinput-gestures, my [config](config/libinput-gestures.conf).
(If you prefer _natural scrolling_, change up/down)

### 6.3.2. Synaptics (X11)

Disable touchpad while typing and some other tunings:

- [50-synaptics.conf](etc/X11/xorg.conf.d/50-synaptics.conf)

### 6.3.3. Libinput Coordinates

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

## 6.4. More

- [Onscreen Keyboard](#onscreen-keyboard)
    - [Block caribou](#block-caribou)
        - [Extension](#extension)
- [Touchscreen & Firefox](#touchscreen--firefox)
    - [XINPUT2](#xinput2)
- [Unstable WIFI](#unstable-wifi)
    - [Update Firmware](#update-firmware)
- [Multiple Monitors](#multiple-monitors)
    - [Switch to 1920x1080](#switch-to-1920x1080)

## 6.5. Razer Core

### 6.5.1. Installation

Install NVIDIA & bumblebee:

```shell
sudo pacman -S bumblebee primus nvidia nvidia-utils virtualgl
```

Install 32bit driver for steam:

```shell
sudo pacman -S lib32-virtualgl lib32-nvidia-utils
```

### 6.5.2. Setup

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

### 6.5.3. Bash Alias razerrun

Bash Alias:

```shell
$ nano .bashrc
alias razerrun='PRIMUS_SYNC=1 vblank_mode=0 primusrun'
```

Test:

```shell
razerrun glxinfo | grep OpenGL
```

### 6.5.4. Thunderbolt

Install "bolt" for thunderbolt management:

```shell
sudo pacman -S bolt
# Authorize and store a device in the database
boltctl enroll
```

Nice (but useless) Gnome extension: https://github.com/gicmo/bolt-extension

## 6.6. Tweaks

- [Dock & Top Bar](#dock--top-bar)

### 6.6.1. Top Icon Plus

https://github.com/phocean/TopIcons-plus

### 6.6.2. Gdm

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

### 6.6.3. Theme

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

### 6.6.4. Power Management

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

# 7. Other Models

Some fixes, tips & tweaks for other models.

## 7.1. Razer Blade Stealth Late 2017

### 7.1.1. Screen flickering

Workaround, kernel parameter:

```shell
intel_idle.max_cstate=4
```

More: https://wiki.archlinux.org/index.php/Razer_Blade#Late-2017_version_Razer_Blade_Stealth

### 7.1.2. External monitor randomly going blank

- Workaround: Change output channel
- "HDMI / DisplayPort - Built in Audio" (or connect headphones to the stereo jack)
- See: https://github.com/rolandguelle/razer-blade-stealth-linux/issues/18

### 7.1.3. Touchpad deadzones

- Kernel 4.17.1 solve the issue, see (#19)
- See https://github.com/rolandguelle/razer-blade-stealth-linux/issues/19 and [Touchpad](#touchpad).

## 7.2. Razer Blade Stealth Early 2018

### 7.2.1. Screen flickering

Workaround, kernel parameter:

```shell
intel_idle.max_cstate=4
```

More: https://github.com/rolandguelle/razer-blade-stealth-linux/issues/7

# 8. Oher Distros

## 8.1. Elementary OS

- While booting from USB stick, choose direct the "Install Mode" (Option 2)
- First boot after installing, add kernel parameter while booting (grub, press "e"):

```shell
intel_idle.max_cstate=4
```

Add this parameter permantly:

```shell
sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="button.lid_init_state=open intel_idle.max_cstate=4"
```

There are maybe other issues with this distros.

# 9. Credits

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
    - https://github.com/emanuelet