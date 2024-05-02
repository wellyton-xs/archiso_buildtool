formatExt4(){
    mkfs.ext4 "$1"
}

formatBtrfs(){
    mkfs.Btrfs "$1"
}

formatSwap(){
    mkswap "$1"
}

formatFat(){
    mkfs.fat -F 32 "$1"
}

ping(){
    echo "Im creating your filesystem and format your partitions!"
}