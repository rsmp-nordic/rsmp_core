.. _data_types:

Data types
==========

The following data types are used in the core spec, and also in Signal Exchange Lists (SXLs).

Signal Exchange Lists (SXLs) specify which types are allowed in particular statuses, alarms and commands, and can also define additional specialized types.


JSON types
----------
RSMP message are send as JSON, which defines these basic types:

- object (hash)
- array
- string
- number
- boolean
- null


Specialized types
-----------------
The following specialized data types are defined:

integer
    An integer, e.g. ``12``, ``0`` or ``-5``.
    Follows the ECMA standard. A dot "." is not allowed.
    Encoded as a JSON number.

timestamp
    A timestamp, e.g. ``2019-09-26T12:54:54.066Z``.
    Follows the W3C XML dateTime definition with three decimal places.
    Always in the UTC timezone. Encoded as a JSON string.

base64
    Binary data expressed in base64 format string according to RFC-4648,
    e.g. ``TWFs``, which represents the binary sequence 010011010110000101101100.
    Encoded as a JSON string.


Legacy types
-------------------
For historical reasons, basic types are sometimes encoded as JSON strings using these types.
Whitespace is not allowed in any of these legacy types.

number_as_string
    An integer or float represented as a string, e.g. ``"12"``, ``"-4"``, ``"0.5"`` or ``"-2.4"``.
    Follows the ECMA standard. A dot "." is used as decimal point for floating point numbers.

integer_as_string
    An integer represented as a string, e.g. ``"12"`` or ``"-7"``.
    Follows the ECMA standard, but a dot "." is not allowed.

boolean_as_string
    A boolean represented as a string, either ``"true"`` or ``"false"``.
    Alternative casing is not allowed.

string_list_as_string
    A comma-separated list of strings, e.g. ``"high,medium,low"``.
    Commas are not allowed as part of the strings.

number_list_as_string
    A comma-separated list of number_as_strings, e.g. ``"1.0,2"``.

integer_list_as_string
    A comma-separated list of integer_as_strings, e.g. ``"2,-4,0"``.

boolean_list_as_string
    A comma-separated list of boolean_as_strings, e.g. ``"true,false"``.



.. _natural-sorting:

Natural Sorting
---------------
Natural sorting is the same as alphabetical sorting, except that sequences of digits
inside the strings are treated and sorted numerically:

.. code-block::
   :name: id-ordering-natural

   /dl/1
   /dl/2
   /dl/10
   /tc

This is different from alphabetical sorting, which would give:

.. code-block::
   :name: id-ordering-alphabetical

   /dl/1
   /dl/10
   /dl/2
   /tc
