# 1. Razer Blade Stealth Linux & Arch (Antergos)

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) Arch (Antergos).
Tested with [Antergos](https://antergos.com/) (Wayland & Gnome) Arch, but other Arch based distros should work too.

<!-- TOC -->

- [1. Razer Blade Stealth Linux & Arch (Antergos)](#1-razer-blade-stealth-linux--arch-antergos)
  - [1.1. Works](#11-works)
  - [1.2. Suspend Loop](#12-suspend-loop)
  - [1.3. Touchpad](#13-touchpad)
    - [1.3.1. Libinput-gestures](#131-libinput-gestures)
    - [1.3.2. Synaptics (X11)](#132-synaptics-x11)
    - [1.3.3. Libinput Coordinates](#133-libinput-coordinates)
  - [1.4. More](#14-more)
  - [1.5. Razer Core](#15-razer-core)
    - [1.5.1. Installation](#151-installation)
    - [1.5.2. Setup](#152-setup)
    - [1.5.3. Bash Alias razerrun](#153-bash-alias-razerrun)
    - [1.5.4. Thunderbolt](#154-thunderbolt)
  - [1.6. Tweaks](#16-tweaks)
    - [1.6.1. Top Icon Plus](#161-top-icon-plus)
    - [1.6.2. Gdm](#162-gdm)
    - [1.6.3. Theme](#163-theme)
    - [1.6.4. Power Management](#164-power-management)

<!-- /TOC -->

## 1.1. Works

Arch (4.15.2-2-ARCH kernel):

- Caps-Lock fix is not needed
- No touchpad issues

## 1.2. Suspend Loop

Add kernel parameter:

```shell
$ sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="button.lid_init_state=open"
```

Update Grub:

```shell
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## 1.3. Touchpad

Works, without suspend issues.

### 1.3.1. Libinput-gestures

Install Libinput-gestures, my [config](config/libinput-gestures.conf).
(If you prefer _natural scrolling_, change up/down)

### 1.3.2. Synaptics (X11)

Disable touchpad while typing and some other tunings:

- [50-synaptics.conf](etc/X11/xorg.conf.d/50-synaptics.conf)

### 1.3.3. Libinput Coordinates

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

## 1.4. More

- [Onscreen Keyboard](#onscreen-keyboard)
    - [Block caribou](#block-caribou)
        - [Extension](#extension)
- [Touchscreen & Firefox](#touchscreen--firefox)
    - [XINPUT2](#xinput2)
- [Unstable WIFI](#unstable-wifi)
    - [Update Firmware](#update-firmware)
- [Multiple Monitors](#multiple-monitors)
    - [Switch to 1920x1080](#switch-to-1920x1080)

## 1.5. Razer Core

### 1.5.1. Installation

Install NVIDIA & bumblebee:

```shell
sudo pacman -S bumblebee primus nvidia nvidia-utils virtualgl
```

Install 32bit driver for steam:

```shell
sudo pacman -S lib32-virtualgl lib32-nvidia-utils
```

### 1.5.2. Setup

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

### 1.5.3. Bash Alias razerrun

Bash Alias:

```shell
$ nano .bashrc
alias razerrun='PRIMUS_SYNC=1 vblank_mode=0 primusrun'
```

Test:

```shell
razerrun glxinfo | grep OpenGL
```

### 1.5.4. Thunderbolt

Install "bolt" for thunderbolt management:

```shell
sudo pacman -S bolt
# Authorize and store a device in the database
boltctl enroll
```

Nice (but useless) Gnome extension: https://github.com/gicmo/bolt-extension

## 1.6. Tweaks

- [Dock & Top Bar](#dock--top-bar)

### 1.6.1. Top Icon Plus

https://github.com/phocean/TopIcons-plus

### 1.6.2. Gdm

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

### 1.6.3. Theme

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

### 1.6.4. Power Management

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
