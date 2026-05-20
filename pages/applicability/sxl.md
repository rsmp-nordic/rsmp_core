---
layout: page
title: Signal Exchange List
permalink: /3.3.0/signal-exchange-list/
parent: Applicability
nav_order: 7
---

# Signal Exchange List
{: #signal-exchange-list}

The signal exchange list is an important functional part of RSMP.
Since the contents of every message using RSMP is dynamic, a predefined
signal exchange list ([SXL]({{ '/3.3.0/definitions/#sxl' | relative_url }})) is prerequisite in order to be able to
establish communication.

The signal exchange list defines the alarms, commands and statuses which is
possible to send and receive for each object type.

The SXL can be defined by either a YAML file or an Excel file using predefined
principles which is defined below.

## Object types

An **object type** defines a type of object that can exist in a site,
i.e. "LED". Each object type can have a set of alarms, statuses and
commands associated with it.

Using the Excel format; objects types are defined in its own sheet.
Using the YAML format; each object type is defined like this:

```yaml
objects:
  object-type:
```

Where `object-type` is the name of the object type. For instance,
"Traffic Light Controller".

Depending on applicability, each object type can either have its own
series or common series of alarm suffix (alarmCodeId), status codes
(statusCodeId) and command codes (commandCodeId).

## Message types

The message types **Alarm**, **Aggregated status**, **Status** and **Commands**
are defined in the SXL.

Using the Excel format; alarms, aggregated status, status and commands are
defined in their own sheet.

Using the YAML format; each message type is defined like this:

```yaml
objects:
  object-type:
    aggregated_status:
      1:
        title: Local mode
        description: In local mode
      2:
        title: No Communications
      3:
        title: High priority fault
        description: Fail safe mode
      4:
        title: Medium Priority Fault
        description: Medium priority fault, but not in fail safe mode
      5:
        title: Low Priority Fault
      6:
        title: Connected / Normal - In Use
      7:
        title: Connected / Normal - Idle
      8:
        title: Not Connected
    functional_position:
      position-1: start
      position-2: stop
    alarms:
      A0001:
        description: alarm description text
        priority: 1
        category: D
        externalAlarmCodeId: manufacturer specific alarm text
        externalNtsAlarmCodeId: 0000
        arguments:
          argument-1:
            type: integer
            min: 0
            max: 10
            description: A0001 argument 1
    statuses:
      S0001:
        description: status description text
        arguments:
          argument-1:
            type: string
            description: S0001 argument 1
    commands:
      M0001:
        description: command description text
        command: setStatus
        arguments:
          argument-1:
            type: boolean
            description: M0001 argument 1
```

This example defines:

- An alarm with the [alarm code id]({{ '/3.3.0/definitions/#alarm-code-id' | relative_url }}) `A0001`
- A status with the [status code id]({{ '/3.3.0/definitions/#status-code-id' | relative_url }}) `S0001`
- A command with the [command code id]({{ '/3.3.0/definitions/#command-code-id' | relative_url }}) `M0001`

Each with one argument named `argument-1` using integer, string and boolean
data types.

The alarm contains the fields:

- `description` is the alarm description
- `category` is the [alarm category](#alarm-category)
- `priority` is the [alarm priority](#alarm-priority)
- `externalAlarmCodeId` is the [External alarm code id]({{ '/3.3.0/definitions/#external-alarm-code-id' | relative_url }})
- `externalNtsAlarmCodeId` is the [External NTS alarm code id]({{ '/3.3.0/definitions/#external-nts-alarm-code-id' | relative_url }})

The status contains the fields:

- `description` is the status description

The command contains the fields:

- `description` is the command description
- `command` is optionally used for RPC (Remote Procedure Call)

An argument contains the fields:

- `description` is the argument description
- `min` is the minimum value (only for *number* or *integer* data types)
- `max` is the maximum value (only for *number* or *integer* data types)
- `type` is the [data type]({{ '/3.3.0/data-types/' | relative_url }})

At least one argument are required for command and statuses, but they are
optional in alarms.

{: .note }
> In the Excel version of the SXL, there is no separate min and max columns.
> Instead, allowed values can be defined using the Value column according
> to the following example: [0-100], where 0 is the minimum value and 100 is
> the maximum value.

The aggregated status contains the fields:

- `functional_position` is the [Functional position]({{ '/3.3.0/definitions/#functional-position' | relative_url }})
- `functional_state` is the [Functional state]({{ '/3.3.0/definitions/#functional-state' | relative_url }})
- `1-8` is an array of eight booleans. Each with a title and optional
  description. See [State bits]({{ '/3.3.0/basic-structure/#state-bits' | relative_url }})

### Alarm description
{: #alarm-description}

The format of the description is free of choice but has the following
requirements:

- Description is unique for the object type
- Description is defined in cooperation with the Purchaser before use

### Alarm category
{: #alarm-category}

The alarm category is defined by a single character, either `T` or `D`.

| Value | Description |
|-------|-------------|
| T | Traffic alarm |
| D | Technical alarm |

A **traffic alarm** indicates events in the traffic related functions or the
technical processes that affects traffic.

A couple of examples from a tunnel:

- Stopped vehicle
- Fire alarm
- Error which affects message to motorists
- High level of CO₂ in traffic room
- etc.

**Technical alarms** are alarms that do not directly affect the traffic.
One example of technical alarm is when an impulse fan stops working.

### Alarm priority
{: #alarm-priority}

The priority of the alarm.

Defined in the SXL as a single character, `1`, `2` or `3`.

| Value | Description |
|-------|-------------|
| 1 | Alarm that requires immediate action. |
| 2 | Alarm that does not require immediate action, but action is planned during the next work shift. |
| 3 | Alarm that will be corrected during the next planned maintenance shift. |

## Functional differences between message types

The following table defines the functional differences between message types.

| Message type | Sent when | Adapted to be transmitted to NTS |
|---|---|---|
| Alarm | On change *or* request | Yes |
| Aggregated status | On change *or* request | Yes |
| Status | On request *or* according to subscription | No |
| Command | On request | Yes, partly (functional status) |

{: .note }
> In addition of [Functional position]({{ '/3.3.0/definitions/#functional-position' | relative_url }}), the Excel version of the SXL
> can also differentiate between different kinds of command messages using
> [maneuver]({{ '/3.3.0/definitions/#maneuver' | relative_url }}) and [parameter]({{ '/3.3.0/definitions/#parameter' | relative_url }}) sections. However, their use has no
> functional significance from a protocol point of view.

## Arguments and return values

Argument and return values makes it possible to send extra information in
messages. It is possible to send binary data (base64), such as bitmap
pictures or other data, both to a site and to supervision system. The
signal exchange list must clarify exactly which data type which is used
in each case. There is no limitation of the number of arguments and
return values which can be defined for a given message. Argument and return
values is defined as extra columns for each row in the signal exchange
list.
