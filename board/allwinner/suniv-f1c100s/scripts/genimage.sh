#!/bin/bash
set -e
SELFDIR=`dirname \`realpath ${0}\``

[ $# -eq 2 ] || {
    echo "SYNTAX: $0 <u-boot-with-spl image> <genimage.cfg>"
    echo "Given: $@"
    exit 1
}

${SELFDIR}/mknanduboot.sh ${1}/${2} ${1}/u-boot-sunxi-with-nand-spl.bin
support/scripts/genimage.sh ${1} -c "${BR2_EXTERNAL_SPEEDSAVER_MANGOPI_PATH}/board/allwinner/suniv-f1c100s/genimage-nand.cfg"
support/scripts/genimage.sh ${1} -c "${BR2_EXTERNAL_SPEEDSAVER_MANGOPI_PATH}/board/allwinner/suniv-f1c100s/genimage-sdcard.cfg"
