# Razer Blade Stealth Linux & Ubuntu 19.04

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) Ubuntu Linux 19.04.

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

### 3.3. Bumblebee

Install [Bumblebee / Primus](https://wiki.ubuntu.com/Bumblebee#Installation):

```shell
sudo apt-get install bumblebee bumblebee-nvidia primus linux-headers-generic
```
