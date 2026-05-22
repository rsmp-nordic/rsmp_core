---
layout: page
title: Change Log
permalink: /3.3.0/changelog/
nav_order: 6
---

# Change Log

## Version 3.3.0

Release date: 2024

*Current version.*

## Version 3.2.2

Release date: 2024-06-25

The full list of changes between version 3.2.2 and 3.2.1 can be viewed on github:
[v3.2.1...v3.2.2](https://github.com/rsmp-nordic/rsmp_core/compare/v3.2.1...v3.2.2)

**Minor changes**

- Clarify use of TLS 1.3 for encrypted communication. [#149](https://github.com/rsmp-nordic/rsmp_core/issues/149)
- Reset timer for updateRate when sendOnChange is triggered. [#157](https://github.com/rsmp-nordic/rsmp_core/issues/157)

**Clarifications**

- Use the term "status"/"command" instead of "object". [#131](https://github.com/rsmp-nordic/rsmp_core/issues/131)
- Clarify that every message should have a unique GUID. [#134](https://github.com/rsmp-nordic/rsmp_core/issues/134)
- Clarify description of unimplemented status/commands. [#136](https://github.com/rsmp-nordic/rsmp_core/issues/136)
- Clarify that all commands arguments need to be present. [#137](https://github.com/rsmp-nordic/rsmp_core/issues/137)
- Update section about SXL. [#138](https://github.com/rsmp-nordic/rsmp_core/issues/138)
- Clarify transport section. [#155](https://github.com/rsmp-nordic/rsmp_core/issues/155)
- Clarify communication establishment between sites. [#156](https://github.com/rsmp-nordic/rsmp_core/issues/156)
- Update tables to include SXL/site configuration in YAML format. [#159](https://github.com/rsmp-nordic/rsmp_core/issues/159)
- Clarify that alarm priority affects state bits 3,4 and 5. [#162](https://github.com/rsmp-nordic/rsmp_core/issues/162)
- Clarify the error case when object type doesn't match the signal. [#164](https://github.com/rsmp-nordic/rsmp_core/issues/164)

## Version 3.2.1

Release date: 2023-10-03

The full list of changes between version 3.2.1 and 3.2 can be viewed on github:
[v3.2...v3.2.1](https://github.com/rsmp-nordic/rsmp_core/compare/v3.2...v3.2.1)

**Important changes**

- Add timestamp as a data type in RSMP Core. Time stamp is a commonly used in the TLC SXL.
  This means that there is no need for duplicate definitions. No changes to the protocol
  itself. [#101](https://github.com/rsmp-nordic/rsmp_core/issues/101)
- Only use JSON types. This means that "long" and "real" data types are removed since
  they don't exist in the ECMA standard. The data type "number" is added instead.
  [#82](https://github.com/rsmp-nordic/rsmp_core/issues/82)

**Minor clarifications**

- Add separate section for error handling. No changes to the protocol. [#114](https://github.com/rsmp-nordic/rsmp_core/issues/114)
- Include the full changelog.
- Correct spelling mistakes and fix minor issues.

## Version 3.2

Release date: 2022-06-23

**Important changes**

- **Buffered messages**. The `q` field in StatusUpdate should be changed when
  sending buffered messages. [#73](https://github.com/rsmp-nordic/rsmp_core/issues/73)
- **Case sensitive**. RSMP is now case sensitive. [#35](https://github.com/rsmp-nordic/rsmp_core/issues/35)
- **Connect to multiple supervisors**. Each site needs to support multiple
  RSMP connections (if required in the SXL). [#19](https://github.com/rsmp-nordic/rsmp_core/issues/19)
- **Array type**. Add ability to send a list of values. [#63](https://github.com/rsmp-nordic/rsmp_core/issues/63)

**Minor clarifications**

- Clarify when commands/requests can be sent. [#34](https://github.com/rsmp-nordic/rsmp_core/issues/34)
- Table in chapter 4.5.1.6 updated. [#55](https://github.com/rsmp-nordic/rsmp_core/issues/55)
- The list of participants in the RSMP Nordic collaboration updated. [#67](https://github.com/rsmp-nordic/rsmp_core/issues/67)
- Fix in changelog for 3.1.3 "ageState". [#69](https://github.com/rsmp-nordic/rsmp_core/issues/69)
- How to reject a RSMP connection. [#38](https://github.com/rsmp-nordic/rsmp_core/issues/38)
- How to determine RSMP version during handshake. [#43](https://github.com/rsmp-nordic/rsmp_core/issues/43)
- Allow update of subscription interval time by sending new subscription request. [#52](https://github.com/rsmp-nordic/rsmp_core/issues/52)
- Aggregated status without any bits set. [#57](https://github.com/rsmp-nordic/rsmp_core/issues/57)
- Subscriptions should not persist across restarts/power outage. [#74](https://github.com/rsmp-nordic/rsmp_core/issues/74)
- CommandRequest and CommandResponse can contain multiple requests/responses. [#58](https://github.com/rsmp-nordic/rsmp_core/issues/58)
- null or empty string is allowed in functionalPosition/state. [#45](https://github.com/rsmp-nordic/rsmp_core/issues/45)
- Respond with MessageNotAck if security code is incorrect. [#79](https://github.com/rsmp-nordic/rsmp_core/issues/79)

## Version 3.1.5

Release date: 2020-10-30

**MessageAck must be prioritized over buffered messages**

During communication establishment there may be buffered messages that needs
to be sent by the equipment. Sending any buffered messages is part of the
communication sequence, but it may take a long time to empty the buffer
in case of a slow network or long communication interruption. The equipment
must prioritize to respond with MessageAck to any requests that the
supervision system may send during this time. [#4](https://github.com/rsmp-nordic/rsmp_core/issues/4)
[View changes](https://github.com/rsmp-nordic/rsmp_core/commit/c6190f85e1bec18cce760040db922aef68eed7a3)

**Don't send new alarms if they're already active**

Clarify that new alarms shouldn't be sent if the alarm is already active.
No changes to the protocol itself. [#18](https://github.com/rsmp-nordic/rsmp_core/issues/18)

**Ability to request alarms and aggregated status**

[#22](https://github.com/rsmp-nordic/rsmp_core/issues/22)

**Status subscriptions and update on change+interval**

[#21](https://github.com/rsmp-nordic/rsmp_core/issues/21)

## Version 3.1.4

Release date: 2017-11-03

**Alarm timestamps**

The Alarm timestamp (aSp) now also represents when the alarm changes status,
for instance when alarms turns inactive. See issue [#1](https://github.com/rsmp-nordic/rsmp_core/issues/1)

**Encryption**

Implementation of encryption support in the equipment is no longer mandatory
(it was introduced in 3.1.3)

**Connection establishment/handshake**

The connection establishment sequence has been clarified. The site begins
sending the version message.
All alarms (not just active and blocked) are sent during connection
establishment. Alarms may have turned inactive during communication
interruption. [#3](https://github.com/rsmp-nordic/rsmp_core/issues/3)

**Communication interruption**

Buffering should be possible to enable/disable for each status.

If the version message hasn't been successfully exchanged, then the
system/system must not respond with MessageAck/MessageNotAck to any RSMP
messages other than the version message. If no Ack is received then the
equipment and supervision system treats this a communication interruption and
disconnects. The site then reconnects with proper handshake according to
the connection establishment sequence.

**Watchdog**

The time sync using watchdog should be possible to enable/disable in the site.

**Clarifications**

- The XML examples has been removed. Only JSon is used for message exchange.
- Message exchange diagrams has been improved.

## Version 3.1.3

Release date: 2014-11-24

**Important changes**

- Encryption. All traffic should be possible to encrypt if required.
  Both supervision systems and sites should have to possibility to easily
  enable/disable encryption. SSL 3.0/TLS 1.0 or later should be used.
  Certificates is used to verify the identities for equipment.
  Equipment that uses RSMP should contain a interface for easy management
  of certificates. Generating of new certificates or renewal should be
  made by the client. Installation of new certificated should be done
  with consultation of the client.
- Added figures of message exchange during communication establishment.
- Extended chapter about communication between sites.
- Aggregated status is also sent between sites in order to inform about
  any active alarms.
- The data types raw, scale, unit and ordinal removed since they are too
  ambiguous.
- Subscriptions are not cancelled at communication interruptions. Cancelling
  subscriptions means that those messages are lost which makes debugging harder.
- Active and blocked alarms are sent at communication reestablishment, but
  alarms which are not sent doesn't need to be interpreted as inactive since
  they are expected to be sent as part of buffered messages.
- 1000 buffered messages now changed to 10000 as minimum buffer size.
- "q" can now have the state of "undefined" in case the object does not exist.
- With the exception of aggregated status only JSon string elements are used,
  and JSon number or boolean elements are not used. Some examples used wrong
  types and have been updated.
- If an object is not known during status request or command request, the
  site must not disconnect but instead reply with "q" set to "undefined".
- If a subscription is already active on a given status then the site
  should not establish a new subscription but use the existing one.
  StatusUpdate should not be sent as response in this case.
- The watchdog interval duration must be configurable with a default sent to
  once 1 minute (60 seconds).

**Adjustments**

- Chapter 4.1 (page 6): Typo. Five messages types are actually four.
- Chapter 5.5.1 (page 38). Typo in the table for JSon, "timestamp" should be "aTs".
- Chapter 5.5.1 (page 38): In the aggregated status, "name" is a positional element in JSon.
- Chapter 5.5.3.2 (page 41): Unused elements remained in the examples for
  alarm acknowledgment message. "ack", "aS", "sS", "aTs", "cat", "pri", "rvs".
- The abbreviation SUL (for signal exchange list) changed to SXL.
- Appendix 6.3.2 (page 7). Command messages has no return values.
  In RSMP 3.x and later commands only returns values based on the arguments
  in CommandResponse.
- Fix typo. Incorrectly used "ageState" instead of "q".

**Clarifications**

- Chapter 5.3.1 (page 8): Clarification regarding the prerequisites when
  using separate signal exchange lists for different sites.
- Chapter 5.3.2 (page 8): Clarification regarding reconnection after
  communication disruption. The site should automatically try to reconnect.
- Chapter 5.3.2 (page 8): As a default any active subscriptions should
  remain active during a communication interruption since they can be sent
  when connection is reestablished.

## Version 3.1.2

Release date: 2012-02-29

The following typos has been fixed:

- Chapter 5.5.3.1 (page 38). "ts" should be "aTs"
- Chapter 5.5.6.2 (page 37). "aTS" should be "cTS"
- Chapter 5.5.1 (page 35). "returnvalues" should be "sS"
- Chapter 5.5.1, 5.5.8.1 (page 36, 50) "sIds" should be "siteId"
- Chapter 5.5.5.5 (page 46). "StatusUnSubscribe" should be "StatusUnsubscribe"
- Chapter 5.5.1, 5.5.6.1 (page 36, 47). "co" should be "cO"

The following clarifications has been made:

- On page 10,11,17,18,36,41: SequenceNumber removed completely.
- Appendix, page 13: Alarm messages are also sent at alarm blocking.
- Chapter 2 (page 2,4): Definitions of "NTS", "Object", "NTS Object" and "component" updated.
- Chapter 5.4 (page 9, 11-14): Clarification regarding descriptions of
  "ntsObjectId", "externalNts", "componentId", "alarmCodeId",
  "externalNtsAlarmCodeId", "category" and "description".

## Version 3.1.1

Release date: 2011-12-23

- Command message (commandCodeId) moved to argument/return value. This
  makes it possible to send multiple commands in the same message.
- "ageState" was on the wrong place in the examples.
- "value" renamed to "status" in status messages.
- Clarified description of "siteId".
- Version message: "ntsObjectId" replaced with "siteId". All site identities
  (siteId) which are included in the communication is sent in the
  version message as a list.
- Adjusted the format of aggregated status in JSon. Sent as an array instead.
- Time stamp in JSon adjusted. Now uses the same format as XML.
- Clarification regarding the usage of JSon string elements.

## Version 3.0

Release date: 2011-11-04

- NTSObjectId changed to NTSOId in JSon.
- All active alarms and blocked alarms are sent at restored communication,
  not just the changed alarm statues.
- Figures for the communication exchange for version and status updated.

## Version 2.0

*Same as version 1.0.*

## Version 1.1o

Release date: 2011-11-02

- sequenceNumber is removed from all message types.

## Version 1.1n

Release date: 2011-11-02

- requestId (rId) removed.
- sequenceNumber (sNr, seqNr) is removed from status messages.
- "unknown" added as a possible ageState.
- Clarification of aggregated status, 8-bit definition.
- siteId changes name to ntsObjectId in SXL and message exchange.
- Alarm message adjusted so that is possible to determine if the alarm
  is issued, acknowledged or blocked (alarmSpecialisation).
- Time stamp for an alarm is issued, acknowledged and blocked merged to "timestamp".
- Event messages is removed. All functionality of event messages is provided with status messages.

## Version 1.1m

Release date: 2011-11-01

- Fixed JSon example. It stated ctId instead of cId for componentId.
- Change name of alarms, events, status and commands for two letter prefix
  AL, EV, IS, MA, to a single letter prefix: A, H, S, M.

## Version 1.1l

Release date: 2011-11-30

- New design of status messages. Makes it possible to send multiple requests
  in a single message and receive response in a single message. Makes it
  possible to subscribe to multiple status values, either by interval or on change.

## Version 1.1k

Release date: 2011-10-26

- Added a new message type for sending version of RSMP and revision of SXL.

## Version 1.1j

Release date: 2011-10-25

- Remove global time stamp for all message types.
- Added timestamp for alarm acknowledgement, alarm blocking and watchdog.
- Watchdog message reduced in size.
- Message acknowledgement reduced in size.
- Watchdog is now sent in both directions and should be used for time synchronization.

## Version 1.1i

Release date: 2011-10-24

- Fixed JSon example. It stated ctId instead of cId for componentId.

## Version 1.0

Release date: 2011-05-20

- Clarifications regarding the signal exchange list added.
- Clarifications about transport layer.

## Version 1.0b

Release date: 2011-01-12

- Added watchdog as separate message type.

## Version 1.0a

Release date: 2010-10-08

- This version was used for the variable speed signs.

## Version 0.97

Release date: 2010-10-07

- "number", "boolean" and "ordinal" added as possible data types.
- Clarifications regarding binary data format (base64).

## Version 0.96

Release date: 2010-09-23

- Major update of the object model.

## Version 0.95

Release date: 2010-09-01

- Minor adjustments of the document formatting.

## Version 0.92

Release date: 2010-06-23

This version was distributed with the specifications for variable speed signs.
