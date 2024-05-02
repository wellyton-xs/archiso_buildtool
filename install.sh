#!/usr/bin/env bash

source imports.sh

# test if modules functions are loaded
# hello

# set keyboard
read keymap
setkeymap "$keymap"

# set timezone
read timezone
setTimezone "$timezone"

# create partitions

#cfdisk

# format partitions
chooseFilesystem
# mount partitions

# bootstrap packages

# install drivers and microcode

# gen fstab

# chroot

# update timezone

# configure locale-gen

# network

# root password

# add user account

# install a bootloader

# finish