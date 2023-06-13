#!/bin/bash
set -e
SELFDIR=`dirname \`realpath ${0}\``

STARTDIR=`pwd`
MKIMAGE="${HOST_DIR}/bin/mkimage"
IMAGE_ITS="kernel.its"
OUTPUT_NAME="kernel.itb"

[ $# -eq 2 ] || {
    echo "SYNTAX: $0 <u-boot-with-spl image> <genimage.cfg>"
    echo "Given: $@"
    exit 1
}

cp "${BR2_EXTERNAL_SPEEDSAVER_MANGOPI_PATH}/board/allwinner/suniv-f1c100s/kernel.its" "${BINARIES_DIR}"
cd "${BINARIES_DIR}"
"${MKIMAGE}" -f ${IMAGE_ITS} ${OUTPUT_NAME}
rm ${IMAGE_ITS}

cd "${STARTDIR}/"

${SELFDIR}/mknanduboot.sh ${1}/${2} ${1}/u-boot-sunxi-with-nand-spl.bin
support/scripts/genimage.sh ${1} -c "${BR2_EXTERNAL_SPEEDSAVER_MANGOPI_PATH}/board/allwinner/suniv-f1c100s/genimage-nand.cfg"
support/scripts/genimage.sh ${1} -c "${BR2_EXTERNAL_SPEEDSAVER_MANGOPI_PATH}/board/allwinner/suniv-f1c100s/genimage-sdcard.cfg"
