## Grub

/etc/default/grub

sudo update-grub

## Plymouth

sudo update-alternatives --install /usr/share/plymouth/themes/default.plymouth default.plymouth /usr/share/plymouth/themes/razer/razer.plymouth 90

sudo update-alternatives --config default.plymouth

sudo update-initramfs -u
