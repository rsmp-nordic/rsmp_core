.. _data_types:

Data types
----------
RSMP uses JSON types for argument, attributes and return values:

- object (hash)
- array
- string
- number
- boolean
- null


For historic reasons, the following elements can be send as strings:

- number, e.g. "56". Follow the ECMA standard. A dot "." is used as decimal point for floating point numbers.
- arrays, e.g. "1,2,3". Items are separated using commmas. Whitespace is not allowed before or after commas.
- booleans, can be either "true" or "false".


The following specialized data types are defined. They are all send as JSON strings:

.. tabularcolumns:: |\Yl{0.15}|\Yl{0.85}|

.. list-table:: Data types
   :header-rows: 1

   * - Data type
     - Description
   * - base64
     - Binary data expressed in base64 format according to RFC-4648, e.g. "TWFs", which represents the binary sequence 010011010110000101101100.
   * - timestamp
     - The timestamp uses the W3C XML dateTime definition with 3 decimal places. All timestamps uses UTC. Eg. "2019-09-26T12:54:54.066Z".


Signal Exchange Lists (SXLs) specifiy which types are allowed in particular statuses, alarms and commands.


