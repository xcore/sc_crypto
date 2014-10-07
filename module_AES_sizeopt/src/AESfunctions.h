// Copyright (c) 2011-2014, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>

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


void DecryptInit(void);


/** This function encrypts a block of plaintext into a block of ciphertext,
 * given an expanded key. Use AESEncryptExpandKey() to expand a 128-bit key.
 * All are supplied as arrays of integers.
 *
 * \param plainText  array of integers holding the input message
 * \param expanded   array of integers holding the expanded key
 * \param cipherText array of integers where the encrypted message is stored
 *
 * \sa AESEncryptExpandKey
 **/
void AESEncryptBlock(unsigned int plainText[], unsigned int expanded[], unsigned int cipherText[]);

/** This function expands a 128-bit key into a format suitable for efficient encryption
 * The output array needs to be at least 44 (that is Nb*(Nr+1)) words long
 *
 * \param key        array of integers holding the key
 * \param expanded   array of integers where the expanded key is stored
 *
 * \sa AESEncryptBlock
 **/
void AESEncryptExpandKey(unsigned int key[], unsigned int expanded[]);

/** This function encrypts a block of plaintext into a block of ciphertext,
 * given a key. All are supplied as arrays of integers. Calling this
 * function is equivalent to first calling AESEncryptExpandKey() and then
 * AESEncryptBlock().
 *
 * \param plainText  array of integers holding the input message
 * \param key        array of integers holding the key
 * \param cipherText array of integers where the encrypted message is stored
 **/
void AESEncrypt(unsigned int plainText[], unsigned int key[], unsigned int cipherText[]);

/** This function encrypts a block of plaintext into a block of ciphertext,
 * given an expanded key. Use AESEncryptExpandKey() to expand a 128-bit key.
 * All are supplied as arrays of integers.
 *
 * \param cipherText      array of integers holding the encrypted input message
 * \param expanded        array of integers holding the expanded key
 * \param decipheredText  array of integers where the decrypted message is stored
 *
 * \sa AESDecryptExpandKey
 **/
void AESDecryptBlock(unsigned int cipherText[], unsigned int expanded[], unsigned int decipheredText[]);

/** This function expands a 128-bit key into a format suitable for efficient decryption
 * The output array needs to be at least 44 (that is Nb*(Nr+1)) words long
 *
 * \param key        array of integers holding the key
 * \param expanded   array of integers where the expanded key is stored
 *
 * \sa AESDecryptBlock
 **/
void AESDecryptExpandKey(unsigned int key[], unsigned int expanded[]);

/** This function encrypts a block of plaintext into a block of ciphertext,
 * given a key. All are supplied as arrays of integers. Calling this
 * function is equivalent to first calling AESDecryptExpandKey() and then
 * AESDecryptBlock().
 *
 * \param cipherText      array of integers holding the encrypted input message
 * \param key             array of integers holding the key
 * \param decipheredText  array of integers where the decrypted message is stored
 **/
void AESDecrypt(unsigned int cipherText[], unsigned int key[], unsigned int decipheredText[]);


#endif //ifndef AESfunctions_h

