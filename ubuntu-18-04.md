# 1. Razer Blade Stealth Linux & Ubuntu 18.04

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) Ubuntu Linux 18.04.

<!-- TOC -->

- [1. Razer Blade Stealth Linux & Ubuntu 18.04](#1-razer-blade-stealth-linux--ubuntu-1804)
  - [1.1. Update](#11-update)
  - [1.2. Install](#12-install)
    - [1.2.1. Issues](#121-issues)
    - [1.2.2. Touchpad](#122-touchpad)
    - [1.2.3. WIP](#123-wip)
      - [1.2.3.1. Razer Core](#1231-razer-core)
        - [1.2.3.1.1. Auth](#12311-auth)
        - [1.2.3.1.2. bumblebee](#12312-bumblebee)
    - [1.2.4. Tweaks](#124-tweaks)
      - [1.2.4.1. Dual Boot Antergos](#1241-dual-boot-antergos)
      - [1.2.4.2. Grub](#1242-grub)
      - [1.2.4.3. Plymouth](#1243-plymouth)
      - [1.2.4.4. Gnome Theme](#1244-gnome-theme)
      - [1.2.4.5. Steam Interface](#1245-steam-interface)

<!-- /TOC -->

## 1.1. Update

Udating my 17.10 installation works without issues (X11 & Synaptics touchpad driver).
(Currently) I'm running a fresh install based on this tutorial.

## 1.2. Install

Running the live session and starting the installation ends with segfaults.
Select "installation" while boot (Grub / USB Stick) works.

- Minimal installation, include 3rd party

After installation, update and install Intel Microcode

```shell
sudo apt install intel-microcode
```

### 1.2.1. Issues

These issues still exist and neeed fixes (including some tweaks):

- [Caps-Lock Crash](#caps-lock-crash)
- [Suspend Loop](#suspend-loop)
- [Touchpad Suspend](#touchpad-suspend)
- [Touchpad Temporary Freezes](#touchpad-temporary-freezes)
- [Touchscreen & Firefox](#touchscreen--firefox)
- [Power Management](#power-management)
- [Touchpad](#touchpad-1)
- ["Capitaine" Cursors](#capitaine-cursors)

### 1.2.2. Touchpad

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

### 1.2.3. WIP

#### 1.2.3.1. Razer Core

##### 1.2.3.1.1. Auth

bolt is installed

$ boltctl list
get <uuid>
$ boltctl enroll <uuid> 

activating with "nouveau" crashes the system.

Trial on error:

- installing nvidia-driver-396
- when insert thundderbolt, nouveau is loaded?
- sudo rmmod nouveau

##### 1.2.3.1.2. bumblebee

$ sudo apt-get install bumblebee bumblebee-nvidia primus linux-headers-generic

PKCS#7 signature not signed wth a trusted key

sudo apt install mesa-utils

sudo apt-get install nvidia-driver-396

tlp suspend // see arch setup

https://github.com/Bumblebee-Project/Bumblebee/issues/951

### 1.2.4. Tweaks

#### 1.2.4.1. Dual Boot Antergos

"update-grub" add only /boot/intel-ucode.img to initrd.
(Maybe) a hack, but works well on my system.

```shell
patch /etc/grub.d/30_os-prober etc/grub.d/os-prober.patch
```

#### 1.2.4.2. Grub

WIP // Razer Grub Theme for RBS 4k

```shell
sudo cp -r themes/grub /boot/grub/themes/razer
sudo cp etc/default/grub /etc/default/grub
sudo update-grub
```

#### 1.2.4.3. Plymouth

WIP // Razer Plymouth Theme

```shell
sudo cp -r themes/plymouth /usr/share/plymouth/themes/razer
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/razer/razer.plymouth 90
sudo update-alternatives --config default.plymouth
sudo update-initramfs -u
```

#### 1.2.4.4. Gnome Theme

My current favorite :)

```shell
apt install numix-gtk-theme numix-icon-theme gnome-icon-theme
```

- Theme Application (Tweaks, Theme): "Numix" (✓)
- Theme Icons (Tweaks, Theme): "Yaru" (✓)
- Theme Sound (Tweaks, Theme): "Yaru" (✓)

#### 1.2.4.5. Steam Interface

Change Steam interface enlargement based on monitor size:

- Settings, Interface, Enlarge text and icons based on monitor size (✓)

