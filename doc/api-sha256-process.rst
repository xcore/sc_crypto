SHA256 with a server thread
---------------------------


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

API
===

.. doxygenfunction:: sha256Process

.. doxygenfunction:: sha256Begin

.. doxygenfunction:: sha256Update

.. doxygenfunction:: sha256End

.. doxygenfunction:: sha256Terminate



Example
=======

An example program is shown below::

  void comp(streaming chanend c) {
    unsigned int hash[8];
    sha256Begin(c);
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
