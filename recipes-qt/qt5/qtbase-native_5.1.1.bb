LICENSE = "GFDL-1.3 & LGPL-2.1 | GPL-3.0"
LIC_FILES_CHKSUM = "file://LICENSE.LGPL;md5=4193e7f1d47a858f6b7c0f1ee66161de \
                    file://LICENSE.GPL;md5=d32239bcb673463ab874e80d47fae504 \
                    file://LGPL_EXCEPTION.txt;md5=0145c4d1b6f96a661c2c139dfb268fb6 \
                    file://LICENSE.FDL;md5=6d9f2a9af4c8b8c3c769f6cc1b6aaf7e"

SRCREV = "${AUTOREV}"
SRC_URI += "git://${RDK_GIT}/rdk/components/opensource/qt5_1/generic;protocol=${RDK_GIT_PROTOCOL};branch=${RDK_GIT_BRANCH}"

S = "${WORKDIR}/git/source/qtbase"

require ${PN}-${PV}.inc

do_configure_prepend() {
        rm -rf ${S}/../../components ${S}/../../qtbrowser \
               ${S}/../../webtests ${S}/../qtwebengine/ \
               ${S}/../qtimageformats ${S}/../qtwebkit-examples/ \
               ${S}/../default_platform ${S}/../qtwebkit \
               ${S}/../qt.pro ${S}/../configure
}

do_install_append() {
    # for modules which are still using syncqt and call qtPrepareTool(QMAKE_SYNCQT, syncqt)
    # e.g. qt3d, qtwayland
    ln -sf syncqt.pl ${D}${OE_QMAKE_PATH_QT_BINS}/syncqt
}
