.. _change-log:

Change log
==========

Version 3.2.1
-------------
Release date: 2023-10-03

The full list of changes between version 3.2.1 and 3.2
`can be viewed on github <https://github.com/rsmp-nordic/rsmp_core/compare/v3.2...v3.2.1>`_.

**Important changes**

- Add timestamp as a data type in RSMP Core. Time stamp is a commonly used in the TLC SXL.
  This means that there is no need for duplicate definitions. No changes to the protocol
  itself. :issue:`101`
- Only use JSON types. This means that "long" and "real" data types are removed since
  they don't exist in the ECMA standard. The data type "number" is added instead.
  :issue:`82`

**Minor clarifications**

- Add separate section for error handling. No changes to the protocol. :issue:`114`
- Include the full changelog.
- Correct spelling mistakes and fix minor issues.

Version 3.2
-----------
Release date: 2022-06-23

**Important changes**

* **Buffered messages**. The 'q' field in StatusUpdate should be changed when
  sending buffered messages. :issue:`73`

* **Case sensitive**. RSMP is now case sensitive. :issue:`35`

* **Connect to multiple supervisors**. Each site needs to support multiple
  RSMP connections (if required in the SXL). :issue:`19`

* **Array type**. Add ability to send a list of values :issue:`63`

**Minor clarifications**

- Clarify when commands/requests can be sent :issue:`34`
- Table in chapter 4.5.1.6 updated :issue:`55`
- The list of participants in the RSMP Nordic collaboration updated. :issue:`67`
- Fix in changelog for 3.1.3 "ageState" :issue:`69`
- How to reject a RSMP connection :issue:`38`
- How to determine RSMP version during handshake :issue:`43`
- Allow update of subscription interval time by sending new subscription request :issue:`52`
- Aggregated status without any bits set :issue:`57`
- Subscriptions should not persist across restarts/power outage :issue:`74`
- CommandRequest and CommandResponse can contain multiple requests/responses :issue:`58`
- null or empty string is allowed in functionalPostion/state :issue:`45`
- Respond with MessageNotAck if security code is incorrect :issue:`79`

Version 3.1.5
-------------
Release date: 2020-10-30

**MessageAck must be prioritized over buffered messages**

During communication establishment there may be buffered messages that needs
to be sent by the equipment. Sending any buffered messages is part of the
communication sequence, but it may take a long time to empty the buffer
in case of a slow network or long communication interruption. The equipment
must prioritize to respond with MessageAck to any requests that the
supervision system may send during this time. Discussed in :issue:`4`.
`View changes <https://github.com/rsmp-nordic/rsmp_core/commit/c6190f85e1bec18cce760040db922aef68eed7a3>`_

**Don't send new alarms if they're already active**

Clarify that new alarms shouldn't be sent if the alarm is already active.
No changes to the protocol itself.
Discussed in :issue:`18`

**Ability to request alarms and aggregated status**

Discussed in :issue:`22`

**Status subscriptions and update on change+interval**

Discussed in :issue:`21`

Version 3.1.4
-------------
Release date: 2017-11-03

**Alarm timestamps**

The Alarm timestamp (aSp) now also represents when the alarm changes status,
for instance when alarms turns inactive. See issue :issue:`1`

**Encryption**

Implementation of encryption support in the equipment is no longer mandatory
(it was introduced in 3.1.3)

**Connection establishment/handshake**

The connection establishment sequence has been clarified. The site begins
sending the version message.
All alarms (not just active and blocked) are sent during connection
establishment. Alarms may have turned inactive during communication
interruption. :issue:`3`

**Communication interruption**

Buffering should be possible to enable/disable for each status

If the version message hasn’t been successfully exchanged, then the
system/system must not respond with MessageAck/MessageNotAck to any RSMP
messages other than the version message. If no Ack is received then the
equipment and supervision system treats this a communication interruption and
disconnects. The site then reconnects with proper handshake according to
the connection establishment sequence.

**Watchdog**

The time sync using watchdog should be possible to enable/disable in the site

**Clarifications**

* The XML examples has been removed. Only JSon is used for message exchange
* Message exchange diagrams has been improved

Version 3.1.3
-------------
Release date: 2014-11-24

**Important changes**

* Encryption. All traffic should be possible to encrypt if required.
  Both supervision systems and sites should have to possibility to easily
  enable/disable encryption. SSL 3.0/TLS 1.0 or later should be used.
  Certificates is used to verify the identities for equipment.
  Equipment that uses RSMP should contain a interface for easy management
  of certificates. Generating of new certificates or renewal should be
  made by the client. Installation of new certificated should be done
  with consultation of the client.
* Added figures of message exchange during communication establishment
* Extended chapter about communication between sites
* Aggregated status is also sent between sites in order to inform about
  any active alarms
* The data types raw, scale, unit and ordinal removed since they are too
  ambiguous
* Subscriptions are not cancelled at communication interruptions. Cancelling
  subscriptions means that those messages are lost which makes debugging harder
* Active and blocked alarms are sent at communication reestablishment, but
  alarms which are not sent doesn't need to be interpreted as inactive since
  they are expected to be sent as part of buffered messages.
* 1000 buffered messages now changed to 10000 as minimum buffer size
* "q" can now have the state of "undefined" in case the object
  does not exist.
* With the exception of aggregated status only JSon string elements are used,
  and JSon number or boolean elements are not used. Some examples used wrong
  types and have been updated.
* If an object is not known during status request or command request, the
  site must not disconnect but instead reply with "q" set to "undefined"
* If a subscription is already active on a given status then the site
  should not establish a new subscription but use the existing one.
  StatusUpdate should not be sent as response in this case.
* The watchdog interval duration must be configurable with a default sent to
  once 1 minute (60 seconds)

**Adjustments**

* Chapter 4.1 (page 6): Typo. Five messages types are actually four.
* Chapter 5.5.1 (page 38). Typo in the table for JSon, "timestamp" should
  be "aTs"
* Chapter 5.5.1 (page 38): In the aggregated status, "name" is a positional
  element in JSon
* Chapter 5.5.3.2 (page 41): Unused elements remained in the examples for
  alarm acknowledgment message. "ack", "aS", "sS", "aTs", "cat", "pri", "rvs"
* The abbreviation SUL (for signal exchange list) changed to SXL
* Appendix 6.3.2 (page 7). Command messages has no return values.
  In RSMP 3.x and later commands only returns values based on the arguments
  in CommandResponse
* Fix typo. Incorrectly used "ageState" instead of "q"

**Clarifications**

* Chapter 5.3.1 (page 8): Clarification regarding the prerequisites when
  using separate signal exchange lists for different sites
* Chapter 5.3.2 (page 8): Clarification regarding reconnection after
  communication disruption. The site should automatically try to reconnect.
* Chapter 5.3.2 (page 8): As a default any active subscriptions should
  remain active during a communication interruption since they can be sent
  when connection is reestablished. But subscriptions of data of less
  importance and that may cause the buffer to reach is max capacity does
  not need to remain active. Which subscriptions to maintain must be
  configurable and done with consultation with the client.
* Chapter 5.4.1 (page 11): Clarification regarding how alarm acknowledgement
  works
* Chapter 5.5.3.4 (page 40): Structure of message for deactivation of blocked
  alarm added.
* Appendix 6.7.3 (page 12). Chapter of recommendations of contents in the SXL
  can be removed since alarm and aggregated status is always sent during
  communication establishment
* Appendix 6.4 (page 9). Chapter of configurable data areas removed since it
  is not used.

Version 3.1.2
-------------
Release date: 2012-02-29

The following typos has been fixed:

* Chapter 5.5.3.1 (page 38). "ts" should be "aTs"
* Chapter 5.5.6.2 (page 37). "aTS" should be "cTS"
* Chapter 5.5.1 (page 35). "returnvalues" should be "sS"
* Chapter 5.5.1, 5.5.8.1 (page 36, 50) "sIds" should be "siteId"
* Chapter 5.5.5.5 (page 46). "StatusUnSubscribe" should be "StatusUnsubscribe"
* Chapter 5.5.1, 5.5.6.1 (page 36, 47). "co" should be "cO"

The following clarifications has been made:

* On page 10,11,17,18,36,41: SequenceNumber removed completely
  (should have been removed already in previous version)
* Appendix, page 13: Alarm messages are also sent at alarm blocking
* Chapter 2: (page 2,4): Definitions of "NTS", "Object", NTS Object" and
  "component" updated. Added definition of "aggregated object",
  "NTS object type" and "component id"
* Chapter 5.4. (page 9, 11-14): Clarification regarding descriptions of
  "ntsObjectId", "externalNts", "componentId", "alarmCodeId",
  "externalNtsAlarmCodeId", "category" and "description"
* Chapter 5.4.6.1.1 (page 32-33) and appendix 6.2.2 (page 5).
  Clarifications regarding usage of siteId.
* Appendix 6.1.3 (page 4): Clarification regarding object definitions
* Appendix 6.2 (page 5,6,7): Clarification regarding descriptions about
  "componentId", "ntsObjectId", "externalNtsId", "alarmCodeId",
  "description", "externalAlarmCodeId", "category", "functionalState",
  "functionalPosition" and "Maneuver"


Version 3.1.1
-------------
Release date: 2011-12-23

* Command message (commandCodeId) moved to argument/return value. This
  makes it possible to send multiple commands in the same message.
* "ageState" was on the wrong place in the examples
* "value" renamed to "status" in status messages
* Clarified description of "siteId"
* Version message: "ntsObjectId" replaced with "siteId". All site identities
  (siteId) which are included in the communication is sent in the
  version message as a list.
* Adjusted the format of aggregated status in JSon. Sent as an array instead
* Time stamp in JSon adjusted. Now uses the same format as XML
* Clarification regarding the usage of JSon string elements

Version 3.0
-----------
Release date: 2011-11-04

* NTSObjectId changed to NTSOId in JSon
* All active alarms and blocked alarms are sent at restored communication,
  not just the changed alarm statues. All alarms which are not sent can
  therefore be interpreted as inactive. This proves a more complete update
  of all alarms in case the equipment has been reset and the current state
  of all alarms are unknown.
* Figures for the communication exchange for version and status updated

Version 2.0
-----------

* *Same as version 1.0 below*

Version 1.1o
------------
Release date: 2011-11-02

* sequenceNumber is removed from all message types

Version 1.1n
------------
Release date: 2011-11-02

* requestId (rId) removed. Sufficient data is available to tie a response
  to a request
* sequenceNumber (sNr, seqNr) is removed from status messages, but is kept
  in all other messages (alarm, events, aggregated status) which has used
  this since earlier.
* Typo for sequenceNumber in Json for event message (seqNr) fixed (sNr).
* "unknown" added as a possible ageState
* Clarification of aggregated status, 8-bit definition
* siteId changes name to ntsObjectId in SXL and message exchange. The
  exception is title for site in SXL. SXL Template updated.
* Alarm message adjusted so that is possible to determine if the alarm
  is issued, acknowledged or blocked (alarmSpecialistion)
* Time stamp for an alarm is issued (alarmTimestamp), acknowledged
  (ackTimestamp) and blocked (suspendTimestamp) merged to "timestamp".
  All examples updated
* Event messages is removed. All functionality of event messages is
  provided with status messages. The exception is the possibility who
  cased an event (supervision system or site), but this is better fitted
  to be added in the SXL, where applicable. Beyond this some of the
  recommendations is removed for the appendix, (Equipment starting,
  shuts down), message blocking active/inactive). Supervision system
  is expected to manage this anyway.
* Clarifications of in which order each message is sent at communication
  establishment (RSMP/SXL version, watchdog, ...)
* Adjusted requirement of communication buffer. Change to last 10000
  messages. FIFO should be used.
* Description fields (description, desc) is removed from alarm and
  statusmessages but is kept in SXL.
* Clarified that subscriptions is cancelled at communication disruptions
* References to VV:publ 2007:54 ISSN 1401-9612 for format of
  alarmCodeId/statusCodeId/commandCodeId

Version 1.1m
------------
Release date: 2011-11-01

* Fixed JSon example. It stated ctId instead of cId for componentId
* Removed incorrect text about prerequisites for sending in the appendix,
  page 6 - which was a residual from event message 2011-09-27
  Change name of alarms, events, status and commands for two letter prefix
  AL, EV, IS, MA, to a single letter prefix: A, H, S, M.
* Revision of SXL, Version of RSMP and watchdog configuration removed as
  recommended messages in SXL (appendix)
* The recently added column **Object (optional)** which is used for in a
  easier way tie alarms to individual objects is now also added for
  events, status and commands.
* Removed TYPE and VALUE for all message types (remains in SXL)
* Description removed from status message (remains in SXL)

Version 1.1l
------------
Release date: 2011-11-30

* New design of status messages

  * Makes it possible to send multiple requests in a single message and
    receive response in a single message
  * Makes it possible to subscribe to multiple status values, either
    by interval or on change
  * sequenceNumber (sNr) removed
  * "description" removed
  * "type" and "unit" removed (still left in SXL)

Version 1.1k 
------------
Release date: 2011-10-26

* Added a new message type for sending version of RSMP and revision of SXL,
  (rsmpVersion and sxlRevision)

Version 1.1j
------------
Release date: 2011-10-25

* Remove global time stamp for all message types
* Added timestamp for alarm acknowledgement, alarm blocking and watchdog
  for each message type
* Watchdog message reduced in size by removing siteId, externalNtsId and
  componentId
* Message acknowledgement reduced in size by removing messageId (only
  originalMessageId)
* Watchdog is now sent in both directions and should be used for time
  synchronization

Version 1.1i
------------
Release date: 2011-10-24

* Fixed JSon example. It stated ctId instead of cId for componentId

Version 1.1h
------------
Release date: 2011-10-20

* Typo in XML code 12
* SXL template: new column **Object (optional))** in alarm sheet
   *The purpose is that you should be a able to specify alarms for
   a specific object per site, since e.g a passage detector have
   several lasers with different alarm descriptions and id depending
   in where the detector is located. This extra column defines the
   specific object name, e.g. "Passage detector DP1'. If this column
   is left blank it means that this specific alarm is used for all
   "Passage detector" objects.*
* Added text about wrapping of JSon packets
* Added text about time stamps in JSon, and updated all JSon examples

Version 1.1g
------------
Release date: 2011-10-06

* Updated JSon examples
* Long as data type
* SXL template updated to match "configurable data areas"

Version 1.1f
------------
Release date: 2011-10-05

* Updated text about version management
* Continued work about "Integer" and "real as data types

Version 1.1e
------------
Release date: 2011-10-04

* Text about configurable data areas added in the appendix
* "Integer" and "real" as data types in arguments and return values
   (some work still needed)
* Text about version management

Version 1.1d
------------
Release date: 2011-09-27

* Add suggested changes from Acobia. TCP/IP as a definition
* Updated Data and transport chapter. JSon and pure TCP connection
* Added a new column in SXL which defined which prerequisites control
  when a event message is sent. The specification also updated

Version 1.1c
------------
Release date: 2011-09-26

* Remove argument at status request. There is no good reason for using
  arguments when command messages are better suited. No SXL uses this
* Move "command" in command message to argument. This enables multiple
  commands to be sent in a single message
* Added more JSon examples (watchdog + message acknowledements MessageNotAck)

Version 1.1b
------------
Release date: 2011-08-19

* Added chapter about JSon
* Removed "status" in StatusRequest. (No SXL uses this)
* Added time stamp in command responses (commandTimeStamp) and
  aggregated status (aggstatusTimeStamp)

Version 1.1a
------------
Release date: 2011-05-25

* Typo on page 7
* Typo on page 11 (appendix)

Version 1.0
-----------
Release date: 2011-05-20

* Clarifications regarding the signal exchange list added
* Clarifications about transport layer

*(Unofficial versions 1.1 and 2.0 are equal to this version)*

Version 1.0b
------------
Release date: 2011-01-12

* Added watchdog as separate message type

Version 1.0a
------------
Release date: 2010-10-08

* This version was used for the variable speed signs
* No changes since 0.97

Version 0.97
------------
Release date: 2010-10-07

* "number", "boolean" and "ordinal" added as possible data types in "type"
* Clarifications regarding binary data format (base64)

Version 0.96
------------
Release date: 2010-09-23

* Major update of the object model

  * The Object "returnvalue" and "argument" adjusted for global usage
    with it's associated contents. This removes limitations of the number
    of data values which can be included in a single message
  * Bit value of "aggregated status" redesigned for increased readability

Version 0.95
------------
Release date: 2010-09-01

* Minor adjustments of the document formatting

Version 0.94
------------
Release date: 2010-08-31

* Update of the object model
  * Namespace "message" removed
  * Added format, unit, value1 and value2 to alarm messages
  * actionCodeId renamed to eventCodeId in event messages
  * externalActionCodeId renamed to externalEventCodeId in event messages
  * functionalPosition data structure redesigned
  * "messageSpecialistation redesigned in status messages
* Clarifications about optional fields
* Added manufacturer specific alarm message (externalAlarmCodeId) in the
  XML example in 4.1.1.1
* Message acknowledgement updated and the ability to sent error message
  if the receiver didn't understand the message added

Version 0.93
------------
Release date: 2010-08-27

* On page 15 and 17 it was incorrectly stated that acknowledgement messages
  (and not alarm messages) should be sent to supervision system in case
  alarms are acknowledged locally.
* New figure for the message exchange for alarms in order to clarify the
  message exchange and make the figure more consistent with the other
  message types. No functional changes has been made
* Clarify figures regarding:

  * Message exchange when alarms are acknowledged/blocked locally
  * Message exchange is not dependent of being send/received in any
    particular order
* "alarmState" could enter two values, "ok" and "active". This has been
  changed to "inactive" and "active"

Version 0.92
------------
Release date: 2010-06-23

This version was distributed with the specifications for variable speed signs.
