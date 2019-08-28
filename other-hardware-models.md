# 1. Other Models: Razer Blade (Stealth) Linux

Issues with othe Razer Blade (Stealth) models.

## 1.1. Razer Blade Stealth Late 2017

### 1.1.1. Screen flickering

Workaround, [kernel parameter](https://wiki.archlinux.org/index.php/Razer_Blade#Late-2017_version_Razer_Blade_Stealth):

```shell
intel_idle.max_cstate=4
```

### 1.1.2. External monitor randomly going blank

- Workaround: Change output channel
- "HDMI / DisplayPort - Built in Audio" (or connect headphones to the stereo jack)
- See: [Issue 18](https://github.com/rolandguelle/razer-blade-stealth-linux/issues/18)

### 1.1.3. Touchpad deadzones

- Kernel 4.17.1 solve the issue, see (#19)
- See [Issue 19](https://github.com/rolandguelle/razer-blade-stealth-linux/issues/19).

### 1.1.4. Touchpad issues

See [Issue 7](https://github.com/rolandguelle/razer-blade-stealth-linux/issues/7#issuecomment-442965336)

```shell
nano /lib/udev/hwdb.d/61-evdev.hwdb
# Razer Blade Stealth (override)
evdev:name:1A586757:00 06CB:8323 Touchpad:dmi:*svnRazer:pnBladeStealth:*
 EVDEV_ABS_00=::12:8
 EVDEV_ABS_01=::11:8
 EVDEV_ABS_35=::12:8
 EVDEV_ABS_36=::11:8
```

Enable it

```shell
systemd-hwdb update
udevadm trigger /dev/input/event11
```

- https://mikepalmer.net/razer-blade-stealth-libinput-touchpad-issues/
- https://github.com/systemd/systemd/pull/9746

## 1.2. Razer Blade Stealth Early 2018

### 1.2.1. Screen flickering

Workaround, kernel parameter:

```shell
intel_idle.max_cstate=4
```

More: [Issue 7](https://github.com/rolandguelle/razer-blade-stealth-linux/issues/7)

## 1.3. Razer Blade Stealt 2019

Ubuntu 18.04 LTS installed just fine without any additional work (Thanks @durzo).