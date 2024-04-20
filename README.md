<h1 align="center">
<img align="center" src="https://sonic3air.org/images/title_sonic3air.png" width="50%"><br>
Sonic 3 A.I.R. · PSVita Port
</h1>
<p align="center">
  <a href="#setup-instructions-for-players">How to install</a> •
  <a href="#build-instructions-for-developers">How to compile</a> •
  <a href="#credits">Credits</a> •
  <a href="#license">License</a>
</p>

Sonic 3 A.I.R. (Angel Island Revisited) is a fan-made remaster of the classic
Sega game Sonic 3 & Knuckles. This project modernizes the original game by
adding widescreen support, improved graphics and audio, and new gameplay
features. It is designed to offer a superior playing experience on modern
systems while requiring original game data to run. 

This repository contains the PlayStation Vita port of Sonic 3 A.I.R. Consider
this a "beta" release aimed at collecting player feedback. In the future, the
port is planned to be merged upstream.

Disclaimer
----------------

**Sonic 3 A.I.R.** is a non-profit fan game project. It is not affiliated in
any way with SEGA or Sonic Team, the original creators of Sonic 3 and
Sonic & Knuckles.

Sonic the Hedgehog is a trademark of SEGA. All copyrights regarding Sonic
the Hedgehog, including characters, names, terms, art, and music belong to SEGA.
All registered trademarks belong to SEGA and Sonic Team.

The developers of Sonic 3 A.I.R. have no intent to infringe said copyrights and
registered trademarks. No financial gain is made from this project.

Any commercial use of this project without SEGA's explicit consent is strictly
prohibited.

The original README can be found [here](https://github.com/Eukaryot/sonic3air).

Setup Instructions (For Players)
----------------

In order to properly install the game, you'll have to follow these steps
precisely:

- <u>Legally</u> obtain a compatible Sonic 3 & Knuckles ROM.<br>
  The instructions on how to do that are available at [sonic3air.org][s3airorg]

- Install [FdFix][fdfix] by copying `fd_fix.skprx` to your taiHEN plugins folder
  (usually `ur0:tai`) and adding the entry to your `config.txt` under `*KERNEL`:

```
  *KERNEL
  ur0:tai/fd_fix.skprx
```

```diff
! ⚠️ Don't install `fd_fix.skprx` if you're using the rePatch plugin!
! ⚠️ rePatch provides the same functionality and they may conflict.
```

- Make sure you have `libshacccg.suprx` in the `ur0:/data/` folder on your
  console. If you don't, use [ShaRKBR33D][shrkbrd] to get it quickly and easily.

- Download the archive with data files (`sonic3air.zip`) from
  [Releases][latest-release]. Unpack it to the `ux0:/data/sonic3air/` folder
  on your console.
  Example of correct resulting path: `ux0:/data/sonic3air/data/scripts.bin`.

- Rename your Sonic 3 & Knuckles ROM to `Sonic_Knuckles_wSonic3.bin` and
  place it in `ux0:data/sonic3air/Sonic_Knuckles_wSonic3.bin`.

- Download and install the VPK from [Releases][latest-release].

- (Optional) Download the remastered audio pack (`audioremaster.bin`) from
  [Releases][latest-release]. Place it in the `ux0:data/sonic3air/data/` folder.

Build Instructions (For Developers)
----------------

Please refer to the [howtobuild.md][howtobuild]

Credits
----------------


- [Eukaryot][euka] and [contributors][contribs] for the original Sonic 3 A.I.R.
  project and help with understanding the engine.
- [MDashK][mdashk] for actually getting this to a playable state and release,
  numerous fixes and improvements, a lot of testing, and many other things
  I can't possibly list here.
- [Rinnegatamante][rinne] for translating shaders, VAOs support in VitaGL,
  optimization, and more.
- [Brandonheat8][brandon] for the LiveArea assets.

License
----------------

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version. See the [LICENSE](LICENSE) file for details.

[s3airorg]: https://sonic3air.org/
[fdfix]: https://github.com/TheOfficialFloW/FdFix/releases/
[shrkbrd]: https://github.com/Rinnegatamante/ShaRKBR33D/releases/latest
[latest-release]: https://github.com/v-atamanenko/sonic3air/releases/latest
[howtobuild]: https://github.com/v-atamanenko/sonic3air/blob/main/Oxygen/sonic3air/build/_vita/howtobuild.md

[rinne]: https://github.com/Rinnegatamante/
[brandon]: https://github.com/Brandonheat8
[o13o]: https://github.com/once13one/
[mdashk]: https://github.com/MDashK
[euka]: https://github.com/Eukaryot/
[contribs]: https://github.com/Eukaryot/sonic3air?tab=readme-ov-file#contributors
