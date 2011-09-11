// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

// Regenerate DecryptAsm.S using:
// m4 DecryptAsm.S.m4 > DecryptAsm.S
#include "AESConfig.h"

#ifdef AES_USE_ASSEMBLY

include(`loops.m4')dnl
// stack layout
// 9 : lr
// 8 : plainText
// 7 : cp_offset
// 6 : r10
// 5 : r9
// 4 : r8
// 3 : r7
// 2 : r6
// 1 : r5
// 0 : r4

#define plainText_offset 8

.globl AESDecryptBlock.nstackwords
.linkset AESDecryptBlock.nstackwords, 9
.globl AESDecryptBlock.maxthreads
.linkset AESDecryptBlock.maxthreads, 1
.globl AESDecryptBlock.maxtimers
.linkset AESDecryptBlock.maxtimers, 0
.globl AESDecryptBlock.maxchanends
.linkset AESDecryptBlock.maxchanends, 0
.globl AESDecryptBlock
.cc_top AESDecryptBlock.function, AESDecryptBlock
.align 4
AESDecryptBlock:
entsp 9
  stw r4, sp[0]
  stw r5, sp[1]
  stw r6, sp[2]
  stw r7, sp[3]
  stw r8, sp[4]
  stw r9, sp[5]
  stw r10, sp[6]
  stw cp, sp[7]

  set cp, r1

divert(-1)
define(`s1', `r6')
define(`s2', `r1')
define(`s3', `r2')
define(`s0', `r3')
define(`ls1', `r4')
define(`ls2', `r5')
define(`ls3', `r0')
divert(0)dnl

// laststate0 = cipherText[0];
  ldw s0, r0[0]
// laststate0 ^= dw[40];
  ldw r11, cp[40]
  xor s0, s0, r11
// laststate1 = cipherText[1];
  ldw ls1, r0[1]
// laststate1 ^= dw[41];
  ldw r11, cp[41]
  xor ls1, ls1, r11

  stw r2, sp[plainText_offset]

// Not yet live ls3, ls2

// Round 10
// state2 = T2Inv[(state0 << 8) >> 24];
  shl s2, s0, 8
  shr s2, s2, 24
  ldaw r9, dp[T2Inv]
  ldw s2, r9[s2]
// state3 = T3Inv[state0 >> 24];
  shr s3, s0, 24
  ldaw r10, dp[T3Inv]
  ldw s3, r10[s3]
// state1 = T1Inv[(state0 << 16) >> 24];
  shl s1, s0, 16
  shr s1, s1, 24
  ldaw r8, dp[T1Inv]
  ldw s1, r8[s1]
// state0 = T0Inv[(state0 << 24) >> 24];
  zext s0, 8
  ldaw r7, dp[T0Inv]
  ldw s0, r7[s0]

// state3 ^= T2Inv[(laststate1 << 8) >> 24];
  shl r11, ls1, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor s3, s3, r11
// state0 ^= T3Inv[laststate1 >> 24];
  shr r11, ls1, 24
  ldw r11, r10[r11]
  xor s0, s0, r11
// laststate2 = cipherText[2];
  ldw ls2, r0[2]
// Not yet live ls3
// state2 ^= T1Inv[(laststate1 << 16) >> 24];
  shl r11, ls1, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor s2, s2, r11
// laststate2 ^= cipherText[2];
  ldw r11, cp[42]
  xor ls2, ls2, r11
// state1 ^= T0Inv[(laststate1 << 24) >> 24];
  zext ls1, 8
  ldw ls1, r7[ls1]
  xor s1, s1, ls1

// Not yet live ls3
// Dead ls1

// state0 ^= T2Inv[(laststate2 << 8) >> 24];
  shl r11, ls2, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor s0, s0, r11
// state1 ^= T3Inv[laststate2 >> 24];
  shr r11, ls2, 24
  ldw r11, r10[r11]
  xor s1, s1, r11
// laststate3 = cipherText[3];
  ldw ls3, r0[3]
// Dead ls1
// state3 ^= T1Inv[(laststate2 << 16) >> 24];
  shl ls1, ls2, 16
  shr ls1, ls1, 24
  ldw ls1, r8[ls1]
  xor s3, s3, ls1
// laststate3 ^= cipherText[3];
  ldw r11, cp[43]
  xor ls3, ls3, r11
// state2 ^= T0Inv[(laststate2 << 24) >> 24];
  zext ls2, 8
  ldw ls2, r7[ls2]
  xor s2, s2, ls2

// Dead ls1, ls2

// state1 ^= T2Inv[(laststate3 << 8) >> 24];
  shl ls1, ls3, 8
  shr ls1, ls1, 24
  ldw ls1, r9[ls1]
  xor s1, s1, ls1
// state1 ^= dw[4*i-3];
  ldw r11, cp[37]
  xor s1, s1, r11
// state2 ^= T3Inv[laststate3 >> 24];
  shr ls2, ls3, 24
  ldw ls2, r10[ls2]
  xor s2, s2, ls2
// state2 ^= dw[4*i-2];
  ldw ls1, cp[38]
  xor s2, s2, ls1
// state0 ^= T1Inv[(laststate3 << 16) >> 24];
  shl r11, ls3, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor s0, s0, r11
// state0 ^= dw[4*i-4];
  ldw ls2, cp[36]
  xor s0, s0, ls2
// state3 ^= T0Inv[(laststate3 << 24) >> 24];
  zext ls3, 8
  ldw ls3, r7[ls3]
  xor s3, s3, ls3
// Dead ls1, ls2, ls3
// state3 ^= dw[4*i-1];
  ldw ls1, cp[39]
  xor s3, s3, ls1

divert(-1)
define(`ls1', `r6')
define(`ls2', `r1')
define(`ls3', `r2')
define(`s1', `r4')
define(`s2', `r5')
define(`s3', `r0')
divert(0)dnl

// r0 - state1 / laststate1
// r1 - state2 / laststate2
// r2 - state3 / laststate3
// r3 - state0
// r4 - laststate1 / state1
// r5 - laststate2 / state2
// r6 - laststate3 / state3
// r7 - T0Inv
// r8 - T1Inv
// r9 - T2Inv
// r10 - T3Inv
// r11 - tmp
forstep(`round', 9, 2, -1, 
`// Round round
// state2 = T2Inv[(state0 << 8) >> 24];
  shl s2, s0, 8
  shr s2, s2, 24
  ldw s2, r9[s2]
// state3 = T3Inv[state0 >> 24];
  shr s3, s0, 24
  ldw s3, r10[s3]
// state3 ^= T2Inv[(laststate1 << 8) >> 24];
  shl r11, ls1, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor s3, s3, r11
// state1 = T1Inv[(state0 << 16) >> 24];
  shl s1, s0, 16
  shr s1, s1, 24
  ldw s1, r8[s1]
// state0 = T0Inv[(state0 << 24) >> 24];
  zext s0, 8
  ldw s0, r7[s0]

// state0 ^= T3Inv[laststate1 >> 24];
  shr r11, ls1, 24
  ldw r11, r10[r11]
  xor s0, s0, r11
// state2 ^= T1Inv[(laststate1 << 16) >> 24];
  shl r11, ls1, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor s2, s2, r11
// state1 ^= T0Inv[(laststate1 << 24) >> 24];
  zext ls1, 8
  ldw ls1, r7[ls1]
  xor s1, s1, ls1

// Dead ls1

// state0 ^= T2Inv[(laststate2 << 8) >> 24];
  shl r11, ls2, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor s0, s0, r11
// state1 ^= T3Inv[laststate2 >> 24];
  shr ls1, ls2, 24
  ldw ls1, r10[ls1]
  xor s1, s1, ls1
// state3 ^= T1Inv[(laststate2 << 16) >> 24];
  shl r11, ls2, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor s3, s3, r11
// state2 ^= T0Inv[(laststate2 << 24) >> 24];
  zext ls2, 8
  ldw ls2, r7[ls2]
  xor s2, s2, ls2

// Dead ls1, ls2

// state1 ^= T2Inv[(laststate3 << 8) >> 24];
  shl ls1, ls3, 8
  shr ls1, ls1, 24
  ldw ls1, r9[ls1]
  xor s1, s1, ls1
// state1 ^= dw[4*i-3];
  ldw r11, cp[eval(4*round-3)]
  xor s1, s1, r11
// state2 ^= T3Inv[laststate3 >> 24];
  shr ls2, ls3, 24
  ldw ls2, r10[ls2]
  xor s2, s2, ls2
// state2 ^= dw[4*i-2];
  ldw ls1, cp[eval(4*round-2)]
  xor s2, s2, ls1
// state0 ^= T1Inv[(laststate3 << 16) >> 24];
  shl r11, ls3, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor s0, s0, r11
// state0 ^= dw[4*i-4];
  ldw ls2, cp[eval(4*round-4)]
  xor s0, s0, ls2
// state3 ^= T0Inv[(laststate3 << 24) >> 24];
  zext ls3, 8
  ldw ls3, r7[ls3]
  xor s3, s3, ls3
// Dead ls1, ls2, ls3
// state3 ^= dw[4*i-1];
  ldw ls1, cp[eval(4*round-1)]
  xor s3, s3, ls1

divert(-1)
ifelse(eval(round & 1), `0', 
`define(`ls1', `r6')
define(`ls2', `r1')
define(`ls3', `r2')
define(`s1', `r4')
define(`s2', `r5')
define(`s3', `r0')',
`define(`s1', `r6')
define(`s2', `r1')
define(`s3', `r2')
define(`ls1', `r4')
define(`ls2', `r5')
define(`ls3', `r0')')
divert(0)dnl
')

// round 1
// r0 - laststate1
// r1 - laststate2
// r2 - laststate3
// r3 - state0
// r4 - state1
// r5 - state2
// r6 - state3
// r7 - sBoxInv
// r8 - plainText
// r9 - 
// r10 - 
// r11 - tmp
  ldaw r7, dp[sBoxInv]

// plainText3 = sBoxInv[state0 >> 24] << 24;
  shr r9, s0, 24
  ld8u r9, r7[r9]
  shl s3, r9, 24
// plainText2 = sBoxInv[(state0 << 8) >> 24] << 16;
  shl r10, s0, 8
  shr r10, r10, 24
  ld8u r10, r7[r10]
  shl s2, r10, 16
// plainText1 = sBoxInv[(state0 << 16) >> 24] << 8;
  shl r11, s0, 16
  shr r11, r11, 24
  ld8u r11, r7[r11]
  shl s1, r11, 8
// plainText0 = sBoxInv[(state0 << 24) >> 24];
  zext s0, 8
  ld8u s0, r7[s0]

// plainText0 |= sBoxInv[state1 >> 24] << 24;
  shr r9, ls1, 24
  ld8u r9, r7[r9]
  shl r9, r9, 24
  or s0, s0, r9
// plainText3 |= sBoxInv[(state1 << 8) >> 24] << 16;
  shl r10, ls1, 8
  shr r10, r10, 24
  ld8u r10, r7[r10]
  shl r10, r10, 16
  or s3, s3, r10
// plainText2 |= sBoxInv[(state1 << 16) >> 24] << 8;
  shl r11, ls1, 16
  shr r11, r11, 24
  ld8u r11, r7[r11]
  shl r11, r11, 8
  or s2, s2, r11
// plainText1 |= sBoxInv[(state1 << 24) >> 24];
  zext ls1, 8
  ld8u ls1, r7[ls1]
  or s1, s1, ls1

// Dead ls1

// plainText1 |= sBoxInv[state2 >> 24] << 24;
  shr r9, ls2, 24
  ld8u r9, r7[r9]
  shl r9, r9, 24
  or s1, s1, r9
// plainText0 |= sBoxInv[(state2 << 8) >> 24] << 16;
  shl r10, ls2, 8
  ldw r8, sp[plainText_offset]
  shr r10, r10, 24
  ld8u r10, r7[r10]
  shl r10, r10, 16
  or s0, s0, r10
// plainText3 |= sBoxInv[(state2 << 16) >> 24] << 8;
  shl r11, ls2, 16
  shr r11, r11, 24
  ld8u r11, r7[r11]
  shl r11, r11, 8
  or s3, s3, r11
// plainText2 |= sBoxInv[(state2 << 24) >> 24];
  zext ls2, 8
  ld8u ls2, r7[ls2]
  or s2, s2, ls2

// Dead ls1, ls2

// plainText2 |= sBoxInv[state3 >> 24] << 24;
  shr ls1, ls3, 24
  ld8u ls1, r7[ls1]
  shl ls1, ls1, 24
  or s2, s2, ls1
// plainText[2] = plainText2 ^ dw[2];
  ldw r9, cp[2]
  xor s2, s2, r9
  stw s2, r8[2]
// plainText1 |= sBoxInv[(state3 << 8) >> 24] << 16;
  shl r10, ls3, 8
  shr r10, r10, 24
  ld8u r10, r7[r10]
  shl r10, r10, 16
  or s1, s1, r10
// plainText[1] = plainText1 ^ dw[1];
  ldw r11, cp[1]
  xor s1, s1, r11
  stw s1, r8[1]
// plainText0 |= sBoxInv[(state3 << 16) >> 24] << 8;
  shl ls2, ls3, 16
  ldw r10, sp[6]
  shr ls2, ls2, 24
  ld8u ls2, r7[ls2]
  shl ls2, ls2, 8
  or s0, s0, ls2
// plainText[0] = plainText0 ^ dw[0];
  ldw ls1, cp[0]
  xor s0, s0, ls1
  stw s0, r8[0]
// plainText3 |= sBoxInv[(state3 << 24) >> 24];
  zext ls3, 8
  ld8u ls3, r7[ls3]
  or s3, s3, ls3
// plainText[3] = plainText3 ^ dw[3];
  ldw r9, cp[3]
  xor s3, s3, r9
  stw s3, r8[3]

  ldw r4, sp[0]
  ldw r5, sp[1]
  ldw r6, sp[2]
  ldw r7, sp[3]
  ldw r8, sp[4]
  ldw r9, sp[5]
  ldw cp, sp[7]

  retsp 9
.cc_bottom AESDecryptBlock.function

#endif // AES_USE_ASSEMBLY
