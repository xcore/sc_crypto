SHA256 with function calls
---------------------------

The function-based SHA256 interface uses three functions. Call the function
``sha256BlockBegin()`` to start computing a new hash, the function
``sha256BlockUpdate()`` to incorporate some more data into the hash, and
the function ``sha256BlockEnd()`` to obtain the hash.

Note that the current interface can only perform the computation on a byte
stream. This can be changed to a bit stream, the hashing thread
itself works on a bit stream already, it just requires a different set of
functions. 


API
===

.. doxygenfunction:: sha256BlockBegin

.. doxygenfunction:: sha256BlockUpdate

.. doxygenfunction:: sha256BlockEnd



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
