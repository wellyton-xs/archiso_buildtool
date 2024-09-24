#!/usr/bin/env bash

print(){
	printf '%s\n' "$1"
}

EFI="/dev/vda1"
SWAP="/dev/vda2"
ROOT="/dev/vda3"

print "define keyboard"
loadkeys br-abnt2

print "getting platform size"
cat /sys/firmware/efi/fw_platform_size

print "please wait 10s and create your partitions:"
sleep 10
cfdisk

print "formating root"
mkfs.ext4 "$ROOT"

print "formating swap"
mkswap "$SWAP"

print "formating EFI"
mkfs.fat -F 32 "$EFI"

print "mounting filesystem"

print "mount $ROOT to /mnt"
mount "$ROOT" /mnt

print "mount $EFI to /mnt/boot"
mount --mkdir "$EFI" /mnt/boot

print "mount $SWAP"
swapon "$SWAP"

print "installing base system packages"
pacstrap -K /mnt base linux linux-firmware

print "generate fstab"
genfstab -U /mnt >> /mnt/etc/fstab

print "join into system with arch-chroot"
arch-chroot /mnt /bin/bash <<EOF

print "set zoneinfo to localtime file"
ln -sf /usr/share/zoneinfo/America/Bahia /etc/localtime
hwclock --systohc

print "please, edit locale.gen and choose yours:"
nano /etc/locale.gen
locale-gen

print "generate locale.conf"
echo "LANG=pt_BR.UTF-8" >> /etc/locale.conf

print "setting up keyboard"
echo "KEYMAP=br-abnt2" >> /etc/vconsole.conf

print "create user"
echo "welly" >> /etc/hostname

print "running mkinitcpio"
mkinitcpio -P

print "choose your password"
passwd

print "installing bootloader"
grub-install --target=x86_64-efi --efi-directory=esp --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

print "installation complete!"

EOF
