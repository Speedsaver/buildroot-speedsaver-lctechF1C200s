# External MangoPi R3C buildroot tree for Speedsaver #

This external tree contains the support for Widora MangoPi R3C revision only. This is tweaked from what the vendor supplied to allow for the Speedsaver use case and based on the original work [here](https://github.com/Speedsaver/buildroot-mangopi).

## Required tools ##

To use this, you will require the following tools:
* sunxi-tools
* dfu-util

## How to build ##

This external tree will work with the latest buildroot version, which is 2022.02 at the time of this writing.

Download buildroot, then git clone this external tree, cd to the buildroot top level directory, then type these commands:

```
for p in /path/to/buildroot-speedsaver-mangopi/buildroot-patches/*.patch; do patch -p1 < $p; done
make BR2_EXTERNAL=/path/to/buildroot-speedsaver-mangopi speedsaver_defconfig O=output/speedsaver
cd output/speedsaver
make
```

If you have a multi-cores machine, you can try passing -j to the second make invocation to accelerate the build.

## Flashing ##

Once the image has finished building, please ensure your board is in FEL mode before continuing. First, lets upload u-boot to the board's ram using sunxi-fel:

```
sudo sunxi-fel -p uboot images/u-boot-sunxi-with-spl.bin
```

Once this is done and you are back to your shell, you have 15 seconds before the board timeouts the DFU. Enter the following:

```
sudo dfu-util -a u-boot -D images/u-boot-sunxi-with-nand-spl.bin
sudo dfu-util -R -a rom -D images/rootfs.ubi
```

The board should then reset itself and you should see it starting to boot.
notes:
* It is a good idea to connect putty or screen, or some serial program to the uart port at all times so you can quickly check on u-boot and on boot progress to ensure everything is going well.
* If you do this on an already flashed board (i.e: a board which has already some data in the nand flash), you must do things a little differently.
	* To enter FEL mode, press both reset and boot button at the same time. Then, release reset first, and then boot. Do not release them simultaneously.
	* Upload u-boot to the board's ram as usual.
	* Let the first DFU time out, so that you are back at the u-boot prompt which should be =>.
	* Type the following:
	```
	mtd erase spi-nand0 0x0 0x8000000
	```
	* When this is completed, type this to give you another 15 seconds  for DFU:
	```
	run dfu_nand
	```
* You can start DFU again if you are not fast enough by typing this at the u-boot prompt:
```
run dfu_nand
```

## First boot ##

The first time your board boots, it will take a long while, but this is perfectly normal. Linux has to fix up the filesystem and prepare for boot at the same time. Subsequent reboots should be faster, but please do note that the 15 seconds timeout for DFU will happen at every boot for now.
