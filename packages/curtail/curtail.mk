################################################################################
#
# curtail
#
################################################################################

CURTAIL_VERSION = 9b8284e7b02eb589f4eb62e236e5765abf204a5f
CURTAIL_SITE = $(call github,Comcast,Infinite-File-Curtailer,$(CURTAIL_VERSION))
CURTAIL_LICENSE = Apache-2.0
CURTAIL_LICENSE_FILES = LICENSE

CURTAIL_AUTORECONF = YES
$(eval $(autotools-package))
