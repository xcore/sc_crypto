Cryptographic routines
......................

:Stable release:  unreleased

:Status:  draft

:Maintainer:  https://github.com/henkmuller

:Description:  Algorithms for encryption and hashing


Key Features
============

* Speed optimised SHA2

To Do
=====

* Change SHA2 to enable arbitrary sized blocks to be digested.
* AES
* RSA

Firmware Overview
=================

This repo contains modules implementing various standard crypto algorithms.
At present - only SHA256 is implemented at chunk level.


Known Issues
============

* To complete SHA256, the implementation needs to:
  be made to work on messages of arbitrary length of N bits (at present, it only works for N = 512-64).
  This involves: a)
  append a '1' bit and (512-(N+1+64)%512) zero bits; b) append the message length as a 64 bit number;
  c) split the message in 512 byte blocks prior to processing.

Required Repositories
================

* xcommon git\@github.com:xcore/xcommon.git

Support
=======

None at present
