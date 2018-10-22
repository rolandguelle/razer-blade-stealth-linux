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
  - [2.3. Steam Interface](#23-steam-interface)
- [3. Razer Core](#3-razer-core)
  - [3.1. Thunderbolt](#31-thunderbolt)
  - [3.2. Nvidia Driver](#32-nvidia-driver)
  - [3.3. Bumblebee](#33-bumblebee)
  - [3.4. Steam](#34-steam)
  - [3.5. WIP](#35-wip)
- [4. Unsolved Issues](#4-unsolved-issues)
  - [4.1. Keyboard Colors & Openrazer](#41-keyboard-colors--openrazer)
  - [4.2. Webcam](#42-webcam)
  - [4.3. Wifi](#43-wifi)

<!-- /TOC -->

## 1. Issues

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

### 2.3. Steam Interface

Change Steam interface enlargement based on monitor size:

- Settings, Interface, Enlarge text and icons based on monitor size

## 3. Razer Core

Running a thunderbolt 3 device like the [Razer Core](https://www.razerzone.com/gaming-laptops/razer-core-v2) and an external GPU with Linux sounds like fun :)

### 3.1. Thunderbolt

- Authorization: Settings -> Devices -> Thunderbolt
- This [**2m** cable](https://www.amazon.de/CalDigit-Thunderbolt-3-Kabel-Zertifiziert-Typ-C-kompatibel/dp/B01N4MFG7J/) works without problems. I measured no (performance) differences compared with the included _very_ short cable (tested on Windows & Linux).
- Razer Core: Authorized

### 3.2. Nvidia Driver

Install nvidia-driver-390, over Software-Settings or manually:

```shell
sudo apt install nvidia-driver-390
```

### 3.3. Bumblebee

Install [Bumblebee / Primus](https://wiki.ubuntu.com/Bumblebee#Installation):

```shell
sudo apt-get install bumblebee bumblebee-nvidia primus linux-headers-generic
```

Change [bumblebee.conf](https://askubuntu.com/questions/1029169/bumblebee-doesnt-work-on-ubuntu-18-04/1042950#1042950)

```shell
sudo nano /etc/bumblebee/bumblebbee.comf
LibraryPath=/usr/lib/x86_64-linux-gnu:/usr/lib/i386-linux-gnu
XorgModulePath=/usr/lib/x86_64-linux-gnu/nvidia/xorg,/usr/lib/xorg/modules,/usr/lib/xorg/modules/input
```

Change [/etc/environment](https://askubuntu.com/questions/1029169/bumblebee-doesnt-work-on-ubuntu-18-04/1042950#1042950)

```shell
sudo nano /etc/environment
__GLVND_DISALLOW_PATCHING=1
```

Create [Nvidia Blacklist](https://askubuntu.com/questions/1029169/bumblebee-doesnt-work-on-ubuntu-18-04/1042950#1042950):

```shell
sudo nano /etc/modprobe.d/blacklist-nvidia.conf
blacklist nvidia
blacklist nvidia-drm
blacklist nvidia-modeset
```

Patch [primusrun](https://github.com/Bumblebee-Project/Bumblebee/issues/951#issuecomment-379512353)

```shell
sudo mv /usr/bin/primusrun /usr/bin/primusrun.bak
sudo cp usr/bin/primusrun /usr/bin/
```

Run game on external GPU:

```shell
primusrun 0ad
```

### 3.4. Steam

Run steam games on your external GPU over Bumblebee/primusrun:

- Start steam
- Select your game
- Select "Properties"
- "Set Launch Options"
- Insert "primusrun %command%"

### 3.5. WIP

- External screen

## 4. Unsolved Issues

### 4.1. Keyboard Colors & Openrazer

[Openrazer](https://openrazer.github.io/) lost settings after suspend.

[Issue](https://github.com/openrazer/openrazer/issues/342): Settings are lost after suspend (Gnome, Wayland).

### 4.2. Webcam

Working only with 176x in cheese, or 640x480 in guvcview with 15/1 frames.

[This](https://wiki.archlinux.org/index.php/Razer_Blade#Webcam) fix not really helped:

```shell
/etc/modprobe.d/uvcvideo.conf
options uvcvideo quirks=512
```

**Web Browser:**

"works almost perfectly (at least it's not all green or black and have decent fps) using Slack or Hangout"

- [Issue 21](https://github.com/rolandguelle/razer-blade-stealth-linux/issues/21)
- [Browser Test](https://www.cam-recorder.com/)

### 4.3. Wifi

Connection lost, maybe firmware