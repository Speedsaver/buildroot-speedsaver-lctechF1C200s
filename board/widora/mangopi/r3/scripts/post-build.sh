# create version stamping information into the target

echo "V "${SPEEDSAVER_VERSION}" on BR "${BR2_VERSION}"" \
	> "${TARGET_DIR}"/etc/version_stamp
