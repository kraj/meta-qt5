SUMMARY = "QtWebSockets"
LICENSE = "CLOSED"
SECTION = "qtapps"
DEPENDS = "qtbase"

SRCREV = "${AUTOREV}"

PV .= "+git${SRCPV}"

SRC_URI = "git://${RDK_GIT}/rdk/components/opensource/qtwebsockets/generic;module=.;protocol=${RDK_GIT_PROTOCOL};branch=${RDK_GIT_BRANCH}"

S = "${WORKDIR}/git"

# this component doesn't build with -Wl,-as-needed, remove the flag for now
ASNEEDED = ""

require recipes-qt/qt5/qt5.inc

OE_QMAKE_PATH_HEADERS = "${OE_QMAKE_PATH_QT_HEADERS}"

do_configure_prepend () {
	rm -rf ${S}/examples
}
