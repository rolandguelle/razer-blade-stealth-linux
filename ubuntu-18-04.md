# Razer Blade Stealth Linux & Ubuntu 18.04

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) Ubuntu Linux 18.04.

- [Razer Blade Stealth Linux & Ubuntu 18.04](#razer-blade-stealth-linux--ubuntu-1804)
  - [1. Issues](#1-issues)
    - [1.1. Installation](#11-installation)
    - [1.2. Suspend Loop](#12-suspend-loop)
    - [1.3. Caps-Lock Crash](#13-caps-lock-crash)
    - [1.4. Touchpad Temporary Freezes](#14-touchpad-temporary-freezes)
    - [1.5. Touchpad Suspend](#15-touchpad-suspend)
    - [1.6. Touchscreen & Firefox](#16-touchscreen--firefox)
  - [2. Tweaks](#2-tweaks)
    - [2.1. Power Management](#21-power-management)
    - [2.2. Touchpad tap & click](#22-touchpad-tap--click)
    - [2.3. "Capitaine" Cursors](#23-%22capitaine%22-cursors)
    - [2.4. Dual Boot Antergos](#24-dual-boot-antergos)
    - [2.5. Grub Razer Theme](#25-grub-razer-theme)
    - [2.7. Gnome Theme](#27-gnome-theme)
    - [2.8. Steam Interface](#28-steam-interface)
  - [3. Unsolved Issues](#3-unsolved-issues)
    - [3.1. Keyboard Colors & Openrazer](#31-keyboard-colors--openrazer)
    - [3.2. Webcam](#32-webcam)
    - [3.3. Razer Core](#33-razer-core)

<!-- /TOC -->

## 1. Issues

### 1.1. Installation

Running the live session and starting the installation ends with **segfaults**.

- Select "Installation" while boot (Grub / USB Stick) works.
- Minimal installation, include 3rd party
- After installation, update and install Intel Microcode

```shell
sudo apt install intel-microcode
```

### 1.2. Suspend Loop

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

### 1.3. Caps-Lock Crash

The RBS crashes ~~randomly~~ mostly if you hit "Caps Lock", causes by the build-in driver.

Modify /etc/default/keyboard, replacing capslocks by a second ctrl:

```shell
sudo nano /etc/default/keyboard
XKBOPTIONS="ctrl:nocaps"
```

__Solution 2:__

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

### 1.4. Touchpad Temporary Freezes

With libinput, the pointer "jumps" while moving. The synaptics driver hasn't this issue.
Other users with RBS late 2017 reports dead zones, I'm not sure if they have tested the synaptics driver.
Maybe 4.17-1 kernel solves this problem [Issue 19](https://github.com/rolandguelle/razer-blade-stealth-linux/issues/19).

**Note:** A new kernel workd better with libinput.

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

### 1.5. Touchpad Suspend

Touchpad fails resuming from suspend with:

```shell
rmi4_physical rmi4-00: rmi_driver_reset_handler: Failed to read current IRQ mask.
dpm_run_callback(): i2c_hid_resume+0x0/0x120 [i2c_hid] returns -11
PM: Device i2c-15320205:00 failed to resume async: error -11
```

__Temporary fix:__

```shell
sudo rmmod i2c_hid && sudo modprobe i2c_hid
```

__Solution:__

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

### 1.6. Touchscreen & Firefox

Firefox doesn't seem to care about the touchscreen at all.

Tell Firefox to use XINPUT2:

```shell
sudo nano /etc/environment
MOZ_USE_XINPUT2=1
```

Logout - Login.

## 2. Tweaks

### 2.1. Power Management

TLP is an advanced power management tool for Linux that tries to apply tweaks for you automatically, depending on your Linux distribution and hardware.

```shell
sudo apt-get install tlp tlp-rdw
sudo systemctl enable tlp
```

### 2.2. Touchpad tap & click

macOS touchpad feeling.

```shell
sudo apt install gnome-tweak-tool
```

- Keyboard & Mouse
- Click Method: Fingers
  
### 2.3. "Capitaine" Cursors

- Install ["Capitaine" Cursors](https://github.com/keeferrourke/capitaine-cursors)
- Select via tweaks tool, Appearance, Themes, Cursor

### 2.4. Dual Boot Antergos

"update-grub" add only /boot/intel-ucode.img to initrd.
(Maybe) a hack, but works well on my system.

```shell
patch /etc/grub.d/30_os-prober etc/grub.d/os-prober.patch
```

### 2.5. Grub Razer Theme

```shell
sudo cp -r themes/grub /boot/grub/themes/razer
sudo cp etc/default/grub /etc/default/grub
sudo update-grub
```

### 2.7. Gnome Theme

My current favorite :)

```shell
apt install numix-gtk-theme numix-icon-theme gnome-icon-theme
```

- Theme Application (Tweaks, Theme): "Numix" (✓)
- Theme Icons (Tweaks, Theme): "Yaru" (✓)
- Theme Sound (Tweaks, Theme): "Yaru" (✓)

### 2.8. Steam Interface

Change Steam interface enlargement based on monitor size:

- Settings, Interface, Enlarge text and icons based on monitor size

## 3. Unsolved Issues

### 3.1. Keyboard Colors & Openrazer

Currently [Openrazer](https://openrazer.github.io/) not used.

[Issue](https://github.com/openrazer/openrazer/issues/342): Settings are lost after suspend (Gnome, Wayland).

### 3.2. Webcam

Working only with 176x in cheese, or 640x480 in guvcview with 15/1 frames.

[This](https://wiki.archlinux.org/index.php/Razer_Blade#Webcam) fix not really helped:

```shell
/etc/modprobe.d/uvcvideo.conf

## fix issue with built-in webcam
options uvcvideo quirks=512
```

### 3.3. Razer Core

Thunderbolt works, but nvidia with optirun won't work.