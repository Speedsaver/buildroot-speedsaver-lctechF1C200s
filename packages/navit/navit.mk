################################################################################
#
# navit
#
################################################################################

NAVIT_VERSION = master
NAVIT_SITE = https://github.com/navit-gps/navit
NAVIT_LICENSE = GPL-2
NAVIT_DEPENDENCIES = host-pkgconf
NAVIT_MAKE = $(MAKE1)

ifeq ($(BR2_PACKAGE_NAVIT_SPEEDSAVER),y)
NAVIT_VERSION = master
NAVIT_SITE = https://github.com/Speedsaver/navit/archive/refs/heads
NAVIT_SOURCE = master.tar.gz
NAVIT_DEPENDENCIES += arduipi-oled libglib2 gpsd
endif

$(eval $(meson-package))
