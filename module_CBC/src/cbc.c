/* Copyright (C) 2009 XMOS Ltd */

#include "cbc.h"

static void
CopyBlock(unsigned dst[Nb], const unsigned src[Nb])
{
  dst[0] = src[0];
  dst[1] = src[1];
  dst[2] = src[2];
  dst[3] = src[3];
}

/**
 * XOR two 128bit blocks.
 */
static void
XOR_128(const unsigned a[4], const unsigned b[4], unsigned out[4])
{
  out[0] = a[0] ^ b[0];
  out[1] = a[1] ^ b[1];
  out[2] = a[2] ^ b[2];
  out[3] = a[3] ^ b[3];
}

void CBCDecryptStateInit(struct CBCDecryptState *state, const unsigned key[Nk],
                         const unsigned IV[Nb])
{
  AESDecryptExpandKey(key, state->w);
  CopyBlock(state->IV, IV);
}

void CBCDecryptStateReset(struct CBCDecryptState *state, const unsigned IV[Nb])
{
  CopyBlock(state->IV, IV);
}

void CBCDecryptUpdate(struct CBCDecryptState *state, unsigned input[],
                      unsigned length)
{
  unsigned tmp1[Nb], tmp2[Nb];

  /* Ciphertext must be a multiple of the block length. */
  if (length % Nb) {
    __builtin_trap();
  }
  
  for (unsigned n = 0; n < length / Nb; n++) {
    CopyBlock(tmp2, &input[n<<2]);
    AESDecryptBlock(&input[n<<2], state->w, tmp1);
    XOR_128(state->IV, tmp1, &input[n<<2]);
    CopyBlock(state->IV, tmp2);
  }
}

void
CBCDecrypt(const unsigned key[Nk], const unsigned IV[Nb], unsigned input[],
           unsigned length)
{
  struct CBCDecryptState state;
  
  CBCDecryptStateInit(&state, key, IV);
  CBCDecryptUpdate(&state, input, length);
}
