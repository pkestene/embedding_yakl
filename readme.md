# A minimal cmake fortran project to demo use of yakl gator

## reference build

```shell
mkdir -p _build/ref
cd _build/ref
cmake -DYAKL_ARCH=CUDA -DENABLE_INSTALL=OFF ../..
make
./src/test_yakl
```

Now turn `ENABLE_INSTALL=ON`, you have the following cmake error:
```text
CMake Error in src/CMakeLists.txt:
   Target "test_yakl" INTERFACE_INCLUDE_DIRECTORIES property contains path:

     "/home/pkestene/install/yakl/github/embedding_yakl/_build/ref/_deps/yakl_external-build"

   which is prefixed in the build directory.
```

## modified build

```shell
mkdir -p _build/modif
cd _build/ref
cmake -DYAKL_ARCH=CUDA -DENABLE_INSTALL=OFF -DUSE_MODIFIED_YAKL=ON ../..
make
./src/test_yakl
```

Now turn `ENABLE_INSTALL=ON`, no more error, `make install` is working as expected.
