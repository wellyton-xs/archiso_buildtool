#!/usr/bin/env bash

set -e

print(){
	printf '%s\n' "$1"
}

download_latest(){
    curl https://raw.githubusercontent.com/wellyton-xs/archiso_installer/refs/heads/main/install.sh -o "$1"
}

check-updates(){
    print "checking for updates"
    download_latest /tmp/install.sh
    diff install.sh /tmp/install.sh
    if [["$?" == 1]]; then
	download_latest .
    elif [["$?" == 0]]; then
	print "everything is up to date! have a good installation"
    fi
}

check-updates

EFI="/dev/vda1"
SWAP="/dev/vda2"
ROOT="/dev/vda3"

read -p "type your keyboard" KEYBOARD
read -p "choose system language enconding" LANGUAGE
read -p "choose your zone" ZONEINFO
read -p "set root password" ROOTPASSWD

print "setting keyboard"
loadkeys "$KEYBOARD"

print "getting platform size"
cat /sys/firmware/efi/fw_platform_size

print "please wait 5s and create your partitions:"
sleep 5
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
pacstrap -K /mnt base linux linux-firmware grub efibootmgr

print "generate fstab"
genfstab -U /mnt >> /mnt/etc/fstab

print "join into system with arch-chroot"
arch-chroot /mnt /bin/bash <<EOF
printf  "%s\n" "set zoneinfo to localtime file"
ln -sf $ZONEINFO /etc/localtime
hwclock --systohc

printf "%s\n" "creating locale.gen"
#sed -i '/^#en_US.UTF-8/s/^#//' /etc/locale.gen
sed -i "/^#$ENCODING/s/^#//" /etc/locale.gen
locale-gen

printf "%s\n" "generate locale.conf"
echo "LANG=$ENCODING" > /etc/locale.conf

printf "%s\n" "setting up keyboard"
echo "KEYMAP=$KEYBOARD" > /etc/vconsole.conf

printf "%s\n" "create user"
echo "$HOSTNAME" > /etc/hostname

printf "%s\n" "running mkinitcpio"
mkinitcpio -P

printf "%s\n" "choose your password"
echo "root:$ROOTPASSWD" | chpasswd

printf "%s\n" "installing bootloader"
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

printf "%s\n" "installation complete!"

EOF
