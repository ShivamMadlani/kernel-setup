#!bin/bash
#EXECUTE THIS SCRIPT IN HOME/{USER} DIRECCTORY#

#install mcelog
git clone git://git.kernel.org/pub/scm/utils/cpu/mce/mcelog.git
cd mcelog
make
sudo make install

if [$? -ne 0]
then
	echo "some error occured"
	exit 1
else
	#copy to systemd
	cp mcelog.service /usr/lib/systemd/system
	if [$? -e 0]
	then
		echo "error copying"
		exit 1
	fi
	
	#enable service
	sudo systemctl enable mcelog.service
	if [$? -e 0]
	then
		echo "successfuly started mcelog service"
		echo "to verify run `mcelog --client` or `systemctl status mcelog.service`"
		echo "removing mcelog directory..."
		cd ../
		rm -rf mcelog
	else
		echo "error occured in enabling service"
		exit 1
	fi
fi

echo "installing required packages from apt"

sudo apt-get install build-essential vim git cscope libncurses-dev libssl-dev bison flex git-email
sudo apt-get install gcc make bash binutils flex bison pahole util-linux kmod e2fsprogs jfsutils reiserfsprogs xfsprogs squashfs-tools btrfs-progs pcmciautils quota pptpd nfs-common procps grub iptables openssl libcrypto++8 libcrypto++-dev bc cpio tar

