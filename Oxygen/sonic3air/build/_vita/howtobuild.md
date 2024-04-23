# Building using Make

## Playstation Vita
1. Get a standard VitaSDK installation at https://vitasdk.org/
2. The minizip-ng fork from https://github.com/v-atamanenko/minizip-ng . Compile it this way:
```
git clone https://github.com/v-atamanenko/minizip-ng
cd minizip-ng
cmake . -Bbuild -DCMAKE_TOOLCHAIN_FILE=$VITASDK/share/vita.toolchain.cmake -DMZ_LZMA=OFF -DMZ_OPENSSL=OFF -DMZ_PKCRYPT=OFF -DMZ_WZAES=OFF -DMZ_SIGNING=OFF -DMZ_LIBBSD=OFF -DMZ_ICONV=OFF -DUNIX=1
cmake --build build -- -j$(nproc) && cmake --install build
```
3. Build sonic3air:
```
git clone https://github.com/Eukaryot/sonic3air
cd sonic3air/Oxygen/sonic3air/build/_vita/
cmake -S. -Bbuild
cmake --build build -- -j$(nproc)
```
4. Find the built `sonic3air.vpk` and `eboot.bin` in the `Oxygen/sonic3air/build/_vita/build/` directory.

5. The Vita version uses different shaders, so you will need to copy the `shader` folder from `Oxygen/sonic3air/build/_vita` into `ux0:data/sonic3air/data`.
