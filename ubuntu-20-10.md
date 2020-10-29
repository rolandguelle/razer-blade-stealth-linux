# Razer Blade Stealth Linux & Ubuntu 20.10

**Razer Blade Stealth** (Early 2016, Intel 6500U, UHD / HiDPI) Ubuntu Linux 20.10, running Wayland & Gnome.

- [Razer Blade Stealth Linux & Ubuntu 20.10](#razer-blade-stealth-linux--ubuntu-2010)
  - [Issues](#issues)
    - [Suspend Loop](#suspend-loop)
    - [Caps-Lock Crash](#caps-lock-crash)
    - [Touchscreen & Firefox](#touchscreen--firefox)
  - [Tweaks](#tweaks)
    - ["Capitaine" Cursors](#capitaine-cursors)
    - [Grub Theme](#grub-theme)
  - [Razer Core](#razer-core)
    - [Thunderbolt](#thunderbolt)
    - [Nvidia Driver](#nvidia-driver)
    - [Bumblebee](#bumblebee)
    - [Steam](#steam)

## Issues

### Suspend Loop

After resume, the system loops back in suspend.
The system send an ACPI event where the [kernel defaults](https://patchwork.kernel.org/patch/9512307/) are different.

Change kernel defaults:

```shell
sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash button.lid_init_state=open"
```

Update grub

```shell
sudo update-grub
```

### Caps-Lock Crash

The RBS crashes ~~randomly~~ mostly if you hit "Caps Lock", causes by the build-in driver.

Modify /etc/default/keyboard, replacing capslocks by a second ctrl:

```shell
sudo nano /etc/default/keyboard
XKBOPTIONS="ctrl:nocaps"
```

### Touchscreen & Firefox

Firefox doesn't seem to care about the touchscreen at all.
Tell Firefox to use XINPUT2:

```shell
sudo nano /etc/environment
MOZ_USE_XINPUT2=1
MOZ_ENABLE_WAYLAND=1
```

Logout - Login.

## Tweaks

Install Gnome Tweak Tool:

```shell
sudo apt install gnome-tweak-tool
```

### "Capitaine" Cursors

- Install ["Capitaine" Cursors](https://github.com/keeferrourke/capitaine-cursors)

```shell
git clone https://github.com/keeferrourke/capitaine-cursors.git
cd capitaine-cursors
./build.sh -d xhd
cp -pr dist/dark ~/.icons/capitaine-cursors
```

- Select via `gnome-tweaks-tool`: Appearance, Themes, Cursor

### Grub Theme

Razer Grub Theme for RBS 4k.

```shell
sudo mkdir /boot/grub/themes
sudo cp -r themes/grub /boot/grub/themes/razer
```

Add Theme:

```shell
sudo nano /etc/default/grub
GRUB_GFXMODE="3840x2160-32"
GRUB_THEME="/boot/grub/themes/razer/theme.txt"
```

Update Grub

```shell
sudo update-grub
```

## Razer Core

### Thunderbolt

- Connect _Razer Core_
- Authorization: Settings -> Devices -> Thunderbolt
- Razer Core: Authorized

Note: This [**2m** cable](https://www.amazon.de/CalDigit-Thunderbolt-3-Kabel-Zertifiziert-Typ-C-kompatibel/dp/B01N4MFG7J/) works without problems. I measured no (performance) differences compared with the included _very_ short cable (tested on Windows & Linux).

### Nvidia Driver

Install nvidia-driver-390 driver:

```shell
sudo apt install nvidia-driver-390
```

### Bumblebee

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

Test:

```shell
primusrun glxinfo | grep OpenGL
```

### Steam

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

