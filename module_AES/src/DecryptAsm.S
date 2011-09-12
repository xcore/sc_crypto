// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

// Regenerate DecryptAsm.S using:
// m4 DecryptAsm.S.m4 > DecryptAsm.S
#include "AESConfig.h"

#ifdef AES_USE_ASSEMBLY

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


// laststate0 = cipherText[0];
  ldw r3, r0[0]
// laststate0 ^= dw[40];
  ldw r11, cp[40]
  xor r3, r3, r11
// laststate1 = cipherText[1];
  ldw r4, r0[1]
// laststate1 ^= dw[41];
  ldw r11, cp[41]
  xor r4, r4, r11

  stw r2, sp[plainText_offset]

// Not yet live r0, r5

// Round 10
// state2 = T2Inv[(state0 << 8) >> 24];
  shl r1, r3, 8
  shr r1, r1, 24
  ldaw r9, dp[T2Inv]
  ldw r1, r9[r1]
// state3 = T3Inv[state0 >> 24];
  shr r2, r3, 24
  ldaw r10, dp[T3Inv]
  ldw r2, r10[r2]
// state1 = T1Inv[(state0 << 16) >> 24];
  shl r6, r3, 16
  shr r6, r6, 24
  ldaw r8, dp[T1Inv]
  ldw r6, r8[r6]
// state0 = T0Inv[(state0 << 24) >> 24];
  zext r3, 8
  ldaw r7, dp[T0Inv]
  ldw r3, r7[r3]

// state3 ^= T2Inv[(laststate1 << 8) >> 24];
  shl r11, r4, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor r2, r2, r11
// state0 ^= T3Inv[laststate1 >> 24];
  shr r11, r4, 24
  ldw r11, r10[r11]
  xor r3, r3, r11
// laststate2 = cipherText[2];
  ldw r5, r0[2]
// Not yet live r0
// state2 ^= T1Inv[(laststate1 << 16) >> 24];
  shl r11, r4, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r1, r1, r11
// laststate2 ^= cipherText[2];
  ldw r11, cp[42]
  xor r5, r5, r11
// state1 ^= T0Inv[(laststate1 << 24) >> 24];
  zext r4, 8
  ldw r4, r7[r4]
  xor r6, r6, r4

// Not yet live r0
// Dead r4

// state0 ^= T2Inv[(laststate2 << 8) >> 24];
  shl r11, r5, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor r3, r3, r11
// state1 ^= T3Inv[laststate2 >> 24];
  shr r11, r5, 24
  ldw r11, r10[r11]
  xor r6, r6, r11
// laststate3 = cipherText[3];
  ldw r0, r0[3]
// Dead r4
// state3 ^= T1Inv[(laststate2 << 16) >> 24];
  shl r4, r5, 16
  shr r4, r4, 24
  ldw r4, r8[r4]
  xor r2, r2, r4
// laststate3 ^= cipherText[3];
  ldw r11, cp[43]
  xor r0, r0, r11
// state2 ^= T0Inv[(laststate2 << 24) >> 24];
  zext r5, 8
  ldw r5, r7[r5]
  xor r1, r1, r5

// Dead r4, r5

// state1 ^= T2Inv[(laststate3 << 8) >> 24];
  shl r4, r0, 8
  shr r4, r4, 24
  ldw r4, r9[r4]
  xor r6, r6, r4
// state1 ^= dw[4*i-3];
  ldw r11, cp[37]
  xor r6, r6, r11
// state2 ^= T3Inv[laststate3 >> 24];
  shr r5, r0, 24
  ldw r5, r10[r5]
  xor r1, r1, r5
// state2 ^= dw[4*i-2];
  ldw r4, cp[38]
  xor r1, r1, r4
// state0 ^= T1Inv[(laststate3 << 16) >> 24];
  shl r11, r0, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r3, r3, r11
// state0 ^= dw[4*i-4];
  ldw r5, cp[36]
  xor r3, r3, r5
// state3 ^= T0Inv[(laststate3 << 24) >> 24];
  zext r0, 8
  ldw r0, r7[r0]
  xor r2, r2, r0
// Dead r4, r5, r0
// state3 ^= dw[4*i-1];
  ldw r4, cp[39]
  xor r2, r2, r4


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
// Round 9
// state2 = T2Inv[(state0 << 8) >> 24];
  shl r5, r3, 8
  shr r5, r5, 24
  ldw r5, r9[r5]
// state3 = T3Inv[state0 >> 24];
  shr r0, r3, 24
  ldw r0, r10[r0]
// state3 ^= T2Inv[(laststate1 << 8) >> 24];
  shl r11, r6, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor r0, r0, r11
// state1 = T1Inv[(state0 << 16) >> 24];
  shl r4, r3, 16
  shr r4, r4, 24
  ldw r4, r8[r4]
// state0 = T0Inv[(state0 << 24) >> 24];
  zext r3, 8
  ldw r3, r7[r3]

// state0 ^= T3Inv[laststate1 >> 24];
  shr r11, r6, 24
  ldw r11, r10[r11]
  xor r3, r3, r11
// state2 ^= T1Inv[(laststate1 << 16) >> 24];
  shl r11, r6, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r5, r5, r11
// state1 ^= T0Inv[(laststate1 << 24) >> 24];
  zext r6, 8
  ldw r6, r7[r6]
  xor r4, r4, r6

// Dead r6

// state0 ^= T2Inv[(laststate2 << 8) >> 24];
  shl r11, r1, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor r3, r3, r11
// state1 ^= T3Inv[laststate2 >> 24];
  shr r6, r1, 24
  ldw r6, r10[r6]
  xor r4, r4, r6
// state3 ^= T1Inv[(laststate2 << 16) >> 24];
  shl r11, r1, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r0, r0, r11
// state2 ^= T0Inv[(laststate2 << 24) >> 24];
  zext r1, 8
  ldw r1, r7[r1]
  xor r5, r5, r1

// Dead r6, r1

// state1 ^= T2Inv[(laststate3 << 8) >> 24];
  shl r6, r2, 8
  shr r6, r6, 24
  ldw r6, r9[r6]
  xor r4, r4, r6
// state1 ^= dw[4*i-3];
  ldw r11, cp[33]
  xor r4, r4, r11
// state2 ^= T3Inv[laststate3 >> 24];
  shr r1, r2, 24
  ldw r1, r10[r1]
  xor r5, r5, r1
// state2 ^= dw[4*i-2];
  ldw r6, cp[34]
  xor r5, r5, r6
// state0 ^= T1Inv[(laststate3 << 16) >> 24];
  shl r11, r2, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r3, r3, r11
// state0 ^= dw[4*i-4];
  ldw r1, cp[32]
  xor r3, r3, r1
// state3 ^= T0Inv[(laststate3 << 24) >> 24];
  zext r2, 8
  ldw r2, r7[r2]
  xor r0, r0, r2
// Dead r6, r1, r2
// state3 ^= dw[4*i-1];
  ldw r6, cp[35]
  xor r0, r0, r6

// Round 8
// state2 = T2Inv[(state0 << 8) >> 24];
  shl r1, r3, 8
  shr r1, r1, 24
  ldw r1, r9[r1]
// state3 = T3Inv[state0 >> 24];
  shr r2, r3, 24
  ldw r2, r10[r2]
// state3 ^= T2Inv[(laststate1 << 8) >> 24];
  shl r11, r4, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor r2, r2, r11
// state1 = T1Inv[(state0 << 16) >> 24];
  shl r6, r3, 16
  shr r6, r6, 24
  ldw r6, r8[r6]
// state0 = T0Inv[(state0 << 24) >> 24];
  zext r3, 8
  ldw r3, r7[r3]

// state0 ^= T3Inv[laststate1 >> 24];
  shr r11, r4, 24
  ldw r11, r10[r11]
  xor r3, r3, r11
// state2 ^= T1Inv[(laststate1 << 16) >> 24];
  shl r11, r4, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r1, r1, r11
// state1 ^= T0Inv[(laststate1 << 24) >> 24];
  zext r4, 8
  ldw r4, r7[r4]
  xor r6, r6, r4

// Dead r4

// state0 ^= T2Inv[(laststate2 << 8) >> 24];
  shl r11, r5, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor r3, r3, r11
// state1 ^= T3Inv[laststate2 >> 24];
  shr r4, r5, 24
  ldw r4, r10[r4]
  xor r6, r6, r4
// state3 ^= T1Inv[(laststate2 << 16) >> 24];
  shl r11, r5, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r2, r2, r11
// state2 ^= T0Inv[(laststate2 << 24) >> 24];
  zext r5, 8
  ldw r5, r7[r5]
  xor r1, r1, r5

// Dead r4, r5

// state1 ^= T2Inv[(laststate3 << 8) >> 24];
  shl r4, r0, 8
  shr r4, r4, 24
  ldw r4, r9[r4]
  xor r6, r6, r4
// state1 ^= dw[4*i-3];
  ldw r11, cp[29]
  xor r6, r6, r11
// state2 ^= T3Inv[laststate3 >> 24];
  shr r5, r0, 24
  ldw r5, r10[r5]
  xor r1, r1, r5
// state2 ^= dw[4*i-2];
  ldw r4, cp[30]
  xor r1, r1, r4
// state0 ^= T1Inv[(laststate3 << 16) >> 24];
  shl r11, r0, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r3, r3, r11
// state0 ^= dw[4*i-4];
  ldw r5, cp[28]
  xor r3, r3, r5
// state3 ^= T0Inv[(laststate3 << 24) >> 24];
  zext r0, 8
  ldw r0, r7[r0]
  xor r2, r2, r0
// Dead r4, r5, r0
// state3 ^= dw[4*i-1];
  ldw r4, cp[31]
  xor r2, r2, r4

// Round 7
// state2 = T2Inv[(state0 << 8) >> 24];
  shl r5, r3, 8
  shr r5, r5, 24
  ldw r5, r9[r5]
// state3 = T3Inv[state0 >> 24];
  shr r0, r3, 24
  ldw r0, r10[r0]
// state3 ^= T2Inv[(laststate1 << 8) >> 24];
  shl r11, r6, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor r0, r0, r11
// state1 = T1Inv[(state0 << 16) >> 24];
  shl r4, r3, 16
  shr r4, r4, 24
  ldw r4, r8[r4]
// state0 = T0Inv[(state0 << 24) >> 24];
  zext r3, 8
  ldw r3, r7[r3]

// state0 ^= T3Inv[laststate1 >> 24];
  shr r11, r6, 24
  ldw r11, r10[r11]
  xor r3, r3, r11
// state2 ^= T1Inv[(laststate1 << 16) >> 24];
  shl r11, r6, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r5, r5, r11
// state1 ^= T0Inv[(laststate1 << 24) >> 24];
  zext r6, 8
  ldw r6, r7[r6]
  xor r4, r4, r6

// Dead r6

// state0 ^= T2Inv[(laststate2 << 8) >> 24];
  shl r11, r1, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor r3, r3, r11
// state1 ^= T3Inv[laststate2 >> 24];
  shr r6, r1, 24
  ldw r6, r10[r6]
  xor r4, r4, r6
// state3 ^= T1Inv[(laststate2 << 16) >> 24];
  shl r11, r1, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r0, r0, r11
// state2 ^= T0Inv[(laststate2 << 24) >> 24];
  zext r1, 8
  ldw r1, r7[r1]
  xor r5, r5, r1

// Dead r6, r1

// state1 ^= T2Inv[(laststate3 << 8) >> 24];
  shl r6, r2, 8
  shr r6, r6, 24
  ldw r6, r9[r6]
  xor r4, r4, r6
// state1 ^= dw[4*i-3];
  ldw r11, cp[25]
  xor r4, r4, r11
// state2 ^= T3Inv[laststate3 >> 24];
  shr r1, r2, 24
  ldw r1, r10[r1]
  xor r5, r5, r1
// state2 ^= dw[4*i-2];
  ldw r6, cp[26]
  xor r5, r5, r6
// state0 ^= T1Inv[(laststate3 << 16) >> 24];
  shl r11, r2, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r3, r3, r11
// state0 ^= dw[4*i-4];
  ldw r1, cp[24]
  xor r3, r3, r1
// state3 ^= T0Inv[(laststate3 << 24) >> 24];
  zext r2, 8
  ldw r2, r7[r2]
  xor r0, r0, r2
// Dead r6, r1, r2
// state3 ^= dw[4*i-1];
  ldw r6, cp[27]
  xor r0, r0, r6

// Round 6
// state2 = T2Inv[(state0 << 8) >> 24];
  shl r1, r3, 8
  shr r1, r1, 24
  ldw r1, r9[r1]
// state3 = T3Inv[state0 >> 24];
  shr r2, r3, 24
  ldw r2, r10[r2]
// state3 ^= T2Inv[(laststate1 << 8) >> 24];
  shl r11, r4, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor r2, r2, r11
// state1 = T1Inv[(state0 << 16) >> 24];
  shl r6, r3, 16
  shr r6, r6, 24
  ldw r6, r8[r6]
// state0 = T0Inv[(state0 << 24) >> 24];
  zext r3, 8
  ldw r3, r7[r3]

// state0 ^= T3Inv[laststate1 >> 24];
  shr r11, r4, 24
  ldw r11, r10[r11]
  xor r3, r3, r11
// state2 ^= T1Inv[(laststate1 << 16) >> 24];
  shl r11, r4, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r1, r1, r11
// state1 ^= T0Inv[(laststate1 << 24) >> 24];
  zext r4, 8
  ldw r4, r7[r4]
  xor r6, r6, r4

// Dead r4

// state0 ^= T2Inv[(laststate2 << 8) >> 24];
  shl r11, r5, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor r3, r3, r11
// state1 ^= T3Inv[laststate2 >> 24];
  shr r4, r5, 24
  ldw r4, r10[r4]
  xor r6, r6, r4
// state3 ^= T1Inv[(laststate2 << 16) >> 24];
  shl r11, r5, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r2, r2, r11
// state2 ^= T0Inv[(laststate2 << 24) >> 24];
  zext r5, 8
  ldw r5, r7[r5]
  xor r1, r1, r5

// Dead r4, r5

// state1 ^= T2Inv[(laststate3 << 8) >> 24];
  shl r4, r0, 8
  shr r4, r4, 24
  ldw r4, r9[r4]
  xor r6, r6, r4
// state1 ^= dw[4*i-3];
  ldw r11, cp[21]
  xor r6, r6, r11
// state2 ^= T3Inv[laststate3 >> 24];
  shr r5, r0, 24
  ldw r5, r10[r5]
  xor r1, r1, r5
// state2 ^= dw[4*i-2];
  ldw r4, cp[22]
  xor r1, r1, r4
// state0 ^= T1Inv[(laststate3 << 16) >> 24];
  shl r11, r0, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r3, r3, r11
// state0 ^= dw[4*i-4];
  ldw r5, cp[20]
  xor r3, r3, r5
// state3 ^= T0Inv[(laststate3 << 24) >> 24];
  zext r0, 8
  ldw r0, r7[r0]
  xor r2, r2, r0
// Dead r4, r5, r0
// state3 ^= dw[4*i-1];
  ldw r4, cp[23]
  xor r2, r2, r4

// Round 5
// state2 = T2Inv[(state0 << 8) >> 24];
  shl r5, r3, 8
  shr r5, r5, 24
  ldw r5, r9[r5]
// state3 = T3Inv[state0 >> 24];
  shr r0, r3, 24
  ldw r0, r10[r0]
// state3 ^= T2Inv[(laststate1 << 8) >> 24];
  shl r11, r6, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor r0, r0, r11
// state1 = T1Inv[(state0 << 16) >> 24];
  shl r4, r3, 16
  shr r4, r4, 24
  ldw r4, r8[r4]
// state0 = T0Inv[(state0 << 24) >> 24];
  zext r3, 8
  ldw r3, r7[r3]

// state0 ^= T3Inv[laststate1 >> 24];
  shr r11, r6, 24
  ldw r11, r10[r11]
  xor r3, r3, r11
// state2 ^= T1Inv[(laststate1 << 16) >> 24];
  shl r11, r6, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r5, r5, r11
// state1 ^= T0Inv[(laststate1 << 24) >> 24];
  zext r6, 8
  ldw r6, r7[r6]
  xor r4, r4, r6

// Dead r6

// state0 ^= T2Inv[(laststate2 << 8) >> 24];
  shl r11, r1, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor r3, r3, r11
// state1 ^= T3Inv[laststate2 >> 24];
  shr r6, r1, 24
  ldw r6, r10[r6]
  xor r4, r4, r6
// state3 ^= T1Inv[(laststate2 << 16) >> 24];
  shl r11, r1, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r0, r0, r11
// state2 ^= T0Inv[(laststate2 << 24) >> 24];
  zext r1, 8
  ldw r1, r7[r1]
  xor r5, r5, r1

// Dead r6, r1

// state1 ^= T2Inv[(laststate3 << 8) >> 24];
  shl r6, r2, 8
  shr r6, r6, 24
  ldw r6, r9[r6]
  xor r4, r4, r6
// state1 ^= dw[4*i-3];
  ldw r11, cp[17]
  xor r4, r4, r11
// state2 ^= T3Inv[laststate3 >> 24];
  shr r1, r2, 24
  ldw r1, r10[r1]
  xor r5, r5, r1
// state2 ^= dw[4*i-2];
  ldw r6, cp[18]
  xor r5, r5, r6
// state0 ^= T1Inv[(laststate3 << 16) >> 24];
  shl r11, r2, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r3, r3, r11
// state0 ^= dw[4*i-4];
  ldw r1, cp[16]
  xor r3, r3, r1
// state3 ^= T0Inv[(laststate3 << 24) >> 24];
  zext r2, 8
  ldw r2, r7[r2]
  xor r0, r0, r2
// Dead r6, r1, r2
// state3 ^= dw[4*i-1];
  ldw r6, cp[19]
  xor r0, r0, r6

// Round 4
// state2 = T2Inv[(state0 << 8) >> 24];
  shl r1, r3, 8
  shr r1, r1, 24
  ldw r1, r9[r1]
// state3 = T3Inv[state0 >> 24];
  shr r2, r3, 24
  ldw r2, r10[r2]
// state3 ^= T2Inv[(laststate1 << 8) >> 24];
  shl r11, r4, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor r2, r2, r11
// state1 = T1Inv[(state0 << 16) >> 24];
  shl r6, r3, 16
  shr r6, r6, 24
  ldw r6, r8[r6]
// state0 = T0Inv[(state0 << 24) >> 24];
  zext r3, 8
  ldw r3, r7[r3]

// state0 ^= T3Inv[laststate1 >> 24];
  shr r11, r4, 24
  ldw r11, r10[r11]
  xor r3, r3, r11
// state2 ^= T1Inv[(laststate1 << 16) >> 24];
  shl r11, r4, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r1, r1, r11
// state1 ^= T0Inv[(laststate1 << 24) >> 24];
  zext r4, 8
  ldw r4, r7[r4]
  xor r6, r6, r4

// Dead r4

// state0 ^= T2Inv[(laststate2 << 8) >> 24];
  shl r11, r5, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor r3, r3, r11
// state1 ^= T3Inv[laststate2 >> 24];
  shr r4, r5, 24
  ldw r4, r10[r4]
  xor r6, r6, r4
// state3 ^= T1Inv[(laststate2 << 16) >> 24];
  shl r11, r5, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r2, r2, r11
// state2 ^= T0Inv[(laststate2 << 24) >> 24];
  zext r5, 8
  ldw r5, r7[r5]
  xor r1, r1, r5

// Dead r4, r5

// state1 ^= T2Inv[(laststate3 << 8) >> 24];
  shl r4, r0, 8
  shr r4, r4, 24
  ldw r4, r9[r4]
  xor r6, r6, r4
// state1 ^= dw[4*i-3];
  ldw r11, cp[13]
  xor r6, r6, r11
// state2 ^= T3Inv[laststate3 >> 24];
  shr r5, r0, 24
  ldw r5, r10[r5]
  xor r1, r1, r5
// state2 ^= dw[4*i-2];
  ldw r4, cp[14]
  xor r1, r1, r4
// state0 ^= T1Inv[(laststate3 << 16) >> 24];
  shl r11, r0, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r3, r3, r11
// state0 ^= dw[4*i-4];
  ldw r5, cp[12]
  xor r3, r3, r5
// state3 ^= T0Inv[(laststate3 << 24) >> 24];
  zext r0, 8
  ldw r0, r7[r0]
  xor r2, r2, r0
// Dead r4, r5, r0
// state3 ^= dw[4*i-1];
  ldw r4, cp[15]
  xor r2, r2, r4

// Round 3
// state2 = T2Inv[(state0 << 8) >> 24];
  shl r5, r3, 8
  shr r5, r5, 24
  ldw r5, r9[r5]
// state3 = T3Inv[state0 >> 24];
  shr r0, r3, 24
  ldw r0, r10[r0]
// state3 ^= T2Inv[(laststate1 << 8) >> 24];
  shl r11, r6, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor r0, r0, r11
// state1 = T1Inv[(state0 << 16) >> 24];
  shl r4, r3, 16
  shr r4, r4, 24
  ldw r4, r8[r4]
// state0 = T0Inv[(state0 << 24) >> 24];
  zext r3, 8
  ldw r3, r7[r3]

// state0 ^= T3Inv[laststate1 >> 24];
  shr r11, r6, 24
  ldw r11, r10[r11]
  xor r3, r3, r11
// state2 ^= T1Inv[(laststate1 << 16) >> 24];
  shl r11, r6, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r5, r5, r11
// state1 ^= T0Inv[(laststate1 << 24) >> 24];
  zext r6, 8
  ldw r6, r7[r6]
  xor r4, r4, r6

// Dead r6

// state0 ^= T2Inv[(laststate2 << 8) >> 24];
  shl r11, r1, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor r3, r3, r11
// state1 ^= T3Inv[laststate2 >> 24];
  shr r6, r1, 24
  ldw r6, r10[r6]
  xor r4, r4, r6
// state3 ^= T1Inv[(laststate2 << 16) >> 24];
  shl r11, r1, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r0, r0, r11
// state2 ^= T0Inv[(laststate2 << 24) >> 24];
  zext r1, 8
  ldw r1, r7[r1]
  xor r5, r5, r1

// Dead r6, r1

// state1 ^= T2Inv[(laststate3 << 8) >> 24];
  shl r6, r2, 8
  shr r6, r6, 24
  ldw r6, r9[r6]
  xor r4, r4, r6
// state1 ^= dw[4*i-3];
  ldw r11, cp[9]
  xor r4, r4, r11
// state2 ^= T3Inv[laststate3 >> 24];
  shr r1, r2, 24
  ldw r1, r10[r1]
  xor r5, r5, r1
// state2 ^= dw[4*i-2];
  ldw r6, cp[10]
  xor r5, r5, r6
// state0 ^= T1Inv[(laststate3 << 16) >> 24];
  shl r11, r2, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r3, r3, r11
// state0 ^= dw[4*i-4];
  ldw r1, cp[8]
  xor r3, r3, r1
// state3 ^= T0Inv[(laststate3 << 24) >> 24];
  zext r2, 8
  ldw r2, r7[r2]
  xor r0, r0, r2
// Dead r6, r1, r2
// state3 ^= dw[4*i-1];
  ldw r6, cp[11]
  xor r0, r0, r6

// Round 2
// state2 = T2Inv[(state0 << 8) >> 24];
  shl r1, r3, 8
  shr r1, r1, 24
  ldw r1, r9[r1]
// state3 = T3Inv[state0 >> 24];
  shr r2, r3, 24
  ldw r2, r10[r2]
// state3 ^= T2Inv[(laststate1 << 8) >> 24];
  shl r11, r4, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor r2, r2, r11
// state1 = T1Inv[(state0 << 16) >> 24];
  shl r6, r3, 16
  shr r6, r6, 24
  ldw r6, r8[r6]
// state0 = T0Inv[(state0 << 24) >> 24];
  zext r3, 8
  ldw r3, r7[r3]

// state0 ^= T3Inv[laststate1 >> 24];
  shr r11, r4, 24
  ldw r11, r10[r11]
  xor r3, r3, r11
// state2 ^= T1Inv[(laststate1 << 16) >> 24];
  shl r11, r4, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r1, r1, r11
// state1 ^= T0Inv[(laststate1 << 24) >> 24];
  zext r4, 8
  ldw r4, r7[r4]
  xor r6, r6, r4

// Dead r4

// state0 ^= T2Inv[(laststate2 << 8) >> 24];
  shl r11, r5, 8
  shr r11, r11, 24
  ldw r11, r9[r11]
  xor r3, r3, r11
// state1 ^= T3Inv[laststate2 >> 24];
  shr r4, r5, 24
  ldw r4, r10[r4]
  xor r6, r6, r4
// state3 ^= T1Inv[(laststate2 << 16) >> 24];
  shl r11, r5, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r2, r2, r11
// state2 ^= T0Inv[(laststate2 << 24) >> 24];
  zext r5, 8
  ldw r5, r7[r5]
  xor r1, r1, r5

// Dead r4, r5

// state1 ^= T2Inv[(laststate3 << 8) >> 24];
  shl r4, r0, 8
  shr r4, r4, 24
  ldw r4, r9[r4]
  xor r6, r6, r4
// state1 ^= dw[4*i-3];
  ldw r11, cp[5]
  xor r6, r6, r11
// state2 ^= T3Inv[laststate3 >> 24];
  shr r5, r0, 24
  ldw r5, r10[r5]
  xor r1, r1, r5
// state2 ^= dw[4*i-2];
  ldw r4, cp[6]
  xor r1, r1, r4
// state0 ^= T1Inv[(laststate3 << 16) >> 24];
  shl r11, r0, 16
  shr r11, r11, 24
  ldw r11, r8[r11]
  xor r3, r3, r11
// state0 ^= dw[4*i-4];
  ldw r5, cp[4]
  xor r3, r3, r5
// state3 ^= T0Inv[(laststate3 << 24) >> 24];
  zext r0, 8
  ldw r0, r7[r0]
  xor r2, r2, r0
// Dead r4, r5, r0
// state3 ^= dw[4*i-1];
  ldw r4, cp[7]
  xor r2, r2, r4



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
  shr r9, r3, 24
  ld8u r9, r7[r9]
  shl r0, r9, 24
// plainText2 = sBoxInv[(state0 << 8) >> 24] << 16;
  shl r10, r3, 8
  shr r10, r10, 24
  ld8u r10, r7[r10]
  shl r5, r10, 16
// plainText1 = sBoxInv[(state0 << 16) >> 24] << 8;
  shl r11, r3, 16
  shr r11, r11, 24
  ld8u r11, r7[r11]
  shl r4, r11, 8
// plainText0 = sBoxInv[(state0 << 24) >> 24];
  zext r3, 8
  ld8u r3, r7[r3]

// plainText0 |= sBoxInv[state1 >> 24] << 24;
  shr r9, r6, 24
  ld8u r9, r7[r9]
  shl r9, r9, 24
  or r3, r3, r9
// plainText3 |= sBoxInv[(state1 << 8) >> 24] << 16;
  shl r10, r6, 8
  shr r10, r10, 24
  ld8u r10, r7[r10]
  shl r10, r10, 16
  or r0, r0, r10
// plainText2 |= sBoxInv[(state1 << 16) >> 24] << 8;
  shl r11, r6, 16
  shr r11, r11, 24
  ld8u r11, r7[r11]
  shl r11, r11, 8
  or r5, r5, r11
// plainText1 |= sBoxInv[(state1 << 24) >> 24];
  zext r6, 8
  ld8u r6, r7[r6]
  or r4, r4, r6

// Dead r6

// plainText1 |= sBoxInv[state2 >> 24] << 24;
  shr r9, r1, 24
  ld8u r9, r7[r9]
  shl r9, r9, 24
  or r4, r4, r9
// plainText0 |= sBoxInv[(state2 << 8) >> 24] << 16;
  shl r10, r1, 8
  ldw r8, sp[plainText_offset]
  shr r10, r10, 24
  ld8u r10, r7[r10]
  shl r10, r10, 16
  or r3, r3, r10
// plainText3 |= sBoxInv[(state2 << 16) >> 24] << 8;
  shl r11, r1, 16
  shr r11, r11, 24
  ld8u r11, r7[r11]
  shl r11, r11, 8
  or r0, r0, r11
// plainText2 |= sBoxInv[(state2 << 24) >> 24];
  zext r1, 8
  ld8u r1, r7[r1]
  or r5, r5, r1

// Dead r6, r1

// plainText2 |= sBoxInv[state3 >> 24] << 24;
  shr r6, r2, 24
  ld8u r6, r7[r6]
  shl r6, r6, 24
  or r5, r5, r6
// plainText[2] = plainText2 ^ dw[2];
  ldw r9, cp[2]
  xor r5, r5, r9
  stw r5, r8[2]
// plainText1 |= sBoxInv[(state3 << 8) >> 24] << 16;
  shl r10, r2, 8
  shr r10, r10, 24
  ld8u r10, r7[r10]
  shl r10, r10, 16
  or r4, r4, r10
// plainText[1] = plainText1 ^ dw[1];
  ldw r11, cp[1]
  xor r4, r4, r11
  stw r4, r8[1]
// plainText0 |= sBoxInv[(state3 << 16) >> 24] << 8;
  shl r1, r2, 16
  ldw r10, sp[6]
  shr r1, r1, 24
  ld8u r1, r7[r1]
  shl r1, r1, 8
  or r3, r3, r1
// plainText[0] = plainText0 ^ dw[0];
  ldw r6, cp[0]
  xor r3, r3, r6
  stw r3, r8[0]
// plainText3 |= sBoxInv[(state3 << 24) >> 24];
  zext r2, 8
  ld8u r2, r7[r2]
  or r0, r0, r2
// plainText[3] = plainText3 ^ dw[3];
  ldw r9, cp[3]
  xor r0, r0, r9
  stw r0, r8[3]

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
