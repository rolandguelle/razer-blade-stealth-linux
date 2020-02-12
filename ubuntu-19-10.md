# Razer Blade Stealth Linux & Ubuntu 19.10

**Razer Blade Stealth** (Early 2016, Intel 6500U, UHD / HiDPI) Ubuntu Linux 19.10, running Wayland / Gnome.

- [Razer Blade Stealth Linux & Ubuntu 19.10](#razer-blade-stealth-linux--ubuntu-1904)
  - [1. Issues](#1-issues)
    - [1.1. Suspend Loop](#11-suspend-loop)
    - [1.2. Caps-Lock Crash](#12-caps-lock-crash)
    - [1.3. Touchscreen & Firefox](#13-touchscreen--firefox)
    - [1.4. Dual Boot Antergos](#14-dual-boot-antergos)
  - [2. Tweaks](#2-tweaks)
    - [2.1. Power Management](#21-power-management)
    - [2.2. "Capitaine" Cursors](#22-%22capitaine%22-cursors)
    - [2.3. Grub Theme](#23-grub-theme)
    - [2.4. Gnome Theme](#24-gnome-theme)
    - [2.5. Steam Interface](#25-steam-interface)
  - [3. Razer Core](#3-razer-core)
    - [3.1. Thunderbolt](#31-thunderbolt)
    - [3.2. Nvidia Driver](#32-nvidia-driver)
    - [3.3. Bumblebee](#33-bumblebee)
    - [3.4. Steam](#34-steam)
    - [3.5 Laptop HDMI](#35-laptop-hdmi)
    - [3.6 Razer Core / GPU HDMI Out](#36-razer-core--gpu-hdmi-out)
  - [4. Unsolved Issues](#4-unsolved-issues)
    - [4.1. Keyboard Colors & Openrazer](#41-keyboard-colors--openrazer)
    - [4.2. Webcam](#42-webcam)

## 1. Issues

### 1.1. Suspend Loop

After resume, the system loops back in suspend.
The system send an ACPI event where the [kernel defaults](https://patchwork.kernel.org/patch/9512307/) are different.

Change kernel defaults:

```shell
sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="button.lid_init_state=open"
```

Update grub

```shell
sudo update-grub
```

### 1.2. Caps-Lock Crash

The RBS crashes ~~randomly~~ mostly if you hit "Caps Lock", causes by the build-in driver.

Modify /etc/default/keyboard, replacing capslocks by a second ctrl:

```shell
sudo nano /etc/default/keyboard
XKBOPTIONS="ctrl:nocaps"
```

### 1.3. Touchscreen & Firefox

Firefox doesn't seem to care about the touchscreen at all.
Tell Firefox to use XINPUT2:

```shell
sudo nano /etc/environment
MOZ_USE_XINPUT2=1
```

Logout - Login.

### 1.4. Dual Boot Antergos

"update-grub" add only /boot/intel-ucode.img to initrd.
(Maybe) a hack, but works well on my system.

```shell
sudo patch /etc/grub.d/30_os-prober etc/grub.d/os-prober.patch
```

## 2. Tweaks

Install Gnome Tweak Tool:

```shell
sudo apt install gnome-tweak-tool
```

### 2.1. Power Management

TLP is an advanced power management tool for Linux that tries to apply tweaks for you automatically, depending on your Linux distribution and hardware.

```shell
sudo apt-get install tlp tlp-rdw
sudo systemctl enable tlp
```

### 2.2. "Capitaine" Cursors

- Install ["Capitaine" Cursors](https://github.com/keeferrourke/capitaine-cursors)

```shell
git clone https://github.com/keeferrourke/capitaine-cursors.git
cp -pr capitaine-cursors/dist/ ~/.icons/capitaine-cursors
```

- Select via `gnome-tweaks-tool`: Appearance, Themes, Cursor

### 2.3. Grub Theme

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

### 2.4. Gnome Theme

```shell
sudo apt install gnome-shell-extensions
cp -r themes/RBS ~/.themes
```

- Logout - Login

- Tweaks
- Extensions
- User Themes: Yes

- Logout - Login
- Appearance
- Shell: RBS

- Interface: Liberation Sans Regular 11
- Document: Liberation Sans 11
- Monospace: Liberation Mono Regular 13

### 2.5. Steam Interface

Change Steam interface enlargement based on monitor size:

- Settings
- Interface
- Enlarge text and icons based on monitor size

## 3. Razer Core

### 3.1. Thunderbolt

- Connect _Razer Core_
- Authorization: Settings -> Devices -> Thunderbolt
- Razer Core: Authorized

Note: This [**2m** cable](https://www.amazon.de/CalDigit-Thunderbolt-3-Kabel-Zertifiziert-Typ-C-kompatibel/dp/B01N4MFG7J/) works without problems. I measured no (performance) differences compared with the included _very_ short cable (tested on Windows & Linux).

### 3.2. Nvidia Driver

Install nvidia-driver-390 driver:

```shell
sudo apt install nvidia-driver-390
```

### 3.3. Bumblebee

Install [Bumblebee / Primus](https://wiki.ubuntu.com/Bumblebee#Installation):

```shell
sudo apt-get install bumblebee bumblebee-nvidia primus linux-headers-generic
```

Change [bumblebee.conf](https://askubuntu.com/questions/1029169/bumblebee-doesnt-work-on-ubuntu-18-04/1042950#1042950)

```shell
sudo nano /etc/bumblebee/bumblebee.conf
LibraryPath=/usr/lib/x86_64-linux-gnu:/usr/lib/i386-linux-gnu
XorgModulePath=/usr/lib/x86_64-linux-gnu/nvidia/xorg,/usr/lib/xorg/modules,/usr/lib/xorg/modules/input
```

Change [/etc/environment](https://askubuntu.com/questions/1029169/bumblebee-doesnt-work-on-ubuntu-18-04/1042950#1042950)

```shell
sudo nano /etc/environment
__GLVND_DISALLOW_PATCHING=1
```

Create [Nvidia Blacklist](https://askubuntu.com/questions/1029169/bumblebee-doesnt-work-on-ubuntu-18-04/1042950#1042950):

```shell
sudo nano /etc/modprobe.d/blacklist-nvidia.conf
blacklist nvidia
blacklist nvidia-drm
blacklist nvidia-modeset
```

Patch [primusrun](https://github.com/Bumblebee-Project/Bumblebee/issues/951#issuecomment-379512353)

```shell
sudo mv /usr/bin/primusrun /usr/bin/primusrun.bak
sudo cp usr/bin/primusrun /usr/bin/
```

### 3.4. Steam

Install [Corefonts](https://www.holarse-linuxgaming.de/wiki/gta_v) for Steam Play:

```shell
sudo apt install ttf-mscorefonts-installer
```

Run steam games on your external GPU over Bumblebee/primusrun:

- Start steam
- Select your game
- Select "Properties"
- "Set Launch Options"
- Insert "primusrun %command%"

### 3.5 Laptop HDMI

The internal HDMI output works out-of-the box with `primusrun`. Tested on a 4k screen.

### 3.6 Razer Core / GPU HDMI Out

Not recommend setup...
Check if your monitor is detected:

```shell
nvidia-xconfig --query-gpu-info
```

- [Config Files](etc/bumblebee-ubuntu-19-04/).

Modify and create your monitor settings, stored in /etc/bumblebee/xorg.conf.external:

```shell
optirun /usr/bin/nvidia-settings -c :8
```

Change `Driver=nvidia` into `Driver=external` and restart bumblebee.

```shell
export DISPLAY=:8 LD_LIBRARY_PATH=/usr/lib/nvidia:$LD_LIBRARY_PATH
optirun steam
```

## 4. Unsolved Issues

### 4.1. Keyboard Colors & Openrazer

[Openrazer](https://openrazer.github.io/) lost settings after suspend.

[Issue](https://github.com/openrazer/openrazer/issues/342): Settings are lost after suspend (Gnome, Wayland).

### 4.2. Webcam

Working only with 176x in cheese, or 640x480 in guvcview with 15/1 frames.

[This](https://wiki.archlinux.org/index.php/Razer_Blade#Webcam) fix not really helped:

```shell
/etc/modprobe.d/uvcvideo.conf
options uvcvideo quirks=512
```

**Web Browser:**

"works almost perfectly (at least it's not all green or black and have decent fps) using Slack or Hangout"

- [Issue 21](https://github.com/rolandguelle/razer-blade-stealth-linux/issues/21)
- [Browser Test](https://www.cam-recorder.com/)
