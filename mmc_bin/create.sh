#! /bin/bash
cp ../build/u-boot.bin .

# #delete all file expect u-boot.bin
shopt -s extglob
rm -rf !(u-boot.bin|create.sh)
shopt -u extglob

cat u-boot.bin >> u-boot_mmc.bin
# fill the temp to 256K
while ((filelen < 262144))
do
	echo -n -e "\x00" >> u-boot_mmc.bin
	filelen=`stat -c "%s" u-boot_mmc.bin`
done

dd if=u-boot.bin of=u-boot_8k.bin bs=1024 count=8 conv=sync


while ((filelen < 286720))
do
	cat u-boot_8k.bin >> u-boot_mmc.bin
	filelen=`stat -c "%s" u-boot_mmc.bin`
done

#delete all file expect u-boot_mmc.bin
shopt -s extglob
rm -rf !(u-boot_mmc.bin|create.sh)
shopt -u extglob
