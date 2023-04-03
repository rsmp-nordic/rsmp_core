.. _data_types:

Data types
----------
RSMP uses a specific set of data types in return values and arguments of alarms, statuses and commands.

General definition:

.. tabularcolumns:: |\Yl{0.15}|\Yl{0.85}|

.. list-table:: Data types
   :header-rows: 1

   * - Data type
     - Description
   * - string
     - Text information
   * - integer
     - Numerical value (16-bit signed integer), [-32768 – 32767]
   * - long
     - Numerical value (32-bit signed long)
   * - real
     - Float (64-bit double precision floating point)
   * - boolean
     - Boolean data type
   * - base64
     - Binary data expressed in base64 format according to RFC-4648
   * - timestamp
     - The timestamp uses the W3C XML dateTime definition with 3 decimal places. All timestamps uses UTC.
   * - array
     - List of of key and value pairs (like a hash table). Makes it possible to send multiple values. Content defined by SXL.

Point (".") is always used as decimal mark.
