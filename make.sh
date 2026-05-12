#!/bin/bash

APP=$(basename "$PWD")
DIR="build|Makefile|config.status|config.log|pybuilddir.txt"

do_regen() {
    # regenerate everything
    make regen-all
    make regen-frozen
}

do_build() {
    # build
    make -j8
}

do_clean() {
    # remove all build artifacts
    items=(
        Makefile config.status config.log pybuilddir.txt
        Python/frozen_modules build
        $APP
    )
    for item in "${items[@]}"; do
        [ -e "$item" ] && rm -rf "$item"
    done

    # configure
    # use 2>&1 >/dev/null to hide checks
    ./configure --enable-optimizations

    # clean (now that Makefile exists)
    make clean
}

do_dir_project() {
    tree -I $DIR -L 2 -f
}

do_default() {
    do_clear_screen
    do_menu
}

do_clear_screen() {
    clear
}

do_menu() {
    echo ""
    echo "   project <$APP>"
    echo ""
    echo "   d -- dir project"
    echo "   p -- regen"
    echo "   b -- build"
    echo "   r -- run"
    echo "   c -- clean"
    echo "   x -- exit"
    echo ""
}

do_input() {
    read -p '>> ' value
    echo "$value"
}

main() {
    do_menu
    while true; do
        value=$(do_input)

        case "$value" in
            d) do_dir_project;;
            p) do_regen;;
            b) do_build;;
            r) do_run;;
            c) do_clean;;
            x) break;;
            *) do_default;;
        esac
    done
}

if [ -t 0 ]; then
    main
else
    title="$BIN"
    xfce4-terminal\
        --title="$title"\
        -e "bash -c './make.sh $@; exec bash'"
fi