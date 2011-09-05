Cryptographic routines
......................

:Stable release:  unreleased

:Status:  33% feature complete.

:Maintainer:  https://github.com/henkmuller

:Description:  Algorithms for encryption and hashing


Key Features
============

* Speed optimised SHA2
* AES

To Do
=====

* RSA

Firmware Overview
=================

This repo intends to contain modules implementing various standard crypto
algorithms for decryption, encryption and hashing.

At present - only AES and SHA256 are implemented.

The core of SHA256 has been
hand-optimised and is encoded in assembly. On the fringe there are two
interfaces (one with a server thread that does the hashing, and one where
the hashing happens in the calling thread); there is some waste in the
interface routines that ought to be optimised out.

The documentation is stored in http://xcore.github.com/sc_crypto generated from
the .h files and the doc directory.

Known Issues
============

None

Required Repositories
================

* xcommon git\@github.com:xcore/xcommon.git
* xdoc git\@github.com:xcore/xdoc.git

Support
=======

Please raise an issue on github if you have any ideas.
