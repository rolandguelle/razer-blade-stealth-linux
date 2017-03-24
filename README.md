# Razer Blade Stealth Linux

Razer Blade Stealth (late 2016) UHD Linux installation & configuration.

## Preparation

* Run all Bios updates at Windows
	* http://www.razersupport.com/gaming-systems/razer-blade-stealth/
	* Direct Link:
		* http://dl.razerzone.com/support/BladeStealthH2/BladeStealthUpdater_v1.0.5.3_BIOS6.05.exe.7z
		* http://dl.razerzone.com/support/BladeStealthH2/BladeStealthUpdater_v1.0.5.0.zip


## Arch Linux

### Antergos

* Disk resize & fresh install
* Antergos (Arch Linux, https://antergos.com/)
* most works like a charm

#### Suspend Loop

sudo nano /etc/default/grub
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet button.lid_init_state=open"
grub-mkconfig -o /boot/grub/grub.cfg
```

Reference: https://wiki.archlinux.org/index.php/razer#GRUB

### Laptop TLP Tools

Install tlp and tlp-rwd

```
sudo systemctl enable tlp
sudo systemctl enable tlp-sleep
```

Reference: https://wiki.archlinux.org/index.php/TLP

### Gestures

Install libinput-gestures via pacman

[Config](config/libinput-gestures.conf)

### Webcam

unsolved, like Ubuntu
 
## Ubuntu 16.10

* Disk resize & fresh install
* Settings -> Monitor -> Scale for menu and title bars: 2

### Suspend

Suspend loop issue:
* http://askubuntu.com/questions/849888/suspend-not-working-as-intended-on-razer-blade-stealth-running-xubuntu-16-04/849900

A grub kernel parameter solves the problem.

Configuration: /etc/default/grub
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet button.lid_init_state=open"
```

Update grub
```
sudo update-grub
```

Reference: https://wiki.archlinux.org/index.php/Razer#GRUB

### Keyboard Colors

Install razer utils and polychromatic tools:
```
sudo add-apt-repository ppa:terrz/razerutils
sudo apt update
sudo apt install python3-razer razer-kernel-modules-dkms razer-daemon razer-doc
sudo add-apt-repository ppa:lah7/polychromatic
sudo apt update
sudo apt install polychromatic
```

Reference: https://github.com/lah7/polychromatic

### Caps Lock Issue

The RBS crashes randomly if you hit "Caps Lock". The build-in driver causes the problem:
```
xinput list
```
If you get "AT Raw Set 2 keyboard", you have a problem if you hit _Caps Lock_.

[Config](etc/X11/xorg.conf.d/20-razer.conf)
```
Section "InputClass"
    Identifier      "Disable built-in keyboard"
    MatchIsKeyboard "on"
    MatchProduct    "AT Raw Set 2 keyboard"
    Option          "Ignore"    "true"
EndSection
```
Re'disable keyboard after suspend, [Script](etc/pm/sleep.d/20_razer):

```bash
#!/bin/sh
# http://askubuntu.com/questions/873626/crash-when-toggling-off-caps-lock

case $1 in
    resume|thaw)
	  xinput set-prop "AT Raw Set 2 keyboard" "Device Enabled" 0
    ;;
esac
```

Reference: http://askubuntu.com/questions/873626/crash-when-toggling-off-caps-lock

### Grafic Card

#### update linuxgraphics

The [uxa mode](https://wiki.archlinux.org/index.php/Razer#Graphics_Drivers) to avoid flickering isn't needed after updating the intel driver:
* https://01.org/linuxgraphics/downloads/update-tool


### wireless

Reference: https://wiki.archlinux.org/index.php/Razer#Killer_Wireless_Network_Adapter

### HDMI Output

The HDMI works when I boot with an external monitor, but not when plugging it into a running ubuntu :(

Swithing Ubuntu to the 4.10.4 kernel solves the problem:
```bash
sudo add-apt-repository -y ppa:teejee2008/ppa
sudo apt update
sudo apt install ukuu
```
Open ukuu and install new kernel.

Reference: https://www.linuxbabe.com/ubuntu/install-linux-kernel-4-10-ubuntu-16-04-ukuu

### Multiple monitors

Run an external non HDPI monitor above the internal HDPI display.

Actually, I run this [script](bin/extend.sh) manually.

TODO: automatic run this script

Reference: https://wiki.archlinux.org/index.php/HiDPI#Multiple_displays

### Webcam (unsolved)

Working only with 176x in cheese, or 640x480 in guvcview with 15/1 frames

Reference: https://wiki.archlinux.org/index.php/Razer#Webcam

### Theme tuning

_Has nothing todo with the Razer, but ... :)_

```
sudo apt install unity-tweak-tool
```

#### Install "Arc Darker" Theme & Icons

The arc-icon-theme needs some additional icons:
```
sudo add-apt-repository ppa:noobslab/themes
sudo apt install breeze-cursor-theme
sudo apt install arc-theme arc-icon-theme
sudo apt install adwaita-icon-theme
sudo apt install moka-icon-theme
```
Open Unity Tweak Tool: "arc-darker" theme & icons

Reference: http://www.noobslab.com/2017/01/arc-theme-light-dark-versions-and-arc.html

#### Fonts

* Install clear-sans font (manually): https://01.org/clear-sans/downloads
* Install Cantarell font:
```
sudo apt install fonts-cantarell
```

Unity Tweak Tool:
* Text scaling factor: 1
* Default: Clear Sans Regular: 11
* Monospace: Monospace Regular: 11
* Document: Cantarell Regular: 11
* Title: Clear Sans Regular: 10

#### Cursor

```
sudo apt install breeze-cursor-theme
```
Select "Breeze_cursor" with Unity Tweaks.

### Laptop TLP Tools

```
sudo apt-get install tlp tlp-rdw
sudo systemctl enable tlp
```

### msc

I get errors like:
```
mce: [Hardware Error]: CPU 3: Machine Check: 0 Bank 128 ...
```

msclog gives more information:
```
Processor 1 below trip temperature. Throttling disabled
Running trigger `unknown-error-trigger'
```

### Palm Detection

Disable touchpad while typing

[50-synaptics.conf](etc/X11/xorg.conf.d/50-synaptics.conf)


### Gestures

Install [Libinput-gestures](https://github.com/bulletmark/libinput-gestures):

```bash
sudo gpasswd -a $USER input
sudo apt-get install xdotool wmctrl
sudo apt-get install libinput-tools
git clone http://github.com/bulletmark/libinput-gestures
cd libinput-gestures
sudo ./libinput-gestures-setup install
echo "gesture swipe right     xdotool key ctrl+alt+Right" > .config/libinput-gestures.conf
echo "gesture swipe left     xdotool key ctrl+alt+Left" >> .config/libinput-gestures.conf
libinput-gestures-setup autostart
libinput-gestures-setup start
```

Reference: https://github.com/bulletmark/libinput-gestures