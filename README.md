# archiso buildtool

this project is a set of tools that can be used to build
a custom archlinux iso and are used to build Tortoise distro

# building iso:

first you create the fundamental directories: iso, work.

paste in terminal:

	mkdir iso work

then run the build script:

	sudo ./mkiso.sh

if you get erros make sure that the script have correct permissions

use this command to give execution permission:

	chmod +x mkiso.sh

After the execution is complete you will have an ISO file fresh
out of the oven.