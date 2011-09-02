// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include "stdio.h"
#include "SHA2.h"

struct test {
    int n;
    char string[128];
    char result[65];
} tests[5] = {
    { 0,
      "",
      "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"},
    {54,
     "This is a test message for SHA-2 that is 54 bytes long",
     "663d28a267db4a563617104a30917f18cda5ee911fb51102332ab8f8d86bee73"},
    {55,
     "This is a test message for SHA-2 that is 55 bytes long.",
     "df87a4fa19f0a2f42b5bb9cfbb74ddd7d5ae63131294d2972578d3f2473afe9d"},
    {56,"This is a test message for SHA-2 that is 56 bytes long!!",
     "3686394e0e3afc7965869bb2f53e4b89a0899bf3fdc019754ca3f9f04e906c69"},
    {64,
     "This is a test message for SHA-2 that is 64 bytes long0123456789",
     "c1396466e93b11662fe09475e8238a16e5ebc03bb7d1cce0b39cc8b8f1912dbc"},
};

int main(void) {
    unsigned int hash[8];
    timer t;
    int t2, t3;
    streaming chan c;

    par {
        sha256Process(c);
        {
            for(int j = 0; j < 5; j++) {
                t :> t2;
                sha256Begin(c);
                sha256Update(c, tests[j].string, tests[j].n);
                sha256End(c, hash);
                t :> t3;
                for(int i = 0; i < 8; i++) {
                    printf("%08x", hash[i]);
                }
                printf(" %d\n", t3-t2);

                t :> t2;
                sha256BlockBegin(hash);
                sha256BlockUpdate(hash, tests[j].string, tests[j].n);
                sha256BlockEnd(hash);
                t :> t3;
                for(int i = 0; i < 8; i++) {
                    printf("%08x", hash[i]);
                }
                printf(" %d\n", t3-t2);
                printf("%s\n\n", tests[j].result);
            }
            sha256Terminate(c);
        }
    }
    return 0;
}
