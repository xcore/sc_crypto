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

A single thread can encrypt and decrypt data as follows (assuming 8 threads
on a 400 MHz part - or 50 MIPS threads):

+---------------+-----------+------------+--------+------------------------+
| Functionality | Key size  | Data rate  | Memory | Status                 |
+---------------+-----------+------------+--------+------------------------+
| Encryption    | 128 bit   | 9.1 Mbit/s | 8K     | Implemented and tested |
+---------------+-----------+------------+--------+------------------------+
| Decryption    | 128 bit   | 7.0 Mbit/s | 13K    | Implemented and tested |
+---------------+-----------+------------+--------+------------------------+

Note that encryption has been severely optimised - decryption can possibly
be optimised further.

module_SHA2
-----------

