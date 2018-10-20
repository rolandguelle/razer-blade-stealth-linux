# 1. Razer Blade Stealth Linux & Ubuntu 18.10

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) Ubuntu Linux 18.10.

<!-- TOC -->

- [1. Razer Blade Stealth Linux & Ubuntu 18.10](#1-razer-blade-stealth-linux--ubuntu-1810)
- [2. Issues](#2-issues)
  - [2.1. Suspend Loop](#21-suspend-loop)
    - [2.1.1. Grub Kernel Parameter](#211-grub-kernel-parameter)
  - [2.2. Caps-Lock Crash](#22-caps-lock-crash)
    - [2.2.1. Disable Capslocks](#221-disable-capslocks)
  - [2.3. Touchscreen & Firefox](#23-touchscreen--firefox)
    - [2.3.1. XINPUT2](#231-xinput2)
  - [2.4. Gestures with Libinput](#24-gestures-with-libinput)
  - [2.5. Dual Boot Antergos](#25-dual-boot-antergos)
- [3. Tweaks](#3-tweaks)
  - [3.1. "Capitaine" Cursors](#31-capitaine-cursors)
  - [3.2. Grub Theme](#32-grub-theme)
  - [3.3. Plymouth Theme](#33-plymouth-theme)

<!-- /TOC -->

# 2. Issues

## 2.1. Suspend Loop

After resume, the system loops back in suspend.
The system send an ACPI event where the [kernel defaults](https://patchwork.kernel.org/patch/9512307/) are different.

### 2.1.1. Grub Kernel Parameter

Change kernel defaults:

```shell
sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash button.lid_init_state=open"
```

Update grub

```shell
sudo update-grub
```

## 2.2. Caps-Lock Crash

The RBS crashes ~~randomly~~ mostly if you hit "Caps Lock", causes by the build-in driver.

### 2.2.1. Disable Capslocks

Modify /etc/default/keyboard, replacing capslocks by a second ctrl:

```shell
sudo nano /etc/default/keyboard
XKBOPTIONS="ctrl:nocaps"
```

## 2.3. Touchscreen & Firefox

Firefox doesn't seem to care about the touchscreen at all.

### 2.3.1. XINPUT2

Tell Firefox to use xinput2

```shell
sudo nano /etc/environment
MOZ_USE_XINPUT2=1
```

Logout - Login.

## 2.4. Gestures with Libinput

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

## 2.5. Dual Boot Antergos

"update-grub" add only /boot/intel-ucode.img to initrd.
(Maybe) a hack, but works well on my system.

```shell
sudo patch /etc/grub.d/30_os-prober etc/grub.d/os-prober.patch
```

# 3. Tweaks

## 3.1. "Capitaine" Cursors

- Install ["Capitaine" Cursors](https://github.com/keeferrourke/capitaine-cursors)

```shell
sudo add-apt-repository ppa:dyatlov-igor/la-capitaine
sudo apt update
sudo apt install la-capitaine-cursor-theme
```

- Select via tweaks tool, Appearance, Themes, Cursor

## 3.2. Grub Theme

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

## 3.3. Plymouth Theme

Razer Plymouth Theme

```shell
sudo cp -r themes/plymouth /usr/share/plymouth/themes/razer
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/razer/razer.plymouth 90
sudo update-alternatives --config default.plymouth # select razer theme
sudo update-initramfs -u
```