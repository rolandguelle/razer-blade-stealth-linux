# Razer Blade Stealth Linux

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) Linux Ubuntu & Arch setup, including Razer Core with discrete NVIDIA GPU setup connected via thunderbolt.

**This page is available as [Github Page](https://rolandguelle.github.io/razer-blade-stealth-linux/)**

Contact me at twitter [@rolandguelle](https://twitter.com/rolandguelle) for questions or open an issue.

My current setup is Ubuntu 20.10 (Ubuntu, Gnome, Wayland).

- [Razer Blade Stealth Linux](#razer-blade-stealth-linux)
  - [Preparation](#preparation)
    - [Meltdown, Spectre & TPM Updates](#meltdown-spectre--tpm-updates)
    - [Disk Resize](#disk-resize)
  - [Guides](#guides)
    - [Ubuntu 20.10](#ubuntu-2010)
    - [Ubuntu 19.10](#ubuntu-1910)
    - [Ubuntu 19.04](#ubuntu-1904)
    - [Ubuntu 18.10](#ubuntu-1810)
    - [Ubuntu 18.04](#ubuntu-1804)
    - [Ubuntu 17.10](#ubuntu-1710)
    - [Arch (Antergos)](#arch-antergos)
    - [Elementary OS](#elementary-os)
    - [Other Hardware Models](#other-hardware-models)
  - [Credits](#credits)

## Preparation

- [BIOS updates](http://www.razersupport.com/gaming-systems/razer-blade-stealth/) via Windows 10
- Direct Links:
- [BladeStealthUpdater_v1.0.5.3_BIOS6.05.exe.7z](http://dl.razerzone.com/support/BladeStealthH2/BladeStealthUpdater_v1.0.5.3_BIOS6.05.exe.7z)
  - [BladeStealthUpdater_v1.0.5.0.zip](http://dl.razerzone.com/support/BladeStealthH2/BladeStealthUpdater_v1.0.5.0.zip)
- [Fix for INTEL-SA-00086 Intel Management Engine Critical Firmware Update](https://insider.razerzone.com/index.php?threads/fix-for-intel-sa-00086-intel-management-engine-critical-firmware-update.29116/)
  - [RazerUpdater_v1.0.6.2_ME-11.8.50.3425.exe.7z](http://razerdrivers.s3.amazonaws.com/drivers/RazerUpdater_v1.0.6.2_ME-11.8.50.3425.exe.7z)

### Meltdown, Spectre & TPM Updates

- [Razer Blade Stealth (2016) - Intel 7500U](http://drivers.razersupport.com//index.php?_m=downloads&_a=view&parentcategoryid=605&pcid=604&nav=0,350,604)
  - Meltdown and Spectre Vulnerabilities Updater - Razer BIOS customer updater (02 Apr 2018 06:44 PM)
  - Razer TPM Firmware Updater (13 Feb 2018 03:32 AM)

### Disk Resize

[Resize disk](https://www.howtogeek.com/101862/how-to-manage-partitions-on-windows-without-downloading-any-other-software/) via Windows 10

## Guides

### Ubuntu 20.10

[Ubuntu 20.10](ubuntu-20-10.md)

### Ubuntu 19.10

[Ubuntu 19.10](ubuntu-19-10.md)

### Ubuntu 19.04

[Ubuntu 19.04](ubuntu-19-04.md)

### Ubuntu 18.10

[Ubuntu 18.10](ubuntu-18-10.md)

### Ubuntu 18.04

[Ubuntu 18.04](ubuntu-18-04.md)

### Ubuntu 17.10

[Ubuntu 17.10](ubuntu-17-10.md)

### Arch (Antergos)

[Arch (Antergos)](arch-antergos.md)

### Elementary OS

[Elementary OS](elementary-os.md)

### Other Hardware Models

[Other Hardware Models](other-hardware-models.md)

## Credits

- References
  - https://wiki.archlinux.org/index.php/Razer
  - https://wayland.freedesktop.org/libinput/doc/latest/absolute_coordinate_ranges.html
  - https://github.com/systemd/systemd/pull/6730
  - https://wiki.archlinux.org/index.php/TLP
  - http://www.webupd8.org/2016/08/how-to-install-and-configure-bumblebee.html
  - https://github.com/bulletmark/libinput-gestures
  - http://askubuntu.com/questions/849888/suspend-not-working-as-intended-on-razer-blade-stealth-running-xubuntu-16-04/849900
  - http://askubuntu.com/questions/873626/crash-when-toggling-off-caps-lock
  - https://github.com/Bumblebee-Project/Bumblebee/wiki/Multi-monitor-setup
- Thanks
  - https://github.com/xlinbsd
  - https://github.com/tomsquest
  - https://github.com/ahmadnassri
  - https://github.com/lucaszanella
  - https://github.com/brendanrankin
  - https://github.com/benjob
  - https://github.com/emanuelet
