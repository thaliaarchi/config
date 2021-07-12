#!/usr/bin/env fish

# https://ghidra-sre.org/
# https://ghidra-sre.org/InstallationGuide.html

set -l VERSION 9.2
set -l DATE 20201113

if ! test -f ghidra_{$VERSION}_PUBLIC_$DATE.zip
  wget https://ghidra-sre.org/ghidra_{$VERSION}_PUBLIC_$DATE.zip
end
unzip ghidra_{$VERSION}_PUBLIC_$DATE.zip
mv ghidra_{$VERSION}_PUBLIC ~/opt/ghidra_$VERSION
ln -s ~/opt/ghidra_$VERSION/ghidraRun ~/bin/ghidra
