require qt5.inc

DEPENDS += "qtbase qtdeclarative"

inherit bluetooth

PACKAGECONFIG ??= "${@base_contains('DISTRO_FEATURES', 'bluetooth', 'bluez', '', d)}"
PACKAGECONFIG[bluez] = "CONFIG+=OE_BLUEZ_ENABLED,,${BLUEZ}"

EXTRA_QMAKEVARS_PRE += "${EXTRA_OECONF}"

do_configure_prepend() {
    # disable bluez test if it isn't enabled by PACKAGECONFIG
    sed -i 's/^qtCompileTest(bluez)/OE_BLUEZ_ENABLED:qtCompileTest(bluez)/g' ${S}/qtconnectivity.pro
}

