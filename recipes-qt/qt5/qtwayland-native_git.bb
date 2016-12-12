require qt5-git.inc
require ${PN}.inc

# qtwayland wasn't released yet, last tag before this SRCREV is 5.0.0-beta1
# qt5-git PV is only to indicate that this recipe is compatible with qt5 5.2.1

QT_MODULE_BRANCH = "5.4"
SRCREV = "182488129c3f6a67a7e781fdb7c0147777191991"

# wayland-scanner and qtwaylandscanner must be in same path to work properly
do_install_append() {
    ln -sf ${D}${OE_QMAKE_PATH_QT_BINS}/qtwaylandscanner ${D}${bindir}/qtwaylandscanner
}
