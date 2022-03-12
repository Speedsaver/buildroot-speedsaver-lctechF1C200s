################################################################################
#
# navit
#
################################################################################

NAVIT_VERSION = trunk
NAVIT_SITE = git://github.com/navit-gps/navit
NAVIT_LICENSE = GPL-2
NAVIT_DEPENDENCIES = host-pkgconf
NAVIT_MAKE = $(MAKE1)
NAVIT_CONF_OPTS = -DSVG2PNG=FALSE -DLIBDIR=/usr/lib -DSAMPLE_MAP=0 -DCMAKE_EXE_LINKER_FLAGS=-Wl,--export-dynamic

ifeq ($(BR2_PACKAGE_NAVIT_GTK2),y)
NAVIT_DEPENDENCIES += libgtk2
NAVIT_CONF_OPTS += -Dgraphics/gtk_drawing_area=1
else
NAVIT_CONF_OPTS += -Dgraphics/gtk_drawing_area=0
endif

ifeq ($(BR2_PACKAGE_NAVIT_QT5),y)
NAVIT_DEPENDENCIES += qt5svg qt5declarative
NAVIT_CONF_OPTS += -Dgraphics/qt5=1
else
NAVIT_CONF_OPTS += -DDISABLE_QT=1 -Dgraphics/qt5=0 -Dvehicle/qt5=0
endif

ifeq ($(BR2_PACKAGE_NAVIT_SPEEDSAVER),y)
NAVIT_VERSION = 81714d7ecdcc392f73c613f42d3acf0d02b5f7ad
NAVIT_SITE = git://github.com/speedsaver/navit
NAVIT_DEPENDENCIES += arduipi-oled libglib2
NAVIT_CONF_OPTS += -Dspeech/cmdline=0 -Dmap/textfile=0 -Dgui/internal=0 -DUSE_NATIVE_LANGUAGE_SUPPORT=0
endif

ifeq ($(BR2_PACKAGE_NAVIT_SPOTIFY_PLAYER),y)
NAVIT_VERSION = audio
NAVIT_DEPENDENCIES += alsa-lib libspotify
NAVIT_CONF_OPTS += -DUSE_AUDIO_FRAMEWORK=1
endif

ifeq ($(BR2_PACKAGE_NAVIT_VEHICLE_GPSD),y)
NAVIT_DEPENDENCIES += gpsd
NAVIT_CONF_OPTS += -Dvehicle/gpsd=1
endif

ifeq ($(BR2_PACKAGE_NAVIT_J1850_PLUGIN),y)
NAVIT_CONF_OPTS += -Dplugin/j1850=1
endif

$(eval $(cmake-package))
