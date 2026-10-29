#include <3ds.h>
#include <stdio.h>

// initial code for 3DS hello world using citro2d/libctru

int main(int argc, char **argv) {
    // Initialize graphics
    gfxInitDefault();
    consoleInit(GFX_TOP, NULL);

    printf("Hello World!\n");

    // Main loop
    while (aptMainLoop()) {
        hidScanInput();
        u32 kDown = hidKeysDown();

        // Break out of the loop if Start is pressed
        if (kDown & KEY_START) break;

        gfxFlushBuffers();
        gfxSwapBuffers();
        gspWaitForVBlank();
    }

    // Exit
    gfxExit();
    return 0;
}
