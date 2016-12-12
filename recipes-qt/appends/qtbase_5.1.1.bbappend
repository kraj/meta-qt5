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
        file://0001-don-t-include-non-framework-include-paths-when-using.patch \
        file://rewrite-handling-of-private-modules.patch \
        file://Make-wayland-scanner-install-generated-headers.patch \
        file://0001-qeglfshooksrpi-update-vc_dispmanx_element_change_att.patch \
        file://0001-Long-live-QOpenGLTexture.patch \
        file://0001-Fix-check-in-texture-cleanup-code.patch \
        file://autodetect-gstreamer.patch \
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

do_configure_prepend_rpi() {

   sed -i 's!load(qt_config)!!' ${S}/mkspecs/linux-oe-g++/qmake.conf
    if ! grep -q '^EGLFS_' ${S}/mkspecs/linux-oe-g++/qmake.conf; then
        cat >> ${S}/mkspecs/linux-oe-g++/qmake.conf <<EOF
QMAKE_INCDIR_EGL = \$\$[QT_SYSROOT]${includedir}/interface/vcos/pthreads \$\$[QT_SYSROOT]${includedir}/interface/vmcs_host/linux
QMAKE_INCDIR_OPENGL_ES2 = \$\${QMAKE_INCDIR_EGL}
QMAKE_LIBS_EGL = -lEGL -lGLESv2
EOF

        if [ -d ${S}/src/plugins/platforms/eglfs/deviceintegration/eglfs_brcm ]; then
            cat >> ${S}/mkspecs/linux-oe-g++/qmake.conf <<EOF
EGLFS_DEVICE_INTEGRATION = eglfs_brcm
EOF
        else
            cat >> ${S}/mkspecs/linux-oe-g++/qmake.conf <<EOF
EGLFS_PLATFORM_HOOKS_LIBS = -lbcm_host
EGLFS_PLATFORM_HOOKS_SOURCES = \$\$PWD/../devices/linux-rasp-pi-g++/qeglfshooks_pi.cpp
EOF
        fi
    fi
    cat >> ${S}/mkspecs/linux-oe-g++/qmake.conf <<EOF


load(qt_config)

EOF
}

do_install_append() {
        install -d ${D}${datatdir}
        rm -rf ${D}${libdir}/fonts/*.pfb
        mv ${D}${libdir}/fonts ${D}${datadir}
	rm -rf ${D}${libdir}/cacert.pem
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
#FILES_${PN}-test_remove = "${libdir}/libQt5Test.so.5.*"
FILES_${PN}-printsupport = "${libdir}/libQt5PrintSupport.so.5.*"
FILES_${PN}-sql = "${libdir}/libQt5Sql.so.5.*"
FILES_${PN}-xml = "${libdir}/libQt5Xml.so.5.*"
