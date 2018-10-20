# Razer Blade Stealth Linux & Ubuntu 18.10

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) Linux ([Ubuntu](#ubuntu-1810).
Contact me at twitter [@rolandguelle](https://twitter.com/rolandguelle) for questions or open an issue.

<!-- TOC -->

- [Razer Blade Stealth Linux & Ubuntu 18.10](#razer-blade-stealth-linux--ubuntu-1810)
    - [Installation](#installation)
    - [Issues](#issues)
        - [Suspend Loop](#suspend-loop)
            - [Grub Kernel Parameter](#grub-kernel-parameter)
        - [Caps-Lock Crash](#caps-lock-crash)
            - [Disable Capslocks](#disable-capslocks)
        - [Touchscreen & Firefox](#touchscreen--firefox)
            - [XINPUT2](#xinput2)
        - [Gestures with Libinput](#gestures-with-libinput)
        - [Dual Boot Antergos](#dual-boot-antergos)
    - [Tweaks](#tweaks)
        - ["Capitaine" Cursors](#capitaine-cursors)
        - [Grub Theme](#grub-theme)
        - [Plymouth Theme](#plymouth-theme)

<!-- /TOC -->

## Installation

- 18.04 -> 18.10 update works without issues (Wayland & libinput touchpad driver)
- Fresh minimal installation, include 3rd party

## Issues

### Suspend Loop

After resume, the system loops back in suspend.
The system send an ACPI event where the [kernel defaults](https://patchwork.kernel.org/patch/9512307/) are different.

#### Grub Kernel Parameter

Change kernel defaults:

```shell
sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="button.lid_init_state=open"
```

Update grub

```shell
sudo update-grub
```

### Caps-Lock Crash

The RBS crashes ~~randomly~~ mostly if you hit "Caps Lock", causes by the build-in driver.

#### Disable Capslocks

Modify /etc/default/keyboard, replacing capslocks by a second ctrl:

```shell
sudo nano /etc/default/keyboard
XKBOPTIONS="ctrl:nocaps"
```

### Touchscreen & Firefox

Firefox doesn't seem to care about the touchscreen at all.

#### XINPUT2

Tell Firefox to use xinput2

```shell
sudo nano /etc/environment
MOZ_USE_XINPUT2=1
```

Logout - Login.

### Gestures with Libinput

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

### Dual Boot Antergos

"update-grub" add only /boot/intel-ucode.img to initrd.
(Maybe) a hack, but works well on my system.

```shell
patch /etc/grub.d/30_os-prober etc/grub.d/os-prober.patch
```

## Tweaks

### "Capitaine" Cursors

- Install ["Capitaine" Cursors](https://github.com/keeferrourke/capitaine-cursors)

```shell
sudo add-apt-repository ppa:dyatlov-igor/la-capitaine
sudo apt update
sudo apt install la-capitaine-cursor-theme
```

- Select via tweaks tool, Appearance, Themes, Cursor

### Grub Theme

Razer Grub Theme for RBS 4k

```shell
sudo cp -r themes/grub /boot/grub/themes/razer
sudo cp etc/default/grub /etc/default/grub
sudo update-grub
```

### Plymouth Theme

Razer Plymouth Theme

```shell
sudo cp -r themes/plymouth /usr/share/plymouth/themes/razer
sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/razer/razer.plymouth 90
sudo update-alternatives --config default.plymouth
sudo update-initramfs -u
```
