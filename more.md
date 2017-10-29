# More RBS Linux settings

## Ubuntu Gnome tuning

_Has nothing todo with the Razer, but ... :)_

```shell
$ sudo apt install unity-tweak-toolning

```

### Install "Arc Darker" and "Paper" Theme & Icons

The arc-icon-theme needs some additional icons:
```shell
$ sudo add-apt-repository ppa:noobslab/themes
$ sudo add-apt-repository ppa:snwh/pulp
$ sudo apt-get update
$ sudo apt install breeze-cursor-theme arc-theme arc-icon-theme adwaita-icon-theme moka-icon-theme paper-icon-theme paper-gtk-theme breeze-cursor-theme
```
Open Unity Tweak Tool:
* "arc-darker" theme & "paper" icons
* Select "Breeze_cursor" with Unity Tweaks.

Reference: http://www.noobslab.com/2017/01/arc-theme-light-dark-versions-and-arc.html

### Fonts

* Install clear-sans font (manually): https://01.org/clear-sans/downloads
* Install Cantarell font:
```shell
$ sudo apt install fonts-cantarell
```

Unity Tweak Tool:
* Text scaling factor: 1
* Default: Clear Sans Regular: 12
* Monospace: Monospace Regular: 11
* Document: Clear Sans Regular: 12
* Title: Clear Sans Bold: 11


### Keyboard Colors

Install razerutils and polychromatic tools:
```shell
$ sudo add-apt-repository ppa:terrz/razerutils
$ sudo add-apt-repository ppa:lah7/polychromatic
$ sudo apt update
$ sudo apt install python3-razer razer-kernel-modules-dkms razer-daemon razer-doc polychromatic
```

Reference: https://github.com/lah7/polychromatic

But after suspend, the settings are lost:
* https://github.com/openrazer/openrazer/issues/342
(Gnome, Wayland)

#### Gnome Indicator

KStatusNotifierItem/AppIndicator needed for Polychromatic tray icon in Wayland:
* https://extensions.gnome.org/extension/615/appindicator-support/

## Arch Gnome Theme

### Appeareance

* GTK+ Theme: Arc-Darker
* Icons: Numix-Square
* Cursor: Capitaine
* Shell theme: Paper
