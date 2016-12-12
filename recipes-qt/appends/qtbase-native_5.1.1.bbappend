FILESEXTRAPATHS_prepend := "${THISDIR}/qtbase-${PV}:"
SRC_URI += " \
        file://0001-don-t-include-non-framework-include-paths-when-using.patch \
        file://rewrite-handling-of-private-modules.patch \
        file://Make-wayland-scanner-install-generated-headers.patch \
	"
