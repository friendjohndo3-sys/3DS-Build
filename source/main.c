#initial code for 3DS hello world using citro2d/libctru
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <citro3d.h>

int main(int argc, char* argv[]) {
    // Initialize graphics and console on top screen
    gfxInitDefault();
    consoleInit(GFX_TOP, NULL);

    printf("\x1b[10;12HHello World!\n");
    printf("\x1b[12;8HPress START to exit.\n");

    // Main loop
    while (aptMainLoop()) {
        hidScanInput();

        u32 kDown = hidKeysDown();
        if (kDown & KEY_START) break; // break in order to return to hbmenu

        // Flush and swap framebuffers
        gfxFlushBuffers();
        gfxSwapBuffers();

        // Wait for VBlank
        gspWaitForVBlank();
    }

    gfxExit();
    return 0;
}
