#!/bin/bash

main() {
    make clean

    ./configure \
        --enable-optimizations \
        --disable-test-modules \
        --disable-pgo \
        --disable-lto

    make regen-pegen
#    make regen-token
#    make regen-ast
#    make regen-opcode
    make all
}

if [ -t 0 ]; then
    main
else
    title="$BIN"
    xfce4-terminal\
        --title="$title"\
        -e "bash -c './make.sh $@; exec bash'"
fi