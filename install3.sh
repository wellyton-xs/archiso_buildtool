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
pacstrap -K /mnt base linux linux-firmware grub

print "generate fstab"
genfstab -U /mnt >> /mnt/etc/fstab

print "join into system with arch-chroot"
arch-chroot /mnt /bin/bash <<EOF

printf  "%s\n" "set zoneinfo to localtime file"
ln -sf /usr/share/zoneinfo/America/Bahia /etc/localtime
hwclock --systohc

printf "%s\n" "creating locale.gen"
sed -i '/^#en_US.UTF-8/s/^#//' /etc/locale.gen
sed -i '/^#pt_BR.UTF-8/s/^#//' /etc/locale.gen
locale-gen

printf "%s\n" "generate locale.conf"
echo "LANG=pt_BR.UTF-8" > /etc/locale.conf

printf "%s\n" "setting up keyboard"
echo "KEYMAP=br-abnt2" > /etc/vconsole.conf

printf "%s\n" "create user"
echo "welly" > /etc/hostname

printf "%s\n" "running mkinitcpio"
mkinitcpio -P

printf "%s\n" "choose your password"
passwd

printf "%s\n" "installing bootloader"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

printf "%s\n" "installation complete!"

EOF
