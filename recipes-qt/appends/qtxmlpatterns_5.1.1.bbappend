do_configure_append() {
    sed -i -e "s/^SUBDIRS/#SUBDIRS/g" ${S}/examples/examples.pro
}
