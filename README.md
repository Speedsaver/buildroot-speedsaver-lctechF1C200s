# External Lctech Pi F1C200s buildroot tree for Speedsaver #

This external tree contains the support for the Speedsaver use-case on the Lctech Pi F1C200s development board

## Required tools ##

Note if you are new to Buildroot, see prerequisites: https://buildroot.org/downloads/manual/manual.html#requirement-mandatory. Tested with vanilla Lubuntu 22.04.1 LTS, only the following was needed:
```
sudo apt install make gcc build-essential libncurses5-dev libssl-dev
```
Note libncurses5-dev is in place of ncurses5

If you wish to flash the onboard spi NAND you will also require the following tools:
* sunxi-tools built from source (see below)
* dfu-util

If you only require an SD card image, a sysimage-sdcard.img file is created in the images directory after building.

## How to build ##

This external tree will work with the latest buildroot version, which is 2023.02.3 at the time of this writing. Note tested working with kernel 5.4.254. Open a terminal and run the following commands

```
git clone https://github.com/Speedsaver/buildroot-speedsaver-lctechF1C200s.git
```
```
wget https://buildroot.org/downloads/buildroot-2023.02.3.tar.gz
```
```
tar -zxf buildroot-2023.02.3.tar.gz
```
```
cd buildroot-2023.02.3
```
```
for p in /path/to/buildroot-speedsaver-mangopi/buildroot-patches/*.patch; do patch -p1 < $p; done
```
```
make BR2_EXTERNAL=/path/to/buildroot-speedsaver-mangopi speedsaver_defconfig O=output/speedsaver
```
```
cd output/speedsaver
```
```
make
```

If you have a multi-cores machine, you can try passing -j n (where n is the number of cores +1 of your build machine) to the second make invocation to accelerate the build. For example, for a quad core build machine run make -j5. If debugging of the build process is necessary, run make (without -j n) to make any error messages easier to interpret.

## Flash SD card ##

```
cd images
```
Insert your Micro SD Card and run 
```
lsblk
```
You can identify your SD card by size compared to your other existing hard drives, e.g. sdX 4G for a 4 Gigabyte SD card. Note CAREFULLY the letter after "sd" corresponding to the SD card you just inserted. In the following example my SD card is designated sdc, because I have existing internal hard drives sda and sdb. Be VERY sure the following command has the correct /dev/sdX for your setup, the risk is you wipe all the data on one of your existing internal drives if you get it wrong.
```
sudo dd if=sysimage-nand.img of=/dev/sdc status=progress
```
```
sudo sync
```

## Flashing onboard SPI NAND ##

Dependency: libusb-1.0-0-dev


To flash the image, you will need to clone [this branch](https://github.com/Icenowy/sunxi-tools/tree/f1c100s-spiflash) of sunxi-tools fork by Icenowy, which contains the support for f1c100s/f1c200s SoC and SPI flash support. Lets clone it in your home directory as an example:
```
cd

git clone https://github.com/Icenowy/sunxi-tools.git -b f1c100s-spiflash

cd sunxi-tools

make

sudo make install
```

Once the image has finished building, please ensure your board is in FEL mode before continuing (see the list of notes below to learn how to enter FEL mode). First, lets move back to the output directory of buildroot and upload u-boot to the board's ram using sunxi-fel:
```
cd

cd /path/to/buildroot/output/speedsaver

sudo sunxi-fel -p uboot images/u-boot-sunxi-with-spl.bin
```

Then, at the u-boot prompt in your serial terminal window (which should be =>), type the following to erase the spi-nand flash:
```
mtd erase spi-nand0
```

When this has completed and you are back at the u-boot prompt, type this to start the DFU mode. It will timeout after 15 seconds:
```
run dfu_nand
```

Back in your terminal from which you ran sunxi-fel from, run the following commands:
```
sudo dfu-util -a u-boot -D images/u-boot-sunxi-with-nand-spl.bin

sudo dfu-util -R -a rom -D images/rootfs.ubi
```

The board should then reset itself and you should see it starting to boot.

Notes:

* To enter FEL mode, press both reset and boot button at the same time. Then, release reset first, and then boot. Do not release them simultaneously (in my experience releasing reset then waiting for half a second to release boot works good).
* You can start DFU again if you are not fast enough by typing this at the u-boot prompt:
```
run dfu_nand
```

## First boot ##

The first time your board boots, it will take a long while, but this is perfectly normal. Linux has to fix up the filesystem and prepare for boot at the same time. Subsequent reboots should be faster.
