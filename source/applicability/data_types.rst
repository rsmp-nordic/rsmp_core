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
Follows the ECMA standard. A dot "." is not allowed.
Encoded as a JSON number.

**timestamp**
A timestamp, e.g. "2019-09-26T12:54:54.066Z". 
Follows the W3C XML dateTime definition with three decimal places. Always in the UTC timezone.
Encoded as a JSON string.

**base64**
Binary data expressed in base64 format string according to RFC-4648, e.g. "TWFs", which represents the binary sequence 010011010110000101101100.
Encoded as a JSON string.


Legacy types
-------------------
For historical reasons, basic types are sometimes encoded as JSON strings using these specialized types.
Whitespace is not allowed in any of these legecy types.

**number_string**
An integer or float represented as a string, e.g. "12" or "0.5".
Follows sthe ECMA standard. A dot "." is used as decimal point for floating point numbers.

**integer_string**
An integer represented as a string, e.g. "12".
Follows the ECMA standard, but a dot "." is not allowed.

**boolean_string**
A boolean represented as a string, either "true" or "false".
Alternative casing is not allowed.

**string_list**
A comma-separated list of strings, e.g. "high,medium,low".
Commas are not allowed as part of the strings.

**boolean_string_list**
**comma_separated_string**
A comma-separated list of boolean_strings, e.g. "true,false".

**number_string_list**
**comma_separated_numbers**
A comma-separated list of number_strings, e.g. "1.0,2.5,3".

**integer_string_list**
**comma_separated_integers**
A comma-separated list of integer_strings, e.g. "1,2,3".
