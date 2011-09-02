sha 256 user guide
------------------


The current SHA256 implementation consists of two parts: a process that
computes the sha256 hash, and four function calls that can be used
to supply data to the hashing process.

In a par call the ``sha256Process()`` function, then in another thread
call the function ``sha256Begin()`` to start computing a new hash, the
function ``sha256Update()`` to incorporate some more data into the hash, the
function ``sha256End()`` to obtain the hash, and the
function ``sha256Terminate()`` to stop the hashing process when you are
done computing hashes.

The rationale for doing the cmoputations in a separate thread is that it
keeps the state in that thread, slightly speeding up computation. It is
perfectly feasible to make a different interface that does not need a
separate thread.

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
