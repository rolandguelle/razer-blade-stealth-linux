# 1. Other Models: Razer Blade (Stealth) Linux

Issues with othe Razer Blade (Stealth) models.

<!-- TOC depthFrom:2 -->

- [1. Razer Blade Stealth Late 2017](#1-razer-blade-stealth-late-2017)
  - [1.1. Screen flickering](#11-screen-flickering)
  - [1.2. External monitor randomly going blank](#12-external-monitor-randomly-going-blank)
  - [1.3. Touchpad deadzones](#13-touchpad-deadzones)
- [2. Razer Blade Stealth Early 2018](#2-razer-blade-stealth-early-2018)
  - [2.1. Screen flickering](#21-screen-flickering)

<!-- /TOC -->

## 1. Razer Blade Stealth Late 2017

### 1.1. Screen flickering

Workaround, [kernel parameter](https://wiki.archlinux.org/index.php/Razer_Blade#Late-2017_version_Razer_Blade_Stealth):

```shell
intel_idle.max_cstate=4
```

### 1.2. External monitor randomly going blank

- Workaround: Change output channel
- "HDMI / DisplayPort - Built in Audio" (or connect headphones to the stereo jack)
- See: [Issue 18](https://github.com/rolandguelle/razer-blade-stealth-linux/issues/18)

### 1.3. Touchpad deadzones

- Kernel 4.17.1 solve the issue, see (#19)
- See [Issue 19](https://github.com/rolandguelle/razer-blade-stealth-linux/issues/19).
  
## 2. Razer Blade Stealth Early 2018

### 2.1. Screen flickering

Workaround, kernel parameter:

```shell
intel_idle.max_cstate=4
```

More: [Issue 7](https://github.com/rolandguelle/razer-blade-stealth-linux/issues/7)
