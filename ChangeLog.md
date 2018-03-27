Version 3.1.4
=============

Alarm timestamps
----------------
The Alarm timestamp (aSp) now also represents when the alarm changes status,
for instance when alarms turns inactive. See issue
https://github.com/rsmp-nordic/rsmp_core/issues/1

Encryption
----------
Implementation of encryption support in the equipment is no longer mandatory
(it was introduced in 3.1.3)

Connection establishment/handshake
----------------------------------
The connection establishment sequence has been clarified. The site begins
sending the version message.
All alarms (not just active and blocked) are sent during connection
establishment. Alarms may have turned inactive during communication
interruption. https://github.com/rsmp-nordic/rsmp_core/issues/3

Communication interruption
--------------------------

Buffering should be possible to enable/disable for each status

If the version message hasn’t been successfully exchanged, then the
system/system must not respond with MessageAck/MessageNotAck to any RSMP
messages other than the version message. If no Ack is received then the
equipment and supervision system treats this a communication interruption and
disconnects. The site then reconnects with proper handshake according to
the connection establishment sequence.

Watchdog
--------
The time sync using watchdog should be possible to enable/disable in the site

Clarifications
--------------
* The XML examples has been removed. Only JSon is used for message exchange
* Message exchange diagrams has been improved

