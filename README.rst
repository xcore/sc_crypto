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

* AES
* RSA

Firmware Overview
=================

This repo contains modules implementing various standard crypto algorithms.
At present - only SHA256 is implemented. The core of the algorith, has been
hand-optimised, there is some waste in the interface routines that ought to
be optimised too.


Known Issues
============

None

Required Repositories
================

* xcommon git\@github.com:xcore/xcommon.git

Support
=======

Please raise an issue on github if you have any ideas.
