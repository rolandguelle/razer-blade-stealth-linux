# Razer Blade Stealth Linux & Arch (Antergos)

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) Arch (Antergos).
Tested with [Antergos](https://antergos.com/) (Wayland & Gnome) Arch, but other Arch based distros should work too.

<!-- TOC depthFrom:2 -->

- [1. Issues](#1-issues)
  - [1.1. Suspend Loop](#11-suspend-loop)
  - [1.2. Touchpad](#12-touchpad)
    - [1.2.1. Libinput-gestures](#121-libinput-gestures)
    - [1.2.2. Synaptics (X11)](#122-synaptics-x11)
    - [1.2.3. Libinput Coordinates](#123-libinput-coordinates)
  - [1.3. Onscreen Keyboard](#13-onscreen-keyboard)
  - [1.4. Touchscreen & Firefox](#14-touchscreen--firefox)
- [2. Razer Core](#2-razer-core)
  - [2.1. Installation](#21-installation)
  - [2.2. Setup](#22-setup)
  - [2.3. Bash Alias razerrun](#23-bash-alias-razerrun)
  - [2.4. Thunderbolt](#24-thunderbolt)
- [3. Tweaks](#3-tweaks)
  - [3.1. Top Icon Plus](#31-top-icon-plus)
  - [3.2. Gdm](#32-gdm)
  - [3.3. Theme](#33-theme)
  - [3.4. Power Management](#34-power-management)

<!-- /TOC -->

## 1. Issues

Works **without** Problems:

- Caps-Lock fix is not needed
- No touchpad issues

### 1.1. Suspend Loop

Add kernel parameter:

```shell
$ sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="button.lid_init_state=open"
```

Update Grub:

```shell
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### 1.2. Touchpad

Works, without suspend issues.

#### 1.2.1. Libinput-gestures

Install Libinput-gestures, my [config](config/libinput-gestures.conf).
(If you prefer _natural scrolling_, change up/down)

#### 1.2.2. Synaptics (X11)

Disable touchpad while typing and some other tunings:

- [50-synaptics.conf](etc/X11/xorg.conf.d/50-synaptics.conf)

#### 1.2.3. Libinput Coordinates

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

### 1.3. Onscreen Keyboard

Everytime the touchscreen is used, an onscreen keyboard opens.

__Block caribou: Step 1__

Disable caribou (the on screen keyboard) in "Startup Applications".

Display "hidden apps":

```shell
sudo sed -i 's/NoDisplay=true/NoDisplay=false/g' /etc/xdg/autostart/*.desktop
```

Open "Startup Applications", disable caribou (and maybe Desktop Sharing, Backup Monitor and some others).

__Block caribou: Step 2__

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

### 1.4. Touchscreen & Firefox

Firefox doesn't seem to care about the touchscreen at all.

Tell Firefox to use XINPUT2:

```shell
sudo nano /etc/environment
MOZ_USE_XINPUT2=1
```

Logout - Login.

## 2. Razer Core

### 2.1. Installation

Install NVIDIA & bumblebee:

```shell
sudo pacman -S bumblebee primus nvidia nvidia-utils virtualgl
```

Install 32bit driver for steam:

```shell
sudo pacman -S lib32-virtualgl lib32-nvidia-utils
```

### 2.2. Setup

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

### 2.3. Bash Alias razerrun

Bash Alias:

```shell
$ nano .bashrc
alias razerrun='PRIMUS_SYNC=1 vblank_mode=0 primusrun'
```

Test:

```shell
razerrun glxinfo | grep OpenGL
```

### 2.4. Thunderbolt

Install "bolt" for thunderbolt management:

```shell
sudo pacman -S bolt
# Authorize and store a device in the database
boltctl enroll
```

Nice (but useless) Gnome extension: https://github.com/gicmo/bolt-extension

## 3. Tweaks

- [Dock & Top Bar](#dock--top-bar)

### 3.1. Top Icon Plus

https://github.com/phocean/TopIcons-plus

### 3.2. Gdm

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

### 3.3. Theme

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

### 3.4. Power Management

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
