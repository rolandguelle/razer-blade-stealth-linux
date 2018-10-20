# 1. Razer Blade Stealth Linux & Ubuntu 18.04

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) Ubuntu Linux 18.04.

<!-- TOC -->

- [1. Razer Blade Stealth Linux & Ubuntu 18.04](#1-razer-blade-stealth-linux--ubuntu-1804)
- [2. Update](#2-update)
- [3. Install](#3-install)
- [4. Issues](#4-issues)
  - [4.1. Touchpad](#41-touchpad)
- [5. Tweaks](#5-tweaks)
  - [5.1. Dual Boot Antergos](#51-dual-boot-antergos)
  - [5.2. Grub Razer Theme](#52-grub-razer-theme)
  - [5.3. Plymouth Razer Theme](#53-plymouth-razer-theme)
  - [5.4. Gnome Theme](#54-gnome-theme)
  - [5.5. Steam Interface](#55-steam-interface)

<!-- /TOC -->

# 2. Update

Udating my 17.10 installation works without issues (X11 & Synaptics touchpad driver).

# 3. Install

Running the live session and starting the installation ends with segfaults.
Select "installation" while boot (Grub / USB Stick) works.

- Minimal installation, include 3rd party

After installation, update and install Intel Microcode

```shell
sudo apt install intel-microcode
```

# 4. Issues

These issues still exist and neeed fixes (including some tweaks):

- [Caps-Lock Crash](#caps-lock-crash)
- [Suspend Loop](#suspend-loop)
- [Touchpad Suspend](#touchpad-suspend)
- [Touchpad Temporary Freezes](#touchpad-temporary-freezes)
- [Touchscreen & Firefox](#touchscreen--firefox)
- [Power Management](#power-management)
- [Touchpad](#touchpad-1)
- ["Capitaine" Cursors](#capitaine-cursors)

## 4.1. Touchpad

With libinput, the pointer "jumps" while moving. The synaptics driver hasn't this issue.
Other users with RBS late 2017 reports dead zones, I'm not sure if they have tested the synaptics driver.
Maybe 4.17-1 kernel solves this problem (https://github.com/rolandguelle/razer-blade-stealth-linux/issues/19).

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

# 5. Tweaks

## 5.1. Dual Boot Antergos

"update-grub" add only /boot/intel-ucode.img to initrd.
(Maybe) a hack, but works well on my system.

```shell
patch /etc/grub.d/30_os-prober etc/grub.d/os-prober.patch
```

## 5.2. Grub Razer Theme

```shell
sudo cp -r themes/grub /boot/grub/themes/razer
sudo cp etc/default/grub /etc/default/grub
sudo update-grub
```

## 5.3. Plymouth Razer Theme

```shell
sudo cp -r themes/plymouth /usr/share/plymouth/themes/razer
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/razer/razer.plymouth 90
sudo update-alternatives --config default.plymouth
sudo update-initramfs -u
```

## 5.4. Gnome Theme

My current favorite :)

```shell
apt install numix-gtk-theme numix-icon-theme gnome-icon-theme
```

- Theme Application (Tweaks, Theme): "Numix" (✓)
- Theme Icons (Tweaks, Theme): "Yaru" (✓)
- Theme Sound (Tweaks, Theme): "Yaru" (✓)

## 5.5. Steam Interface

Change Steam interface enlargement based on monitor size:

- Settings, Interface, Enlarge text and icons based on monitor size 