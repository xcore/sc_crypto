#include "AESfunctions.h"
#include "stdio.h"

unsigned char key[16] = { 0x0f, 0x15, 0x71, 0xc9, 0x47, 0xd9, 0xe8, 0x59,
                          0x0c, 0xb7, 0xad, 0xd6, 0xaf, 0x7f, 0x67, 0x98};

unsigned char enc[16] = { 0x72, 0x88, 0xee, 0xcb, 0x76, 0x7f, 0xa0, 0xcc,
                          0x00, 0x48, 0x00, 0xcf, 0x38, 0x8a, 0xfa, 0xc2 };

main() {
    char message[17] = "Hello0123456789.";
    char output[16];
    Encrypt((message, unsigned int[4]), (key, unsigned int[4]), (output, unsigned int[4]));
    for(int i =0; i < 16; i++) {
        printf("%02x ", output[i]);
    }
    printf("\n");
    for(int i =0; i < 16; i++) {
        printf("%02x ", enc[i]);
    }
    Decrypt((enc, unsigned int[4]), (key, unsigned int[4]), (output, unsigned int[4]));
    printf("\n");
    for(int i =0; i < 16; i++) {
        printf("%02x ", output[i]);
    }
    printf("\n");
    for(int i =0; i < 16; i++) {
        printf("%02x ", message[i]);
    }
    printf("\n");
}
