# 1. Razer Blade Stealth Linux & Elementary OS

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) with other Elementary OS.

<!-- TOC -->

- [1. Razer Blade Stealth Linux & Elementary OS](#1-razer-blade-stealth-linux--elementary-os)
- [2. Issues](#2-issues)
  - [2.1. Live USB Boot](#21-live-usb-boot)
  - [2.2. Screen flickering](#22-screen-flickering)

<!-- /TOC -->

# 2. Issues

## 2.1. Live USB Boot

- While booting from USB stick, choose direct the "Install Mode" (Option 2)
- First boot after installing, add kernel parameter while booting (grub, press "e"):

```shell
intel_idle.max_cstate=4
```

## 2.2. Screen flickering

Add this parameter permantly:

```shell
sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="button.lid_init_state=open intel_idle.max_cstate=4"
```

There are maybe other issues with this distros, check [Ubuntu 18.04](ubuntu-18-04.md).