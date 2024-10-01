#!/usr/bin/env bash

######## CABEÇALHO ########
# AUTHOR: welly <wellyton.offcer@gmail.com>
# NAME: mkiso.sh
# USE: automatizar o build de uma iso com archiso
# HOW TO: you need to have a predefined directory structure:
#				 directories: build, iso, profiles, repo, work
# 				 just run the script specifying the profile you want to compile
#				 example: mkiso <profile>

# VARS

profile="./profile"
workdir="./work"
outdir="./iso"

# FUNC

mkiso(){
    mkarchiso -v -w "$workdir" -o "$outdir" "$profile"
}

verify_profile(){
    if [ -z "$profile" ]; then
	printf '%s\n' "profile needs to exist"
	exit 1
    fi
}

verify_dir(){
    if [ -z "$1" ]; then
	printf '%s\n' "this folder: $1 need to exist"
	exit 1
    fi
}

verify_root(){
    if [ ! "$(id -u)" == 0 ]; then
	printf '%s\n' "you need to be root to run this script" 
	exit 1
    fi
}

clean(){
    rm -rf "${workdir:?}"/*
}

verify_and_clean(){
    if [ "$(ls -A $workdir)" ]; then
	printf '%s\n' "directory not empty, cleaning up..."
	clean
    fi
}

# VERIFY ROOT

verify_root

# VERIFY IF DIRECTORIES EXISTS

verify_profile
verify_dir "$workdir"
verify_dir "$outdir"

# VERIFY AND CLEAN WORK DIR

verify_and_clean

# INIT BUILD

mkiso

# CLEANING WORKDIR AFTER BUILD

printf '%s\n' "cleaning workdir"
clean
