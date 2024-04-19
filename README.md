# Sonic 3 A.I.R. — PSVita Port

## Disclaimer

Sonic 3 A.I.R. is a non-profit fan game project. It is not affiliated in any way with SEGA or Sonic Team, the original creators of Sonic 3 and Sonic & Knuckles.

Sonic the Hedgehog is a trademark of SEGA. All copyrights regarding Sonic the Hedgehog, including characters, names, terms, art, and music belong to SEGA. All registered trademarks belong to SEGA and Sonic Team.

The developers of Sonic 3 A.I.R. have no intent to infringe said copyrights and registered trademarks.
No financial gain is made from this project.

Any commercial use of this project without SEGA's explicit consent is strictly prohibited.

The original README can be found here: [https://github.com/Eukaryot/sonic3air](https://github.com/Eukaryot/sonic3air)

## How to install (for players)

* Legally obtain a compatible Sonic 3 & Knuckles ROM. Instructions on how to do that are available at [https://sonic3air.org/](https://sonic3air.org/).
* Make sure you have `libshacccg.suprx` in the `ur0:/data/` folder on your console. If you don't, use [ShaRKBR33D](https://github.com/Rinnegatamante/ShaRKBR33D/releases/tag/v.1.0.1) to get it quickly and easily.
* Download the archive with data files (`sonic3air.zip`) from [Releases](https://github.com/v-atamanenko/sonic3air/releases/latest). Unpack it to the `ux0:/data/sonic3air/` folder on your console. Example of correct resulting path: `ux0:/data/sonic3air/data/scripts.bin`.
* Optionally: download the remastered audio pack (`audioremaster.bin`) from [Releases](https://github.com/v-atamanenko/sonic3air/releases/latest). Place it in the `ux0:/data/sonic3air/data/` folder.
* Rename your Sonic 3 & Knuckles ROM to `Sonic_Knuckles_wSonic3.bin` and place it in `ux0:data/sonic3air/Sonic_Knuckles_wSonic3.bin`.
* Download and install the VPK from [Releases](https://github.com/v-atamanenko/sonic3air/releases/latest).

## How to build (for developers)

Please refer to the [howtobuild.md](https://github.com/v-atamanenko/sonic3air/blob/main/Oxygen/sonic3air/build/_vita/howtobuild.md)

## Credits

* Eukaryot and contributors — the original Sonic 3 A.I.R. project
* MDashK - actually getting this to a playable state and release, numerous fixes and improvements
* Rinnegatamante - shaders, VAOs support in VitaGL, optimization
