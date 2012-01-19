/* Copyright (C) 2009 XMOS Ltd */

/** 
 * Functions implementing decryption using AES-128 in Ciper Block Chaining Mode
 * (CBC).
 */

#ifndef _cbc_h_
#define _cbc_h_

#include "AESfunctions.h"

#define CBCDecryptInit() DecryptInit()

struct CBCDecryptState {
  unsigned w[Nb * (Nr + 1)];
  unsigned IV[Nb];
};

/**
 * Initialise CBCDecryptState using a key an initialisation vector.
 */
void CBCDecryptStateInit(struct CBCDecryptState *state, const unsigned key[Nk],
                         const unsigned IV[Nb]);

/**
 * Reset a CBC state to allow decryption of a new stream. The key
 * is not reset.
 */
void CBCDecryptStateReset(struct CBCDecryptState *state, const unsigned IV[Nb]);

/**
 * Incrementally decrypt data using CBC. Decryption is performed in place. The
 * length of the data to be decrypted must be a multiple of the block size.
 */
void CBCDecryptUpdate(struct CBCDecryptState *state, unsigned input[],
                      unsigned length);

/**
 * One shot CBC Decrypt. Decryption is performed in place. The length of the
 * data to be decrypted must be a multiple of the block size.
 */
void CBCDecrypt(const unsigned key[Nk], const unsigned IV[Nb], unsigned input[],
                unsigned length);

#endif /* _cbc_h_ */
