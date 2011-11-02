Cryptographical software
========================

There are several cryptographic standard algorithms, used for encryption,
decryption, and authentication. Some of those algorithms have been
implemented, and results are given in the tables below. 

The most important characteristics are the following:

* The key size, typically expressed as a number of bits (encryption and
  decryption)

* The digest size, typically expressed as a number of bits (hashing) 

* The data bit rate. A typical values is 10 Mbit/s.

* Code can be optimised for size or for speed - with very different
  results. Results reported here are optimised for speed at the expense of
  memory.

module_AES
----------

A function running inside a single thread can encrypt and decrypt data as
follows (assuming 8 threads on a 400 MHz part - or 50 MIPS threads):

+---------------+-----------+------------+--------+------------------------+
| Functionality | Key size  | Data rate  | Memory | Status                 |
+---------------+-----------+------------+--------+------------------------+
| Encryption    | 128 bit   | 9.1 Mbit/s | 8K     | Implemented and tested |
+---------------+-----------+------------+--------+------------------------+
| Decryption    | 128 bit   | 7.0 Mbit/s | 13K    | Implemented and tested |
+---------------+-----------+------------+--------+------------------------+

Note that encryption has been severely optimised - decryption can possibly
be optimised further.

Both require the key to be expanded once, and then decrypt a large number
of blocks.

module_SHA2
-----------

The SHA2 module has two interfaces: one that is a function call from within
a single thread, and one that requires a separate thread to do the
groundwork, which acts as a server. The performance is as follows:
(assuming 8 threads on a 400 MHz part - or 50 MIPS threads):

+-----------------+-----------+------------+--------+-------------+
| Functionality   | Hash size | Data rate  | Memory | Status      |
+-----------------+-----------+------------+--------+-------------+
| Block based     | 256 bit   | 3.5 Mbit/s | 4.5K   | Implemented |
+-----------------+-----------+------------+--------+-------------+
| Separate thread | 256 bit   | 4.0 Mbit/s | 4.5K   | Implemented |
+-----------------+-----------+------------+--------+-------------+



