#!/usr/bin/env bash

print(){
	printf '%s\n' "$1"
}

EFI="/dev/vda1"
SWAP="/dev/vda2"
ROOT="/dev/vda3"

# init installation

print "loading keyboard"
loadkeys br-abnt2

print "abrindo cfdisk para particionamento..."
sleep 5
cfdisk

print "formatando partições:"

print "formatando EFI"
mkfs.fat -F32 "$EFI"

print "formatando swap"
mkswap "$SWAP"

print "formatando root"
mkfs.ext4 "$ROOT"

print "montando partições"

swapon "$SWAP"
mount "$ROOT" /mnt
mkdir /mnt/boot
mount "$EFI" /mnt/boot

print "instalando sistema base"
pacstrap /mnt base linux linux-firmware micro vim intel-ucode

print "gerando fstab"
genfstab -U /mnt >> /mnt/etc/fstab

print "adentrando no sistema"
arch-chroot

print "ajustando relógio do systema"
ln -sf /usr/share/zoneinfo/America/Bahia /etc/localtime
hwclock --systohc

print "gerando locale-gen"
micro /etc/locale.gen
locale-gen

print "setando configuração do encoding do sistema"
echo "LANG=pt_BR.UTF-8" >> /etc/locale.conf

print "setando teclado"
echo "KEYMAP=br-abnt2" >> /etc/vconsole.conf

print "criando usuário"
echo "welly" >> /etc/hostname

mkinitcpio -P

print "gerando senha de usuário"
passwd

print "instalando pacotes importantes"
pacman -S grub efibootmgr neworkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-headers bluez bluez-utils cups xdg-utils xdg-user-dirs alsa-utils pulseaudio pulseaudio-bluetooth git reflector

print "instalando e configurando grub"
grub-install --target=x86_64-efi --efi-directory=boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
