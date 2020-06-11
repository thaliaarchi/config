#!/usr/bin/env fish

# https://ghidra-sre.org/
# https://ghidra-sre.org/InstallationGuide.html

set VERSION 9.1.2
set DATE 20200212

if not test -f ghidra_{$VERSION}_PUBLIC_$DATE.zip
  wget https://ghidra-sre.org/ghidra_{$VERSION}_PUBLIC_$DATE.zip
end
unzip ghidra_{$VERSION}_PUBLIC_$DATE.zip
sudo mv ghidra_{$VERSION}_PUBLIC /usr/local/ghidra_$VERSION
sudo ln -s /usr/local/ghidra_$VERSION/ghidraRun /usr/local/bin/ghidra
