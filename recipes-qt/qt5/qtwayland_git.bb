require qt5-git.inc
require ${PN}.inc

export QT_WAYLAND_GL_CONFIG="brcm_egl"

# qtwayland wasn't released yet, last tag before this SRCREV is 5.0.0-beta1
# qt5-git PV is only to indicate that this recipe is compatible with qt5 5.2.1

QT_MODULE_BRANCH = "5.4"
SRCREV = "182488129c3f6a67a7e781fdb7c0147777191991"

#QMAKE_PROFILES = "${S}/qtwayland.pro"

#    file://0001-disbale-brcm-plugins.patch \
#
SRC_URI += " \
    file://0001-Qtwayland-patch.patch \
    file://0001-Install-the-qtwaylandscanner-tool-to-the-native-side.patch \
    file://0001-Fix-building-of-QWaylandIntegration-if-some-Qt5-feat.patch \
    file://qwindow-compositor-use-opengl.patch \
"
PACKAGECONFIG ?= " \
    compositor-api \
    brcm-egl \
    wayland-egl \
    xkb \
    ${@bb.utils.contains('DISTRO_FEATURES', 'x11', 'xcompositor xkb glx', '', d)} \
"

PACKAGECONFIG[compositor-api] = "CONFIG+=wayland-compositor"
PACKAGECONFIG[xcompositor] = "CONFIG+=config_xcomposite CONFIG+=done_config_xcomposite,CONFIG+=done_config_xcomposite,libxcomposite"
PACKAGECONFIG[glx] = "CONFIG+=config_glx CONFIG+=done_config_glx,CONFIG+=done_config_glx,virtual/mesa"
PACKAGECONFIG[xkb] = "CONFIG+=config_xkbcommon CONFIG+=done_config_xkbcommon,CONFIG+=done_config_xkbcommon,libxkbcommon xproto"
PACKAGECONFIG[wayland-egl] = "CONFIG+=config_wayland_egl CONFIG+=done_config_wayland_egl,CONFIG+=done_config_wayland_egl,virtual/egl"
PACKAGECONFIG[brcm-egl] = "CONFIG+=config_brcm_egl CONFIG+=done_config_brcm_egl,CONFIG+=done_config_brcm_egl,virtual/egl"
PACKAGECONFIG[drm-egl] = "CONFIG+=config_drm_egl_server CONFIG+=done_config_drm_egl_server,CONFIG+=done_config_drm_egl_server,libdrm virtual/egl"
PACKAGECONFIG[libhybris-egl] = "CONFIG+=config_libhybris_egl_server CONFIG+=done_config_libhybris_egl_server,CONFIG+=done_config_libhybris_egl_server,libhybris"

EXTRA_QMAKEVARS_PRE += "${PACKAGECONFIG_CONFARGS}"

QT_WAYLAND_BUILD_PARTS = ""

do_configure_prepend () {
    rm -rf ${S}/examples/wayland/server-buffer
}

do_generate_qwayland_headers() {
    bbnote "generate qwayland headers"
    cd ${B}/src/client
    oe_runmake compiler_qtwayland_client_header_make_all
    sed -i "s/virtual void surface_enter/void surface_enter/" ${B}/include/QtWaylandClient/5.4.3/QtWaylandClient/private/qwayland-wayland.h
    sed -i "s/virtual void surface_leave/void surface_leave/" ${B}/include/QtWaylandClient/5.4.3/QtWaylandClient/private/qwayland-wayland.h
    find ${B}/src/client -name '*.h' -type f -exec cp {} ../../include/QtWaylandClient/5.4.3/QtWaylandClient/private/ \;
    cd ${B}/src/compositor
    oe_runmake compiler_wayland_server_header_make_all
    find ${B}/src/compositor -name '*.h' -type f -exec cp {} ../../include/QtCompositor/5.4.3/QtCompositor/private/ \;
}
#addtask do_generate_qwayland_headers after do_configure before do_compile

do_install_append() {
       # do install files created by qtwaylandscanner
       install ${B}/include/QtCompositor/5.4.3/QtCompositor/private/{qwayland-server-*,*protocol*}.h ${D}${includedir}/${QT_DIR_NAME}/QtCompositor/5.4.3/QtCompositor/private
}

FILES_${PN}-plugins += " \
    ${OE_QMAKE_PATH_PLUGINS}/*/*/*${SOLIBSDEV} \
"

FILES_${PN}-plugins-dbg += " \
    ${OE_QMAKE_PATH_PLUGINS}/*/*/.debug/* \
"

