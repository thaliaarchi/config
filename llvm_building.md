# Building LLVM (draft)

```sh
git clone git@github.com:llvm/llvm-project
cd llvm-project/llvm/bindings/go
sudo apt install llvm ninja-build
./build.sh -DCMAKE_BUILD_TYPE=Debug -DLLVM_TARGETS_TO_BUILD=host -DBUILD_SHARED_LIBS=on
```
