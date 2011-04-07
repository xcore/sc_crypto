// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include "stdio.h"
#include "SHA2.h"

int main(void) {
    unsigned int hash[8];
    char message[65]="This is a test message for SHA-2 that is 55 bytes long.";
    timer t;
    int t0, t1, t2, t3;

    message[55] = 0x80;
    t :> t0;
    computeSHA2((message, unsigned int[16]), hash);
    t :> t1;
    for(int i = 0; i < 8; i++) {
        printf("%08x", hash[i]);
    }
    printf(" %d\n", t1-t0);
    t :> t2;
    computeSHA2S((message, unsigned int[16]), hash);
    t :> t3;
    for(int i = 0; i < 8; i++) {
        printf("%08x", hash[i]);
    }
    printf(" %d\n", t3-t2);
    printf("df87a4fa19f0a2f42b5bb9cfbb74ddd7d5ae63131294d2972578d3f2473afe9d\n");
    return 0;
}
