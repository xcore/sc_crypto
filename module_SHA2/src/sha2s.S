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
    ldw r9, dp[N]   ;\
    byterev r9, r9  ;\
    stw r9, dp[N]   ;\
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

#define NW 12

    .globl doRoundS
    .linkset doRoundS.nstackwords, NW
    .globl doRoundS.nstackwords
    
doRoundS:   
    entsp NW
    stw   r4, sp[0]
    stw   r5, sp[1]
    stw   r6, sp[2]
    stw   r7, sp[3]
    stw   r8, sp[4]
    stw   r9, sp[5]
    stw   r10, sp[6]
    stw   dp, sp[7]
    stw   r0, sp[8]
    stw   cp, sp[9]

    set   dp, r1
    set   cp, r2
    
    ldw   r7, r0[7]
    ldw   r6, r0[6]
    ldw   r5, r0[5]
    ldw   r4, r0[4]
    ldw   r3, r0[3]
    ldw   r2, r0[2]
    ldw   r1, r0[1]
    ldw   r0, r0[0]
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

    ldw   r10, sp[8]
    ldw   r11, r10[7]
    add   r7, r7, r11
    stw   r7, r10[7]
    ldw   r11, r10[6]
    add   r6, r6, r11
    stw   r6, r10[6]
    ldw   r11, r10[5]
    add   r5, r5, r11
    stw   r5, r10[5]
    ldw   r11, r10[4]
    add   r4, r4, r11
    stw   r4, r10[4]
    ldw   r11, r10[3]
    add   r3, r3, r11
    stw   r3, r10[3]
    ldw   r11, r10[2]
    add   r2, r2, r11
    stw   r2, r10[2]
    ldw   r11, r10[1]
    add   r1, r1, r11
    stw   r1, r10[1]
    ldw   r11, r10[0]
    add   r0, r0, r11
    stw   r0, r10[0]
        
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
