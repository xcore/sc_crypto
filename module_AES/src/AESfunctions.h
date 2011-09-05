// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

/*
 * Author: Suleiman Abu Kharmeh
 * Date: 19/November/2008
 *
 * The AES Encryption/Decryption prototypes.
 * This file is included from the AESincludes.h header file
 *	See AES.xc for a demonstration of how to use these functions.
 */
#ifndef AESfunctions_h

#define AESfunctions_h


#define BLOCKSIZE	128
#define KEYLENGTH	128

#define Nb			4				//the number of columns, always 4. If block size
                                    //was to change according to the original
                                    //specification, then this could be 4, 6, or 8
#define Nk			(KEYLENGTH/32)	//the number of 32-bit words comprising the
                                    //Cipher Key can be 4, 6, and 8 for a key length of
                                    //128, 192, 256 respectively
#define Nr			(Nk +6)			//the number of rounds, can be 10, 12, and 14
                                    //for key length of 128, 192, and 256 respectively


void _Encrypt(unsigned int plainText[], unsigned int w[], unsigned int cipherText[]);

/** This function encrypts a piece of plaintext into a piece of ciphertext,
 * given a key. All are supplied as arrays of integers.
 *
 * \param plainText  array of integers holding the input message
 * \param key        array of integers holding the key
 * \param cipherText array of integers where the encrypted message is stored
 **/
void Encrypt(unsigned int plainText[], unsigned int key[], unsigned int cipherText[]);

void _Decrypt(unsigned int cipherText[], unsigned int w[], unsigned int decipheredText[]);

/** This function encrypts a piece of plaintext into a piece of ciphertext,
 * given a key. All are supplied as arrays of integers.
 *
 * \param cipherText array of integers holding the encrypted input message
 * \param key        array of integers holding the key
 * \param plainText  array of integers where the decrypted message is stored
 **/
void Decrypt(unsigned int cipherText[], unsigned int key[], unsigned int decipheredText[]);


//this is the KeyExpansion functions...
void KeyExpansion(unsigned int key[], unsigned int w[]);
void InvKeyExpansion(unsigned int key[], unsigned int w[]);


#endif //ifndef AESfunctions_h

