#!/bin/bash
#EXECUTE THIS SCRIPT IN HOME/{USER} DIRECCTORY#
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'

#installing necessary tools
echo -e "${YELLOW}===> installing build-essential and other necessary tools..."
sudo apt-get install build-essential vim git cscope libncurses-dev libssl-dev bison flex git-email
if [ $? -ne 0 ]
then
	echo -e "${RED}===> failed :( please re-run"
	exit 1
	else
	echo -e "${GREEN}===> installed successfully"
fi

#install mcelog
echo -e "${YELLOW}===> attempting mcelog installation..."
echo -e "${YELLOW}===> fetching mcelog from repo..."
git clone git://git.kernel.org/pub/scm/utils/cpu/mce/mcelog.git
if [ $? -ne 0 ]
then
	echo -e "${RED}===> fetch failed :( please re-run"
	exit 1
	else
	echo -e "${GREEN}===> fetched successfully"
fi


echo -e "${YELLOW}===> building and installing mcelog"
cd mcelog
make
sudo make install

if [ $? -ne 0 ]
then
	echo -e "${RED}===> some error occured"
	exit 1
else
	#copy to systemd
	sudo cp mcelog/mcelog.service /usr/lib/systemd/system
	if [ $? -eq 0 ]
	then
		echo -e "${RED}===> error copying"
		exit 1
	else
		echo -e "${GREEN}===> copied mcelog.service to /usr/lib/systemd/system"
	fi
	
	#enable service
	sudo systemctl enable mcelog.service
	if [ $? -eq 0 ]
	then
		echo -e "${GREEN}===> successfuly started mcelog service"
		echo -e "${GREEN}===> to verify run 'mcelog --client' or 'systemctl status mcelog.service'"
		echo -e "${YELLOW}===> removing mcelog directory..."
		cd ../
		rm -rf mcelog
	else
		echo -e "${RED}===> error occured in enabling service"
		exit 1
	fi
fi

echo -e "${YELLOW}===> installing required packages from apt"
sudo apt-get install gcc make bash binutils flex bison pahole util-linux kmod e2fsprogs jfsutils reiserfsprogs xfsprogs squashfs-tools btrfs-progs pcmciautils quota pptpd nfs-common procps grub iptables openssl libcrypto++8 libcrypto++-dev bc cpio tar libelf-dev
echo -e "%${GREEN}===> installation successful .bye. "
