inherit gettext
PACKAGECONFIG_GL = "gles2"
PACKAGECONFIG_FB = " "
PACKAGECONFIG_DISTRO = "icu examples sql-sqlite glib"

PACKAGECONFIG_DISTRO += " ${@base_contains('DISTRO_FEATURES', 'gstreamer1', 'gstreamer', 'gstreamer010', d)}"

PACKAGECONFIG_DISTRO += " pcre"

PACKAGECONFIG_remove = "dbus"
PACKAGECONFIG_append = " fontconfig"

PACKAGECONFIG[printsupport] = ",-DQT_NO_PRINTER,,"
EXTRA_OECONF += "-DQT_NO_PRINTER"

FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}-${PV}:"
SRC_URI += " \
	file://qt-5.1.1_qeglfs.patch \
        file://0001-qtbase-Do-not-force-disabling-printsupport-for-cross.patch \
	${@base_contains('PACKAGECONFIG_DISTRO', 'printsupport', '', 'file://disable-printsupport.patch', d)} \
	"


###Added install_append task to move fonts directory from libdir to datadir as per FHS compliance#######
do_configure_prepend () {

	# disable printsupport if we upgrade to 5.2+ then we can disable
	# it with configure
	# https://bugreports.qt.io/browse/QTBUG-33565
#	rm -rf ${S}/src/printsupport
#	rm -rf ${S}/plugins/printsupport
}
do_install_append() {
        install -d ${D}${datatdir}
        rm -rf ${D}${libdir}/fonts/*.pfb
        mv ${D}${libdir}/fonts ${D}${datadir}
	rm -rf ${D}${libdir}/cacert.pem
	rm -rf ${D}${libdir}/libQt5Test.so.5.*
        rm -rf ${D}${libdir}/pkgconfig/Qt5Bootstrap.pc
        rm -rf ${D}${libdir}/pkgconfig/Qt5BootstrapDBus.pc
}

FILES_${PN}-fonts-ttf-vera       = "${datadir}/fonts/Vera*.ttf"
FILES_${PN}-fonts-ttf-dejavu     = "${datadir}/fonts/DejaVu*.ttf"
FILES_${PN}-fonts-pfa            = "${datadir}/fonts/*.pfa"
FILES_${PN}-fonts-qpf            = "${datadir}/fonts/*.qpf*"
FILES_${PN}-fonts                = "${datadir}/fonts/README \
                                    ${datadir}/fonts/fontdir"

PACKAGES =. "\
    ${PN}-test \
    ${PN}-printsupport \
    ${PN}-sql \
    ${PN}-xml \
"
EXTRA_OECONF_remove = " --enable-nls"
FILES_${PN}-test_remove = "${libdir}/libQt5Test.so.5.*"
FILES_${PN}-printsupport = "${libdir}/libQt5PrintSupport.so.5.*"
FILES_${PN}-sql = "${libdir}/libQt5Sql.so.5.*"
FILES_${PN}-xml = "${libdir}/libQt5Xml.so.5.*"
