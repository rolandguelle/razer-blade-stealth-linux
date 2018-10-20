# 1. Razer Blade Stealth Linux & Ubuntu 18.10

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) Ubuntu Linux 18.10.

<!-- TOC -->

- [1. Razer Blade Stealth Linux & Ubuntu 18.10](#1-razer-blade-stealth-linux--ubuntu-1810)
- [2. Installation](#2-installation)
- [3. Issues](#3-issues)
  - [3.1. Suspend Loop](#31-suspend-loop)
    - [3.1.1. Grub Kernel Parameter](#311-grub-kernel-parameter)
  - [3.2. Caps-Lock Crash](#32-caps-lock-crash)
    - [3.2.1. Disable Capslocks](#321-disable-capslocks)
  - [3.3. Touchscreen & Firefox](#33-touchscreen--firefox)
    - [3.3.1. XINPUT2](#331-xinput2)
  - [3.4. Gestures with Libinput](#34-gestures-with-libinput)
  - [3.5. Dual Boot Antergos](#35-dual-boot-antergos)
- [4. Tweaks](#4-tweaks)
  - [4.1. "Capitaine" Cursors](#41-capitaine-cursors)
  - [4.2. Grub Theme](#42-grub-theme)
  - [4.3. Plymouth Theme](#43-plymouth-theme)

<!-- /TOC -->

# 2. Installation

- 18.04 -> 18.10 update works without issues (Wayland & libinput touchpad driver)
- Fresh minimal installation, include 3rd party

# 3. Issues

## 3.1. Suspend Loop

After resume, the system loops back in suspend.
The system send an ACPI event where the [kernel defaults](https://patchwork.kernel.org/patch/9512307/) are different.

### 3.1.1. Grub Kernel Parameter

Change kernel defaults:

```shell
sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash button.lid_init_state=open"
```

Update grub

```shell
sudo update-grub
```

## 3.2. Caps-Lock Crash

The RBS crashes ~~randomly~~ mostly if you hit "Caps Lock", causes by the build-in driver.

### 3.2.1. Disable Capslocks

Modify /etc/default/keyboard, replacing capslocks by a second ctrl:

```shell
sudo nano /etc/default/keyboard
XKBOPTIONS="ctrl:nocaps"
```

## 3.3. Touchscreen & Firefox

Firefox doesn't seem to care about the touchscreen at all.

### 3.3.1. XINPUT2

Tell Firefox to use xinput2

```shell
sudo nano /etc/environment
MOZ_USE_XINPUT2=1
```

Logout - Login.

## 3.4. Gestures with Libinput

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

## 3.5. Dual Boot Antergos

"update-grub" add only /boot/intel-ucode.img to initrd.
(Maybe) a hack, but works well on my system.

```shell
sudo patch /etc/grub.d/30_os-prober etc/grub.d/os-prober.patch
```

# 4. Tweaks

## 4.1. "Capitaine" Cursors

- Install ["Capitaine" Cursors](https://github.com/keeferrourke/capitaine-cursors)

```shell
sudo add-apt-repository ppa:dyatlov-igor/la-capitaine
sudo apt update
sudo apt install la-capitaine-cursor-theme
```

- Select via tweaks tool, Appearance, Themes, Cursor

## 4.2. Grub Theme

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

## 4.3. Plymouth Theme

Razer Plymouth Theme

```shell
sudo cp -r themes/plymouth /usr/share/plymouth/themes/razer
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/razer/razer.plymouth 90
sudo update-alternatives --config default.plymouth # select razer theme
sudo update-initramfs -u
```
