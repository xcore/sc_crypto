// Copyright (c) 2011, XMOS Ltd, All rights reserved
// This software is freely distributable under a derivative of the
// University of Illinois/NCSA Open Source License posted in
// LICENSE.txt and at <http://github.xcore.com/>


/** This function is the SHA256 encryption server. When ready to encrypt
 * data it transmit a single control token over the channel end, and it
 * then reads bytes over the channel. It assumes that the number of bytes
 * supplied is a multiple of 64, and that the trailing '1' bit and the
 * length are encoded as defined by the SHA256 standard. At the end of the
 * packet, a single control token must be sent over the channel, whereupon
 * the hash is supplied back over the channel end, terminated by an
 * end-of-message.
 *
 * To make it easier to use this process, four auxiliary functions are
 * supplied that handle the trailing bit, the length, and the channel
 * communication.
 *
 * \param c A streaming chanend that connects this server thread to the
 *          client.
 *
 * \sa sha256Begin
 * \sa sha256Update
 * \sa sha256End
 * \sa sha256Terminate
 * 
 **/
void sha256Process(streaming chanend c);

/** This is one of the four functions that can be used with
 * sha256Process(). It must be called to initialise the hashing process.
 *
 * \param c A streaming chanend that must be connected to the server thread.
 * 
 * \sa sha256Process
 * \sa sha256Update
 * \sa sha256End
 **/
void sha256Begin(streaming chanend c);

/** This is one of the four functions that can be used with
 * sha256Process(). It is used to incorporate a block of data into the
 * hash. This function must be called after the hash has been initialised
 * with sha256Begin(). It can be called multiple times, to add multiple
 * blocks of data. Blocks can be an arbitrary number of bytes long.
 *
 * \param c       A streaming chanend that must be connected to the server
 *                thread.
 * \param message An array of bytes that contains the data to be incorporated
 *                into the hashfunction
 * \param n       The number of bytes to be incorporated.
 * 
 * \sa sha256Begin
 * \sa sha256End
 **/
void sha256Update(streaming chanend c, unsigned char message[], int n);

/** This is one of the four functions that can be used with
 * sha256Process(). It adds the length into the hash, and retrieves the hash.
 *
 * \param c       A streaming chanend that must be connected to the server
 *                thread.
 * \param hash    An array of words in which the hash will be written.
 * 
 * \sa sha256Begin
 **/
void sha256End(streaming chanend c, unsigned int hash[8]);

/** This is one of the four functions that can be used with
 * sha256Process(). It requests the hash thread to terminate, and should
 * only be called after sha256End() has been called. After this call,
 * sha256Process will return.
 *
 * \param c       A streaming chanend that must be connected to the server
 *                thread.
 * 
 * \sa sha256Process
 * \sa sha256End
 **/
void sha256Terminate(streaming chanend c);

/** This is one of three functions that comprise the function based
 * interface to the SHA256 library. It must be called to initialise the
 * hash.
 *
 * \param hash  an array of integers that holds the hash.
 * 
 * \sa sha256BlockUpdate
 * \sa sha256BlockEnd
 **/
void sha256BlockBegin(unsigned int hash[8]);

/** This is one of three functions that comprise the function based
 * interface to the SHA256 library. It is called to incorporate data into
 * the hash. THe data is supplied as an array of unsigned characters
 * (bytes).
 *
 * \param hash    an array of integers that holds the hash.
 * \param message an array of unsigned characters that contains the
 *                data to be incorporated into the hash
 * \param n       The number of bytes to incorporate into the hash.
 * 
 * \sa sha256BlockBegin
 * \sa sha256BlockEnd
 **/
void sha256BlockUpdate(unsigned int hash[8], unsigned char message[], int n);

/** This is one of three functions that comprise the function based
 * interface to the SHA256 library. It is ccompletes the hash by
 * incorpoating a trailing '1', padding, and the length of the message. On
 * return of this function the array passed as teh first argument holds the
 * hash.
 *
 * \param hash    an array of integers in which the hash is returned.
 * 
 * \sa sha256BlockBegin
 * \sa sha256BlockUpdate
 **/
void sha256BlockEnd(unsigned int hash[8]);
