inherit gettext
FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"

# if DLNA is disabled, we use plain qtwebkit, with no RMF depends, and we disable DLNA in the patches
# if playersinkbin (generic mediaplayersink) is disabled, we depend on SoC mediaplayersink
DLNA_DEPENDS = "rmfgeneric"

DEPENDS += "${@base_contains('DISTRO_FEATURES', 'rdk-dlna', '${DLNA_DEPENDS}', '', d)}"

EXTRA_QMAKEVARS_PRE += "${@base_contains('DISTRO_FEATURES', 'rdk-dlna', 'DEFINES+=ENABLE_DLNA_VIDEO_PLAYER', '', d)}"

PACKAGECONFIG = "${@base_contains('DISTRO_FEATURES', 'gstreamer1', 'gstreamer', 'gstreamer010', d)}"

DEPENDS_remove = "qtdeclarative"
