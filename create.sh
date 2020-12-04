#! /bin/bash
if [ ! -f "build/u-boot.bin" ]; then
	echo "file u-boot.bin is not exist" 
	exit 1
fi

rm u-boot_mmc.bin
cp build/u-boot.bin . 

# #delete all file expect u-boot.bin
# shopt -s extglob
# rm -rf mmc_bin/*
# shopt -u extglob

cat u-boot.bin >> u-boot_mmc.bin
# fill the temp to 256K
while ((filelen < 262144))
do
	echo -n -e "\x00" >> u-boot_mmc.bin
	filelen=`stat -c "%s" u-boot_mmc.bin`
done

while ((filelen < 286720))
do 
	echo $((filelen/8192))
	dd if=u-boot.bin of=u-boot_mmc.bin bs=1024 count=8 seek=$((filelen/1024)) conv=sync
	filelen=`stat -c "%s" u-boot_mmc.bin`
done

rm -rf u-boot.bin
