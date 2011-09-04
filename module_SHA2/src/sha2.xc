// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

#include <xs1.h>
#include <xclib.h>
#include <stdio.h>
#include "SHA2.h"

/*
#define rotr(a,n)    (((a)>>(n)) | ((a)<<(32-(n))))
#define shiftr(a,n)    ((a)>>(n))

static unsigned int k2[66] = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
    0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
    0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
    0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
    0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
    0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
    0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
    0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2, 0
};

static unsigned int k[64] = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
    0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
    0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
    0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
    0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
    0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
    0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
    0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
    0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
};

#pragma unsafe arrays
static void doChunk(unsigned int words[16], unsigned int hash[8]) {
    unsigned int w[64];
    int i;
    unsigned a, b, c, d, e, f, g, h;
    unsigned sigma0, sigma1, maj, t2, ch, t1;

    for(i = 0; i < 16; i++) {
        w[i] = byterev(words[i]);
    }
    for(; i < 64; i++) {
        sigma0 = rotr(w[i-15], 7) ^ rotr(w[i-15], 18) ^ shiftr(w[i-15], 3);
        sigma1 = rotr(w[i-2], 17) ^ rotr(w[i-2], 19) ^ shiftr(w[i-2], 10);
        w[i] = w[i-16] + sigma0 + w[i-7] + sigma1;
    }
    a = hash[0];
    b = hash[1];
    c = hash[2];
    d = hash[3];
    e = hash[4];
    f = hash[5];
    g = hash[6];
    h = hash[7];

#pragma loop unroll(8)
    for(i = 0; i < 64; i++) {
        sigma0 = rotr(a, 2) ^ rotr(a, 13) ^ rotr(a, 22);
        maj = (a & b) ^ (a & c) ^ (b & c);
        t2 = sigma0 + maj;
        sigma1 = rotr(e, 6) ^ rotr(e, 11) ^ rotr(e, 25);
        ch = (e & f) ^ ((~ e) & g);
        t1 = h + sigma1 + ch + k[i] + w[i];
        h = g;
        g = f;
        f = e;
        e = d + t1;
        d = c;
        c = b;
        b = a;
        a = t1 + t2;
    }
    hash[0] += a;
    hash[1] += b;
    hash[2] += c;
    hash[3] += d;
    hash[4] += e;
    hash[5] += f;
    hash[6] += g;
    hash[7] += h;
}
*/
static unsigned int blockCount = 0;
static unsigned int blockData[16];

extern void sha256Block(unsigned int h[8], unsigned int data[16]);

#pragma unsafe arrays
void sha256BlockBegin(unsigned int hash[8]) {
    hash[0] = 0x6a09e667;
    hash[1] = 0xbb67ae85;
    hash[2] = 0x3c6ef372;
    hash[3] = 0xa54ff53a;
    hash[4] = 0x510e527f;
    hash[5] = 0x9b05688c;
    hash[6] = 0x1f83d9ab;
    hash[7] = 0x5be0cd19;
    blockCount = 0;
}

// TODO (opt) if the arrays are aligned then it should copy word-by-word
#pragma unsafe arrays
void sha256BlockUpdate(unsigned int hash[8], unsigned char bytes[], int n) {
    for(int i = 0; i < n; i++) {
        (blockData, unsigned char[64])[(blockCount++)&63] = bytes[i];
        if ((blockCount&63) == 0) {
            sha256Block(hash, blockData);
        }
    }
}

// TODO (opt) zeros should be copied in per word
#pragma unsafe arrays
void sha256BlockEnd(unsigned int hash[8]) {
    int len = blockCount * 8;
    (blockData, unsigned char[64])[(blockCount++)&63] = 0x80;
    if ((blockCount&63) == 0) {
        sha256Block(hash, blockData);
    }
    blockCount &= 63;
    if (blockCount > 56) {
        while(blockCount < 64) {
            (blockData, unsigned char[64])[blockCount++] = 0;
        }
        sha256Block(hash, blockData);
        blockCount = 0;
    }
    while(blockCount < 56) {
        (blockData, unsigned char[64])[blockCount++] = 0;
    }
    blockData[14] = 0;
    blockData[15] = byterev(len);
    sha256Block(hash, blockData);
}

static int byteCnt;

void sha256Begin(streaming chanend c) {
    sinct(c);
    byteCnt = 0;
}

// TODO (opt) depending on the alignment byterevved words should be out.
#pragma unsafe arrays
void sha256Update(streaming chanend c, unsigned char bytes[], int n) {
    for(int i = 0; i < n; i++) {
        c <: bytes[i];
    }
    byteCnt += n;
}

// TODO (opt) depending on the alignment zeroes should be out.
#pragma unsafe arrays
void sha256End(streaming chanend c, unsigned int hash[8]) {
    int len = byteCnt * 8;
    c <: (unsigned char) 0x80;
    byteCnt++;
    byteCnt &= 63;
    if (byteCnt > 56) {
        while(byteCnt < 64) {
            c <: (unsigned char) 0;
            byteCnt++;
        }
        byteCnt = 0;
    }
    while(byteCnt < 56) {
        c <: (unsigned char) 0;
        byteCnt++;
    }
    c <: (unsigned int) 0;
    c <: (unsigned int) len;
    soutct(c, 3);
    for(int i = 0; i < 8; i++) {
        c :> hash[i];
    }
    sinct(c);
    byteCnt = 0;
}

void sha256Terminate(streaming chanend c) {
    sinct(c);
    soutct(c, 4);
}


