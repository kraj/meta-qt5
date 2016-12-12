do_configure_prepend() {
    sed -i -e "s/qtHaveModule(quick):qtHaveModule(widgets)/#qtHaveModule(quick):qtHaveModule(widgets)/g" ${S}/src/imports/imports.pro
}

INSANE_SKIP_${PN}-examples-dev = "dev-elf"
