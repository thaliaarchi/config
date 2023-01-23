# Compute pi with the spigot method

Compute pi in Whitespace with the reference Haskell interpreter:

```sh
mkdir -p ~/dev/github.com/thaliaarchi
cd ~/dev/github.com/thaliaarchi
git clone git@github.com:thaliaarchi/nebula
git clone git@github.com:thaliaarchi/whitespace-haskell
cd whitespace-haskell
sudo apt install ghc -y
make
echo 10000 | ./wspace ../nebula/programs/pi.out.ws
```

Compute pi using programs from The Computer Language Benchmarks Game:

```sh
mkdir -p ~/dev/salsa.debian.org/benchmarksgame-team
cd ~/dev/salsa.debian.org/benchmarksgame-team
git clone https://salsa.debian.org/benchmarksgame-team/benchmarksgame
cd benchmarksgame
echo sourcecode >> .git/info/exclude
unzip public/download/benchmarksgame-sourcecode.zip -d sourcecode
cd sourcecode/pidigits
cp pidigits.{gcc,c}
gcc -pipe -Wall -O3 -fomit-frame-pointer -march=native pidigits.c -o pidigits.gcc_run -lgmp
rm pidigits.c
./pidigits.gcc_run 10000
```
