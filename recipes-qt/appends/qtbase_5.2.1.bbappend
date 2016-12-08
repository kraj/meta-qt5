FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

QMAKE_MKSPEC_PATH = "${S}"

EXTRA_OECONF += "-qpa eglfs"

MESA_RDEPENDS = "libegl-gallium mesa-driver-swrast"

RDEPENDS_${PN}_append = " ${MESA_RDEPENDS}"

PACKAGECONFIG_GL = "gles2"
PACKAGECONFIG_FB = " "
PACKAGECONFIG_DISTRO = "icu examples sql-sqlite glib gstreamer"
