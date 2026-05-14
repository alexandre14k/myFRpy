#!/bin/bash

APP=$(basename "$PWD")
DIR="build|Makefile|config.status|config.log|pybuilddir.txt"

do_run() {
    # run if exists
    [[ -e "$APP" ]]; ./$APP
}

do_regen() {
    # regenerate everything
    make regen-all
    make regen-frozen
}

do_build() {
    # build
    make -j8
}

do_erase() {
    # remove all build artifacts
    items=(
        Makefile config.status config.log pybuilddir.txt
        Python/frozen_modules build
        $APP
    )
    for item in "${items[@]}"; do
        [ -e "$item" ] && rm -rf "$item"
    done
}

do_clean() {
    do_erase

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
    echo "   d -- tree  | arborescence"
    echo "   p -- regen | configurer"
    echo "   b -- build | construire"
    echo "   r -- run   | exécuter"
    echo "   c -- clean | nettoyer"
    echo "   e -- erase | effacer"
    echo "   x -- exit  | quitter"
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
            e) do_erase;;
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
