/*
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

*/




#define ROUNDFIRST(R0,R1,R2,R3,R4,R5,R6,R7,N) \
    shr r8, R4, 6   ;\
    ldc r9, 26   ;\
    shl r9, R4, r9   ;\
    or  r11, r8, r9   ;\
    ldc r8, 11   ;\
    shr r8, R4, r8   ;\
    ldc r9, 21   ;\
    shl r9, R4, r9   ;\
    or  r8, r8, r9   ;\
    xor r11, r11, r8   ;\
    ldc r8, 25   ;\
    shr r8, R4, r8   ;\
    shl r9, R4, 7   ;\
    or  r8, r8, r9   ;\
    xor r11, r11, r8   ;\
    add R7, R7, r11   ;/* r8, r9, r10, r11 dead*/ \
    ldw r8, cp[N]   ;\
    add R7, R7, r8   ;\
    ldw r9, dp[N]   /* byterev r9, r9 ; stw r9, dp[N]  */ ;\
    add R7, R7, r9            /* r8, r9, r10, r11 dead*/   ;\
    and r8, R4, R5   ;\
    not r9, R4   ;\
    and r9, r9, R6   ;\
    xor r8, r8, r9   ;\
    add R7, R7, r8           /* R7: t1; r8, r9, r10, r11 dead*/   ;\
    add R3, R3, R7           /* R3: e'*/   ;\
    shr r8, R0, 2   ;\
    ldc r9, 30   ;\
    shl r9, R0, r9   ;\
    or  r11, r8, r9   ;\
    ldc r8, 13   ;\
    shr r8, R0, r8   ;\
    ldc r9, 19   ;\
    shl r9, R0, r9   ;\
    or  r8, r8, r9   ;\
    xor r11, r11, r8   ;\
    ldc r8, 22   ;\
    shr r8, R0, r8   ;\
    ldc r9, 10   ;\
    shl r9, R0, r9   ;\
    or  r8, r8, r9   ;\
    xor r11, r11, r8         /* r8, r9, r10 dead  */ ;\
    and r8, R0, R1   ;\
    and r9, R0, R2   ;\
    xor r8, r8, r9   ;\
    and r9, R1, R2   ;\
    xor r8, r8, r9   ;\
    add r11, r11, r8   ;\
    add R7, r11, R7

#define ROUND(R0,R1,R2,R3,R4,R5,R6,R7,N) \
    shr r8, R4, 6   ;\
    ldc r9, 26   ;\
    shl r9, R4, r9   ;\
    or  r11, r8, r9   ;\
    ldc r8, 11   ;\
    shr r8, R4, r8   ;\
    ldc r9, 21   ;\
    shl r9, R4, r9   ;\
    or  r8, r8, r9   ;\
    xor r11, r11, r8   ;\
    ldc r8, 25   ;\
    shr r8, R4, r8   ;\
    shl r9, R4, 7   ;\
    or  r8, r8, r9   ;\
    xor r11, r11, r8   ;\
    add R7, R7, r11   ;/* r8, r9, r10, r11 dead*/ \
    ldw r8, cp[N-16]   ;\
    add R7, R7, r8   ;\
    ldw r10, dp[(N-15)&15] /**********/  ;\
    shr r8, r10, 7   ;\
    ldc r9, 25   ;\
    shl r9, r10, r9   ;\
    or  r11, r8, r9   ;\
    ldc r8, 18   ;\
    shr r8, r10, r8   ;\
    ldc r9, 14   ;\
    shl r9, r10, r9   ;\
    or  r8, r8, r9   ;\
    xor r11, r11, r8   ;\
    shr r8, r10, 3   ;\
    xor r11, r11, r8   ;\
    ldw r10, dp[(N-2)&15]  /**********/ ;\
    ldc r8, 17   ;\
    shr r8, r10, r8   ;\
    ldc r9, 15   ;\
    shl r9, r10, r9   ;\
    or  r9, r8, r9   ;\
    ldc r8, 19   ;\
    shr r8, r10, r8   ;\
    xor r9, r9, r8    ;\
    ldc r8, 13   ;\
    shl r8, r10, r8   ;\
    xor r9, r8, r9   ;\
    ldc r8, 10   ;\
    shr r8, r10, r8   ;\
    xor r9, r9, r8   ;\
    add r11, r11, r9    ;\
    ldw r10, dp[(N-16)&15]   ;\
    add r11, r11, r10   ;\
    ldw r10, dp[(N-7)&15]   ;\
    add r11, r11, r10   ;\
    stw r11, dp[(N)&15] /**********/  ;\
    add R7, R7, r11            /* r8, r9, r10, r11 dead*/   ;\
    and r8, R4, R5   ;\
    not r9, R4   ;\
    and r9, r9, R6   ;\
    xor r8, r8, r9   ;\
    add R7, R7, r8           /* R7: t1; r8, r9, r10, r11 dead*/   ;\
    add R3, R3, R7           /* R3: e'*/   ;\
    shr r8, R0, 2   ;\
    ldc r9, 30   ;\
    shl r9, R0, r9   ;\
    or  r11, r8, r9   ;\
    ldc r8, 13   ;\
    shr r8, R0, r8   ;\
    ldc r9, 19   ;\
    shl r9, R0, r9   ;\
    or  r8, r8, r9   ;\
    xor r11, r11, r8   ;\
    ldc r8, 22   ;\
    shr r8, R0, r8   ;\
    ldc r9, 10   ;\
    shl r9, R0, r9   ;\
    or  r8, r8, r9   ;\
    xor r11, r11, r8         /* r8, r9, r10 dead  */ ;\
    and r8, R0, R1   ;\
    and r9, R0, R2   ;\
    xor r8, r8, r9   ;\
    and r9, R1, R2   ;\
    xor r8, r8, r9   ;\
    add r11, r11, r8   ;\
    add R7, r11, R7

#define NW (36)
    
    .cc_top sha256Process.func, sha256Process
    
    .globl sha256Process
    .linkset sha256Process.nstackwords, NW
    .globl sha256Process.nstackwords

    .align 4
roundconstants: 
    .word 0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5
    .word 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5
    .word 0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3
    .word 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174, 0 // marker after 16
    .word 0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc
    .word 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da
    .word 0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7
    .word 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967
    .word 0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13
    .word 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85
    .word 0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3
    .word 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070
    .word 0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5
    .word 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3
    .word 0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208
    .word 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2, 0 //marker after 64

initialhash:    
    .word 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a
    .word 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19
    
sha256Process:   
    entsp NW
    stw   r4, sp[0]
    stw   r5, sp[1]
    stw   r6, sp[2]
    stw   r7, sp[3]
    stw   r8, sp[4]
    stw   r9, sp[5]
    stw   r10, sp[6]
    stw   dp, sp[7]
    stw   r0, sp[10]
    stw   cp, sp[9]

nextDigest:                // Create an initial hash
    ldap  r11, initialhash
    ldw   r7, r11[7]
    ldw   r6, r11[6]
    ldw   r5, r11[5]
    ldw   r4, r11[4]
    ldw   r3, r11[3]
    ldw   r2, r11[2]
    ldw   r1, r11[1]
    ldw   r0, r11[0]

    ldw   r10, sp[10]
    outct res[r10], 1      // signal that we are ready

nextBlock:                 // First save the hash
    ldap  r11, roundconstants
    set   cp, r11
    
    stw   r7, sp[34]
    stw   r6, sp[33]
    stw   r5, sp[32]
    stw   r4, sp[31]
    stw   r3, sp[30]
    stw   r2, sp[29]
    stw   r1, sp[28]
    stw   r0, sp[27]

    ldaw  dp, sp[11]
    ldc   r9, 8            // Now read 16 words
    ldw   r10, sp[10]
    testct r11, res[r10]
    bt    r11, output
readnextword:
    in    r11, res[r10]
    stw   r11, dp[0]
    in    r11, res[r10]
    stw   r11, dp[1]
    ldaw  dp, dp[2]
    sub   r9, r9, 1
    bt    r9, readnextword

    extdp 16

loop:   
    ROUNDFIRST(r0,r1,r2,r3,r4,r5,r6,r7,0)
    ROUNDFIRST(r7,r0,r1,r2,r3,r4,r5,r6,1)
    ROUNDFIRST(r6,r7,r0,r1,r2,r3,r4,r5,2)
    ROUNDFIRST(r5,r6,r7,r0,r1,r2,r3,r4,3)
    ROUNDFIRST(r4,r5,r6,r7,r0,r1,r2,r3,4)
    ROUNDFIRST(r3,r4,r5,r6,r7,r0,r1,r2,5)
    ROUNDFIRST(r2,r3,r4,r5,r6,r7,r0,r1,6)
    ROUNDFIRST(r1,r2,r3,r4,r5,r6,r7,r0,7)
    ldaw dp, dp[8]
    ldaw r11, cp[8]
    set  cp, r11
    ldw  r11, cp[0]
    bt   r11, loop

    extdp 16
    ldaw  r11, cp[1]
    set   cp, r11
    
loop2:   
    ROUND(r0,r1,r2,r3,r4,r5,r6,r7,16)
    ROUND(r7,r0,r1,r2,r3,r4,r5,r6,17)
    ROUND(r6,r7,r0,r1,r2,r3,r4,r5,18)
    ROUND(r5,r6,r7,r0,r1,r2,r3,r4,19)
    ROUND(r4,r5,r6,r7,r0,r1,r2,r3,20)
    ROUND(r3,r4,r5,r6,r7,r0,r1,r2,21)
    ROUND(r2,r3,r4,r5,r6,r7,r0,r1,22)
    ROUND(r1,r2,r3,r4,r5,r6,r7,r0,23)
    ROUND(r0,r1,r2,r3,r4,r5,r6,r7,24)
    ROUND(r7,r0,r1,r2,r3,r4,r5,r6,25)
    ROUND(r6,r7,r0,r1,r2,r3,r4,r5,26)
    ROUND(r5,r6,r7,r0,r1,r2,r3,r4,27)
    ROUND(r4,r5,r6,r7,r0,r1,r2,r3,28)
    ROUND(r3,r4,r5,r6,r7,r0,r1,r2,29)
    ROUND(r2,r3,r4,r5,r6,r7,r0,r1,30)
    ROUND(r1,r2,r3,r4,r5,r6,r7,r0,31)
    ldaw r11, cp[16]
    set  cp, r11
    ldw  r11, cp[0]
    bt   r11, loop2

    ldaw  r11, cp[1]
    set   cp, r11
    ldw   r11, sp[34]
    add   r7, r7, r11
    ldw   r11, sp[33]
    add   r6, r6, r11
    ldw   r11, sp[32]
    add   r5, r5, r11
    ldw   r11, sp[31]
    add   r4, r4, r11
    ldw   r11, sp[30]
    add   r3, r3, r11
    ldw   r11, sp[29]
    add   r2, r2, r11
    ldw   r11, sp[28]
    add   r1, r1, r11
    ldw   r11, sp[27]
    add   r0, r0, r11

    bu nextBlock
    
output:
    inct  r11, res[r10]
    eq    r11, r11, 4
    bt    r11, doReturn
    
    out   res[r10], r0
    out   res[r10], r1
    out   res[r10], r2
    out   res[r10], r3
    out   res[r10], r4
    out   res[r10], r5
    out   res[r10], r6
    out   res[r10], r7
    outct res[r10], 1
    bu    nextDigest
    
doReturn:   
    ldw   r4, sp[0]
    ldw   r5, sp[1]
    ldw   r6, sp[2]
    ldw   r7, sp[3]
    ldw   r8, sp[4]
    ldw   r9, sp[5]
    ldw   r10, sp[6]
    ldw   dp, sp[7]
    ldw   cp, sp[9]
    retsp NW

    .cc_bottom sha256Process.func
    