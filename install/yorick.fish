#!/usr/bin/env fish

clonedev https://github.com/LLNL/yorick
cd ~/dev/github.com/LLNL/yorick

make config
make
make check
make install

echo 'Add ~/dev/github.com/LLNL/yorick/relocate/bin to PATH'
