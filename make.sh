#!/bin/bash

main() {
    # 1. Remove all build artifacts
    rm -f Makefile config.status config.log pybuilddir.txt
    rm -rf Python/frozen_modules build

    # 2. Configure
    ./configure --enable-optimizations

    # 3. Clean (now that Makefile exists)
    make clean

    # 4. Regenerate everything
    make regen-all
    make regen-frozen

    # 5. Build
    make -j8
}

if [ -t 0 ]; then
    main
else
    title="$BIN"
    xfce4-terminal\
        --title="$title"\
        -e "bash -c './make.sh $@; exec bash'"
fi