.. _data_types:

Data types
==========

The following data types are used in the core spec, and also in Signal Exchange Lists (SXLs).

Signal Exchange Lists (SXLs) specifiy which types are allowed in particular statuses, alarms and commands, and can also define additional specialized types.


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

**integer**
An integer, e.g. 12, 0 or -5.
Follow the ECMA standard. A dot "." is not allowed.
Encoded as a JSON number.

**timestamp**
A timestamp, e.g. "2019-09-26T12:54:54.066Z". 
Uses the W3C XML dateTime definition with 3 decimal places. All timestamps uses UTC.
Encoded as a JSON string.

**base64**
Binary data expressed in base64 format according to RFC-4648, e.g. "TWFs", which represents the binary sequence 010011010110000101101100.
Encoded as a JSON string.


Legacy types
-------------------
For historical reasons, some basic types must sometimes be encoded as JSON strings using these specialized legacy types:

**number_as_string**
An integer or float encoded as a string, e.g. "12" or "0.5".
Follow sthe ECMA standard. A dot "." is used as decimal point for floating point numbers.
Encoded as a JSON string.

**integer_as_string**
An integer e.g. "12".
Follow the ECMA standard, but a dot "." is not allowed.
Encoded as a JSON string.

**boolean_as_string**
Either "true" or "false".
Whitespace or alternative casing is not allowed.
Encoded as a JSON string.

**list_as_string**
A comma-separated list encoded as a string, e.g. "1,2,3" or "true,false".
Extra whitespace is not allowed. 



