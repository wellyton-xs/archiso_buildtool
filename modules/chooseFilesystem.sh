chooseFilesystem(){
    case "$1" in 

        btrfs)
            formatBtrfs
        ;;

        ext4)
            formatExt4
        ;;

    esac
}



