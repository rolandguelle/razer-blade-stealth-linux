# 1. Razer Blade Stealth Linux & Ubuntu 18.04

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) Ubuntu Linux 18.04.

<!-- TOC -->

- [1. Razer Blade Stealth Linux & Ubuntu 18.04](#1-razer-blade-stealth-linux--ubuntu-1804)
- [2. Update](#2-update)
- [3. Install](#3-install)
- [4. Issues](#4-issues)
  - [4.1. Suspend Loop](#41-suspend-loop)
    - [4.1.1. Grub Kernel Parameter](#411-grub-kernel-parameter)
  - [4.2. Caps-Lock Crash](#42-caps-lock-crash)
    - [4.2.1. Disable Capslocks](#421-disable-capslocks)
    - [4.2.2. X11: Disable Built-In Keyboard Driver](#422-x11-disable-built-in-keyboard-driver)
  - [4.3. Touchpad Temporary Freezes](#43-touchpad-temporary-freezes)
  - [4.4. Touchpad Suspend](#44-touchpad-suspend)
    - [4.4.1. Libinput-gestures](#441-libinput-gestures)
  - [4.5. Touchscreen & Firefox](#45-touchscreen--firefox)
    - [4.5.1. XINPUT2](#451-xinput2)
- [5. Tweaks](#5-tweaks)
  - [5.1. Power Management](#51-power-management)
  - [5.2. Touchpad tap & click](#52-touchpad-tap--click)
  - [5.3. "Capitaine" Cursors](#53-capitaine-cursors)
  - [5.4. Dual Boot Antergos](#54-dual-boot-antergos)
  - [5.5. Grub Razer Theme](#55-grub-razer-theme)
  - [5.6. Plymouth Razer Theme](#56-plymouth-razer-theme)
  - [5.7. Gnome Theme](#57-gnome-theme)
  - [5.8. Steam Interface](#58-steam-interface)

<!-- /TOC -->

# 2. Update

Udating my 17.10 installation works without issues (X11 & Synaptics touchpad driver).

# 3. Install

Running the live session and starting the installation ends with **segfaults**.

- Select "Installation" while boot (Grub / USB Stick) works.
- Minimal installation, include 3rd party
- After installation, update and install Intel Microcode

```shell
sudo apt install intel-microcode
```

# 4. Issues

These issues still exist and neeed fixes.

## 4.1. Suspend Loop

After resume, the system loops back in suspend.
The system send an ACPI event where the [kernel defaults](https://patchwork.kernel.org/patch/9512307/) are different.

### 4.1.1. Grub Kernel Parameter

Change kernel defaults:

```shell
sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="button.lid_init_state=open"
```

Update grub

```shell
sudo update-grub
```

## 4.2. Caps-Lock Crash

The RBS crashes ~~randomly~~ mostly if you hit "Caps Lock", causes by the build-in driver.

### 4.2.1. Disable Capslocks

Modify /etc/default/keyboard, replacing capslocks by a second ctrl:

```shell
sudo nano /etc/default/keyboard
XKBOPTIONS="ctrl:nocaps"
```

### 4.2.2. X11: Disable Built-In Keyboard Driver

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

## 4.3. Touchpad Temporary Freezes

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

## 4.4. Touchpad Suspend

Touchpad fails resuming from suspend with:

```shell
rmi4_physical rmi4-00: rmi_driver_reset_handler: Failed to read current IRQ mask.
dpm_run_callback(): i2c_hid_resume+0x0/0x120 [i2c_hid] returns -11
PM: Device i2c-15320205:00 failed to resume async: error -11
```

Temporary fix:

```shell
sudo rmmod i2c_hid && sudo modprobe i2c_hid
```

### 4.4.1. Libinput-gestures

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

## 4.5. Touchscreen & Firefox

Firefox doesn't seem to care about the touchscreen at all.

### 4.5.1. XINPUT2

Tell Firefox to use xinput2

```shell
sudo nano /etc/environment
MOZ_USE_XINPUT2=1
```

Logout - Login.

# 5. Tweaks

## 5.1. Power Management

TLP is an advanced power management tool for Linux that tries to apply tweaks for you automatically, depending on your Linux distribution and hardware.

```shell
sudo apt-get install tlp tlp-rdw
sudo systemctl enable tlp
```

## 5.2. Touchpad tap & click

macOS touchpad feeling.

```shell
sudo apt install gnome-tweak-tool
```

- Keyboard & Mouse
- Click Method: Fingers
  
## 5.3. "Capitaine" Cursors

- Install ["Capitaine" Cursors](https://github.com/keeferrourke/capitaine-cursors)
- Select via tweaks tool, Appearance, Themes, Cursor

## 5.4. Dual Boot Antergos

"update-grub" add only /boot/intel-ucode.img to initrd.
(Maybe) a hack, but works well on my system.

```shell
patch /etc/grub.d/30_os-prober etc/grub.d/os-prober.patch
```

## 5.5. Grub Razer Theme

```shell
sudo cp -r themes/grub /boot/grub/themes/razer
sudo cp etc/default/grub /etc/default/grub
sudo update-grub
```

## 5.6. Plymouth Razer Theme

```shell
sudo cp -r themes/plymouth /usr/share/plymouth/themes/razer
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/razer/razer.plymouth 90
sudo update-alternatives --config default.plymouth
sudo update-initramfs -u
```

## 5.7. Gnome Theme

My current favorite :)

```shell
apt install numix-gtk-theme numix-icon-theme gnome-icon-theme
```

- Theme Application (Tweaks, Theme): "Numix" (✓)
- Theme Icons (Tweaks, Theme): "Yaru" (✓)
- Theme Sound (Tweaks, Theme): "Yaru" (✓)

## 5.8. Steam Interface

Change Steam interface enlargement based on monitor size:

- Settings, Interface, Enlarge text and icons based on monitor size