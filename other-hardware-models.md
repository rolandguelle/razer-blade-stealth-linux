# 1. Other Models: Razer Blade (Stealth) Linux

Issues with othe Razer Blade (Stealth) models.

<!-- TOC -->

- [1. Other Models: Razer Blade (Stealth) Linux](#1-other-models-razer-blade-stealth-linux)
- [2. Razer Blade Stealth Late 2017](#2-razer-blade-stealth-late-2017)
  - [2.1. Screen flickering](#21-screen-flickering)
  - [2.2. External monitor randomly going blank](#22-external-monitor-randomly-going-blank)
  - [2.3. Touchpad deadzones](#23-touchpad-deadzones)
- [3. Razer Blade Stealth Early 2018](#3-razer-blade-stealth-early-2018)
  - [3.1. Screen flickering](#31-screen-flickering)

<!-- /TOC -->

# 2. Razer Blade Stealth Late 2017

## 2.1. Screen flickering

Workaround, kernel parameter:

```shell
intel_idle.max_cstate=4
```

More: https://wiki.archlinux.org/index.php/Razer_Blade#Late-2017_version_Razer_Blade_Stealth

## 2.2. External monitor randomly going blank

- Workaround: Change output channel
- "HDMI / DisplayPort - Built in Audio" (or connect headphones to the stereo jack)
- See: https://github.com/rolandguelle/razer-blade-stealth-linux/issues/18

## 2.3. Touchpad deadzones

- Kernel 4.17.1 solve the issue, see (#19)
- See https://github.com/rolandguelle/razer-blade-stealth-linux/issues/19 and [Touchpad](#touchpad).

# 3. Razer Blade Stealth Early 2018

## 3.1. Screen flickering

Workaround, kernel parameter:

```shell
intel_idle.max_cstate=4
```

More: https://github.com/rolandguelle/razer-blade-stealth-linux/issues/7
