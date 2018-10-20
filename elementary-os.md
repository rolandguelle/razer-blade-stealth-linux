# Razer Blade Stealth Linux & Elementary OS

**Razer Blade Stealth** (late 2016, Intel 7500U, UHD / HiDPI) with other Elementary OS.

<!-- TOC depthFrom:2 -->

- [1. Issues](#1-issues)
  - [1.1. Live USB Boot](#11-live-usb-boot)
  - [1.2. Screen flickering](#12-screen-flickering)

<!-- /TOC -->

## 1. Issues

### 1.1. Live USB Boot

- While booting from USB stick, choose direct the "Install Mode" (Option 2)
- First boot after installing, add kernel parameter while booting (grub, press "e"):

```shell
intel_idle.max_cstate=4
```

### 1.2. Screen flickering

Add this parameter permantly:

```shell
sudo nano /etc/default/grub
GRUB_CMDLINE_LINUX_DEFAULT="button.lid_init_state=open intel_idle.max_cstate=4"
```

There are maybe other issues with this distros, check [Ubuntu 18.04](ubuntu-18-04.md).