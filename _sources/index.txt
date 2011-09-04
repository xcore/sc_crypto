sha 256 user guide
''''''''''''''''''

There are two interfaces to SHA256 - process based and function based. The
process based interface uses separate thread to perform the hashing. The
function based interface uses the calling thread for the computations. The
former interface is slightly faster. Both interfaces can be sped up further
by judicious use of word vs byte manipulation instructions.


.. toctree::

   api-sha256-process.rst
   api-sha256-function.rst



