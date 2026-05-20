---
layout: page
title: Data Types
permalink: /3.3.0/data-types/
parent: Applicability
nav_order: 6
---

# Data Types
{: #data_types}

RSMP uses a specific set of data types in return values and arguments of alarms, statuses and commands.

| Data type | Description |
|-----------|-------------|
| string | Text information |
| integer | JSON integer according to the ECMA standard |
| number | JSON numerical value. Can be either integer or floating point according to the ECMA standard |
| boolean | Boolean data type |
| base64 | Binary data expressed in base64 format according to RFC-4648 |
| timestamp | The timestamp uses the W3C XML dateTime definition with 3 decimal places. All timestamps uses UTC. |
| array | List of values. Makes it possible to send multiple values of any data type or list of key and value pairs. Content defined by SXL. |

Point (`.`) is always used as decimal mark.
