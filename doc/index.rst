sha 256 user guide
''''''''''''''''''

There are two interfaces to SHA256 - process based and function based. The
process based interface uses separate thread to perform the hashing. The
function based interface uses the calling thread for the computations. The
former interface is slightly faster. Both interfaces can be sped up further
by judicious use of word vs byte manipulation instructions.

Process based
-------------


The current SHA256 implementation consists of two parts: a process that
computes the sha256 hash, and four function calls that can be used
to supply data to the hashing process.

In a par call the ``sha256Process()`` function, then in another thread
call the function ``sha256Begin()`` to start computing a new hash, the
function ``sha256Update()`` to incorporate some more data into the hash, the
function ``sha256End()`` to obtain the hash, and the
function ``sha256Terminate()`` to stop the hashing process when you are
done computing hashes.

The rationale for doing the computations in a separate thread is that it
keeps the state in that thread, slightly speeding up computation.

Note that the current interface can only perform the computation on a byte
stream. This can be changed to a bit stream, the hashing thread
itself works on a bit stream already, it just requires a different set of
functions. 

The two threads communicate by means of a streaming channel; optimised for
computation on a single core.

sha256Process
=============

Call this function with a single argument, the streaming channel::

  sha256Process(streaming chanend c)



sha256Begin
===========

Call this function with a single argument, the streaming channel::

  sha256Begin(streaming chanend c)



sha256Update
============

Call this function with a three arguments, the streaming channel, an array
of bytes (unsigned characters), and an integer denoting the total number of
arguments::

  sha256Update(streaming chanend c, unsigned char data[], int n)


sha256End
===========

Call this function with a two arguments, the streaming channel, and an
array of 8 unsigned integers in which the hash will be stored::

  sha256End(streaming chanend c, unsigned int hash[8])



sha256Terminate
===============

Call this function with a single argument, the streaming channel::

  sha256Terminate(streaming chanend c)


Example
=======

An example program is shown below::

  void comp(streaming chanend c) {
    unsigned int hash[8];
    sha256Start(c);
    sha256Update(c, "Hello", 5);
    sha256End(c, hash);
    sha256Terminate(c);
  }

  int main(void) {
    streaming chan c;
    par {
      sha256Process(c);
      comp(c);
    }
    return 0;
  }


Function based
--------------


Call the function ``sha256BlockBegin()`` to start computing a new hash, the
function ``sha256BlockUpdate()`` to incorporate some more data into the
hash, and the
function ``sha256BlockEnd()`` to obtain the hash.

Note that the current interface can only perform the computation on a byte
stream. This can be changed to a bit stream, the hashing thread
itself works on a bit stream already, it just requires a different set of
functions. 

The two threads communicate by means of a streaming channel; optimised for
computation on a single core.


sha256BlockBegin
================

Call this function with a single argument, the streaming channel::

  sha256BlockBegin(unsigned int hash[8])



sha256BlockUpdate
=================

Call this function with a three arguments, the streaming channel, an array
of bytes (unsigned characters), and an integer denoting the total number of
arguments::

  sha256BlockUpdate(unsigned int hash[8], unsigned char data[], int n)


sha256BlockEnd
==============

Call this function with a two arguments, the streaming channel, and an
array of 8 unsigned integers in which the hash will be stored::

  sha256BlockEnd(unsigned int hash[8])




Example
=======

An example program is shown below::

  int main(void) {
    unsigned int hash[8];
    sha256BlockStart(hash);
    sha256BlockUpdate(hash, "Hello", 5);
    sha256BlockEnd(hash);
    return 0;
  }
