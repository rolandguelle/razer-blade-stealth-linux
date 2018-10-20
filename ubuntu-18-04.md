# 1. Razer Blade Stealth Linux & Ubuntu 18.04

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) Ubuntu Linux 18.04.

<!-- TOC -->

- [1. Razer Blade Stealth Linux & Ubuntu 18.04](#1-razer-blade-stealth-linux--ubuntu-1804)
- [2. Issues](#2-issues)
  - [2.1. Installation](#21-installation)
  - [2.2. Suspend Loop](#22-suspend-loop)
    - [2.2.1. Grub Kernel Parameter](#221-grub-kernel-parameter)
  - [2.3. Caps-Lock Crash](#23-caps-lock-crash)
    - [2.3.1. Disable Capslocks](#231-disable-capslocks)
    - [2.3.2. X11: Disable Built-In Keyboard Driver](#232-x11-disable-built-in-keyboard-driver)
  - [2.4. Touchpad Temporary Freezes](#24-touchpad-temporary-freezes)
  - [2.5. Touchpad Suspend](#25-touchpad-suspend)
    - [2.5.1. Libinput-gestures](#251-libinput-gestures)
  - [2.6. Touchscreen & Firefox](#26-touchscreen--firefox)
    - [2.6.1. XINPUT2](#261-xinput2)
- [3. Tweaks](#3-tweaks)
  - [3.1. Power Management](#31-power-management)
  - [3.2. Touchpad tap & click](#32-touchpad-tap--click)
  - [3.3. "Capitaine" Cursors](#33-capitaine-cursors)
  - [3.4. Dual Boot Antergos](#34-dual-boot-antergos)
  - [3.5. Grub Razer Theme](#35-grub-razer-theme)
  - [3.6. Plymouth Razer Theme](#36-plymouth-razer-theme)
  - [3.7. Gnome Theme](#37-gnome-theme)
  - [3.8. Steam Interface](#38-steam-interface)

<!-- /TOC -->

# 2. Issues

## 2.1. Installation

Running the live session and starting the installation ends with **segfaults**.

- Select "Installation" while boot (Grub / USB Stick) works.
- Minimal installation, include 3rd party
- After installation, update and install Intel Microcode

```shell
sudo apt install intel-microcode
```

## 2.2. Suspend Loop

After resume, the system loops back in suspend.
The system send an ACPI event where the [kernel defaults](https://patchwork.kernel.org/patch/9512307/) are different.

### 2.2.1. Grub Kernel Parameter

Change kernel defaults:

```shell
sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="button.lid_init_state=open"
```

Update grub

```shell
sudo update-grub
```

## 2.3. Caps-Lock Crash

The RBS crashes ~~randomly~~ mostly if you hit "Caps Lock", causes by the build-in driver.

### 2.3.1. Disable Capslocks

Modify /etc/default/keyboard, replacing capslocks by a second ctrl:

```shell
sudo nano /etc/default/keyboard
XKBOPTIONS="ctrl:nocaps"
```

### 2.3.2. X11: Disable Built-In Keyboard Driver

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

## 2.4. Touchpad Temporary Freezes

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

## 2.5. Touchpad Suspend

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

### 2.5.1. Libinput-gestures

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

## 2.6. Touchscreen & Firefox

Firefox doesn't seem to care about the touchscreen at all.

### 2.6.1. XINPUT2

Tell Firefox to use xinput2

```shell
sudo nano /etc/environment
MOZ_USE_XINPUT2=1
```

Logout - Login.

# 3. Tweaks

## 3.1. Power Management

TLP is an advanced power management tool for Linux that tries to apply tweaks for you automatically, depending on your Linux distribution and hardware.

```shell
sudo apt-get install tlp tlp-rdw
sudo systemctl enable tlp
```

## 3.2. Touchpad tap & click

macOS touchpad feeling.

```shell
sudo apt install gnome-tweak-tool
```

- Keyboard & Mouse
- Click Method: Fingers
  
## 3.3. "Capitaine" Cursors

- Install ["Capitaine" Cursors](https://github.com/keeferrourke/capitaine-cursors)
- Select via tweaks tool, Appearance, Themes, Cursor

## 3.4. Dual Boot Antergos

"update-grub" add only /boot/intel-ucode.img to initrd.
(Maybe) a hack, but works well on my system.

```shell
patch /etc/grub.d/30_os-prober etc/grub.d/os-prober.patch
```

## 3.5. Grub Razer Theme

```shell
sudo cp -r themes/grub /boot/grub/themes/razer
sudo cp etc/default/grub /etc/default/grub
sudo update-grub
```

## 3.6. Plymouth Razer Theme

```shell
sudo cp -r themes/plymouth /usr/share/plymouth/themes/razer
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/razer/razer.plymouth 90
sudo update-alternatives --config default.plymouth
sudo update-initramfs -u
```

## 3.7. Gnome Theme

My current favorite :)

```shell
apt install numix-gtk-theme numix-icon-theme gnome-icon-theme
```

- Theme Application (Tweaks, Theme): "Numix" (✓)
- Theme Icons (Tweaks, Theme): "Yaru" (✓)
- Theme Sound (Tweaks, Theme): "Yaru" (✓)

## 3.8. Steam Interface

Change Steam interface enlargement based on monitor size:

- Settings, Interface, Enlarge text and icons based on monitor size