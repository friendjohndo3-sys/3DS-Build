# Hello World 3DS Homebrew

A simple starter project for Nintendo 3DS homebrew.

## Requirements
- **devkitPro** with `devkitARM` and `libctru` installed.

## How to Compile into a .3DSX (Homebrew Menu)
1. Open your devkitPro-enabled terminal (MSYS2 on Windows, terminal on Linux/macOS).
2. Navigate to this project folder.
3. Run:
   ```bash
   make
   ```
4. This will generate `hello_world_3ds.3dsx` and `hello_world_3ds.smdh`, which you can copy to your 3DS SD card inside the `/3ds/` folder.

## How to Compile into a .CIA file (Installed to 3DS Home Menu)
1. First, build the project normally using `make` to get your `.elf` and `.smdh` files.
2. Install `makerom` (part of devkitPro toolchain or `bannertool`/`makerom` utilities).
3. Run the following command in your terminal:
   ```bash
   makerom -f cia -o hello_world_3ds.cia -rsf template.rsf -target t -exefslogo -elf hello_world_3ds.elf -icon hello_world_3ds.smdh
   ```
4. Copy the resulting `hello_world_3ds.cia` to your SD card and install it using **FBI** on your modded 3DS.
