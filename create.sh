#! /bin/bash
if [ ! -f "build/u-boot.bin" ]; then
	echo "file u-boot.bin is not exist"
	exit 1
fi
filehead=262144
filetotal=286720

rm u-boot_mmc.bin
cp build/u-boot.bin . 

cat u-boot.bin >> u-boot_mmc.bin
# fill the u-boot_mmc.bin to 256-KB
while ((filelen < filehead))
do
	echo -n -e "\x00" >> u-boot_mmc.bin
	filelen=`stat -c "%s" u-boot_mmc.bin`
done
# fill the u-boot_mmc.bin to 280-KB
while ((filelen < filetotal))
do 
	dd if=u-boot.bin of=u-boot_mmc.bin bs=1024 count=8 seek=$((filelen/1024)) conv=sync
	filelen=`stat -c "%s" u-boot_mmc.bin`
done

rm -rf u-boot.bin
