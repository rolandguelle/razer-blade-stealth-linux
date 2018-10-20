# 1. Razer Blade Stealth Linux & Arch (Antergos)

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) Arch (Antergos).
Tested with [Antergos](https://antergos.com/) (Wayland & Gnome) Arch, but other Arch based distros should work too.

<!-- TOC -->

- [1. Razer Blade Stealth Linux & Arch (Antergos)](#1-razer-blade-stealth-linux--arch-antergos)
- [2. Works](#2-works)
- [3. Issues](#3-issues)
  - [3.1. Suspend Loop](#31-suspend-loop)
  - [3.2. Touchpad](#32-touchpad)
    - [3.2.1. Libinput-gestures](#321-libinput-gestures)
    - [3.2.2. Synaptics (X11)](#322-synaptics-x11)
    - [3.2.3. Libinput Coordinates](#323-libinput-coordinates)
  - [3.3. Onscreen Keyboard](#33-onscreen-keyboard)
    - [3.3.1. Block caribou](#331-block-caribou)
      - [3.3.1.1. Startup Applications](#3311-startup-applications)
      - [3.3.1.2. Extension](#3312-extension)
  - [3.4. Touchscreen & Firefox](#34-touchscreen--firefox)
    - [3.4.1. XINPUT2](#341-xinput2)
- [4. Razer Core](#4-razer-core)
  - [4.1. Installation](#41-installation)
  - [4.2. Setup](#42-setup)
  - [4.3. Bash Alias razerrun](#43-bash-alias-razerrun)
  - [4.4. Thunderbolt](#44-thunderbolt)
- [5. Tweaks](#5-tweaks)
  - [5.1. Top Icon Plus](#51-top-icon-plus)
  - [5.2. Gdm](#52-gdm)
  - [5.3. Theme](#53-theme)
  - [5.4. Power Management](#54-power-management)

<!-- /TOC -->

# 2. Works

Arch (4.15.2-2-ARCH kernel):

- Caps-Lock fix is not needed
- No touchpad issues

# 3. Issues

## 3.1. Suspend Loop

Add kernel parameter:

```shell
$ sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="button.lid_init_state=open"
```

Update Grub:

```shell
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## 3.2. Touchpad

Works, without suspend issues.

### 3.2.1. Libinput-gestures

Install Libinput-gestures, my [config](config/libinput-gestures.conf).
(If you prefer _natural scrolling_, change up/down)

### 3.2.2. Synaptics (X11)

Disable touchpad while typing and some other tunings:

- [50-synaptics.conf](etc/X11/xorg.conf.d/50-synaptics.conf)

### 3.2.3. Libinput Coordinates

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

## 3.3. Onscreen Keyboard

Everytime the touchscreen is used, an onscreen keyboard opens.

### 3.3.1. Block caribou

#### 3.3.1.1. Startup Applications

Disable caribou (the on screen keyboard) in "Startup Applications".

Display "hidden apps":

```shell
sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop
```

Open "Startup Applications", disable caribou (and maybe Desktop Sharing, Backup Monitor and some others).

#### 3.3.1.2. Extension

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


## 3.4. Touchscreen & Firefox

Firefox doesn't seem to care about the touchscreen at all.

### 3.4.1. XINPUT2

Tell Firefox to use xinput2

```shell
sudo nano /etc/environment
MOZ_USE_XINPUT2=1
```

Logout - Login.


# 4. Razer Core

## 4.1. Installation

Install NVIDIA & bumblebee:

```shell
sudo pacman -S bumblebee primus nvidia nvidia-utils virtualgl
```

Install 32bit driver for steam:

```shell
sudo pacman -S lib32-virtualgl lib32-nvidia-utils
```

## 4.2. Setup

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

## 4.3. Bash Alias razerrun

Bash Alias:

```shell
$ nano .bashrc
alias razerrun='PRIMUS_SYNC=1 vblank_mode=0 primusrun'
```

Test:

```shell
razerrun glxinfo | grep OpenGL
```

## 4.4. Thunderbolt

Install "bolt" for thunderbolt management:

```shell
sudo pacman -S bolt
# Authorize and store a device in the database
boltctl enroll
```

Nice (but useless) Gnome extension: https://github.com/gicmo/bolt-extension

# 5. Tweaks

- [Dock & Top Bar](#dock--top-bar)

## 5.1. Top Icon Plus

https://github.com/phocean/TopIcons-plus

## 5.2. Gdm

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

## 5.3. Theme

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

## 5.4. Power Management

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
