# Razer Blade Stealth Linux & Ubuntu 18.10

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) Ubuntu Linux 18.10.

<!-- TOC depthFrom:2 -->

- [1. Issues](#1-issues)
  - [1.1. Suspend Loop](#11-suspend-loop)
  - [1.2. Caps-Lock Crash](#12-caps-lock-crash)
  - [1.3. Touchscreen & Firefox](#13-touchscreen--firefox)
  - [1.4. Gestures with Libinput](#14-gestures-with-libinput)
  - [1.5. Dual Boot Antergos](#15-dual-boot-antergos)
- [2. Tweaks](#2-tweaks)
  - [2.1. "Capitaine" Cursors](#21-capitaine-cursors)
  - [2.2. Grub Theme](#22-grub-theme)
- [3. Unsolved Issues](#3-unsolved-issues)
  - [3.1. Keyboard Colors & Openrazer](#31-keyboard-colors--openrazer)
  - [3.2. Webcam](#32-webcam)
  - [3.3. Wifi](#33-wifi)
  - [3.4. Razer Core (WIP)](#34-razer-core-wip)

<!-- /TOC -->

## 1. Issues

### 1.1. Suspend Loop

After resume, the system loops back in suspend.
The system send an ACPI event where the [kernel defaults](https://patchwork.kernel.org/patch/9512307/) are different.

Change kernel defaults:

```shell
sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash button.lid_init_state=open"
```

Update grub

```shell
sudo update-grub
```

### 1.2. Caps-Lock Crash

The RBS crashes ~~randomly~~ mostly if you hit "Caps Lock", causes by the build-in driver.

Modify /etc/default/keyboard, replacing capslocks by a second ctrl:

```shell
sudo nano /etc/default/keyboard
XKBOPTIONS="ctrl:nocaps"
```

### 1.3. Touchscreen & Firefox

Firefox doesn't seem to care about the touchscreen at all.
Tell Firefox to use XINPUT2:

```shell
sudo nano /etc/environment
MOZ_USE_XINPUT2=1
```

Logout - Login.

### 1.4. Gestures with Libinput

Setup [Libinput-gestures](https://github.com/bulletmark/libinput-gestures):

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

### 1.5. Dual Boot Antergos

"update-grub" add only /boot/intel-ucode.img to initrd.
(Maybe) a hack, but works well on my system.

```shell
sudo patch /etc/grub.d/30_os-prober etc/grub.d/os-prober.patch
```

## 2. Tweaks

### 2.1. "Capitaine" Cursors

- Install ["Capitaine" Cursors](https://github.com/keeferrourke/capitaine-cursors)

```shell
sudo add-apt-repository ppa:dyatlov-igor/la-capitaine
sudo apt update
sudo apt install la-capitaine-cursor-theme
```

- Select via tweaks tool, Appearance, Themes, Cursor

### 2.2. Grub Theme

Razer Grub Theme for RBS 4k.

```shell
sudo mkdir /boot/grub/themes
sudo cp -r themes/grub /boot/grub/themes/razer
```

Add Theme:

```shell
sudo nano /etc/default/grub
GRUB_GFXMODE="3840x2160-32"
GRUB_GFXPAYLOAD_LINUX="3840x2160-32"
GRUB_THEME="/boot/grub/themes/razer/theme.txt"
```

Update Grub

```shell
sudo update-grub
```

## 3. Unsolved Issues

### 3.1. Keyboard Colors & Openrazer

* https://openrazer.github.io/

[Issue](https://github.com/openrazer/openrazer/issues/342): Settings are lost after suspend (Gnome, Wayland).

### 3.2. Webcam

Working only with 176x in cheese, or 640x480 in guvcview with 15/1 frames.

[This](https://wiki.archlinux.org/index.php/Razer_Blade#Webcam) fix not really helped:

```shell
/etc/modprobe.d/uvcvideo.conf

## fix issue with built-in webcam
options uvcvideo quirks=512
```

### 3.3. Wifi

Connection lost, maybe firmware

### 3.4. Razer Core (WIP)

- Auth over Settings -> Devices -> Thunderbolt
- Razer Core: Authorized
- Install nvidia-driver-390
