FAQ
===

Contents
--------
+ [CommandResponse and verifying executed commands](#1)
+ [CommandResponse and MessageAck](#2)
+ [Version message and MessageAck](#3)
+ [Missing MessageAck](#4)

<a id="1"></a>
CommandResponse and verifying executed commands
-----------------------------------------------

Q: What is the purpose of the CommandResponse? Is it supposed to return the
values that we set with the CommandRequest? As a kind of echo? Or should it
return the current state of the variables, before the CommandRequest takes
place?

A: The CommandResponse is sent when the command has been accepted by the traffic
controller. The CommandResponse contains the same values of the CommandRequest
if the command was successful. If they are not the same values then the command
have failed.

(If the security code is incorrect it returns a blank value, otherwise the
CommandResponse would reveal the correct value)

There are many cases with road side equipment where it not possible to
immediately know if the command will actually be executed or not.
E.g. changing of a time plan can take a long time and the command can be
interrupted by other events of the equipment. The equipment may have accepted
the command but immediately changes status again due to other circumstances,
such as other local control, programming according to the clock, etc.
It depends on the implementation of the equipment.

If the RSMP command should "force" the command or not (have the highest
priority) depends on the configuration of the equipment.

To be sure that a command really has been executed the supervision system needs
to:
1, Watch the ACK/NACK. Was the command received and correctly formatted?
2, Watch the CommandResponse. Was the command accepted by the traffic controller?
3, Watch the corresponding statuses. Is the command actually executed (and
   remains active) within the expected time period?

<a id="2"></a>
CommandResponse and MessageAck
------------------------------

Q: Does a CommandRequest return both a CommandResponse and a MessageAck?
Or is the CommandResponse sent instead of the MessageAck?

A: The equipment answers with both an ACK/NACK as well as an CommandResponse.

The NACK message is sent when there is an error on a protocol level, e.g.
incorrect JSon-format, command not found, etc. This message can be sent more or
less immediately after receiving the CommandRequest.

<a id="3"></a>
Version message and MessageAck
------------------------------

Q: During integration test we saw some behavior which we found odd. We saw the
next exchange of messages:
```
Site   -> System: Version message
System -> Site:   Ack
System -> Site:   Version message
Site   -> System: Aggregated status
```

The system expected the site to send an acknowledgement on the version message
before it sends an aggregated status message. Is it allowed to send the
aggregated status message before all version messages including acknowledgements
are sent?

A: It is not allowed to send the aggregated status message before receiving
version message from the system. The site needs to make sure that the RSMP
version, site id and sxl revision matches in the version message from system.

<a id="4"></a>
Missing MessageAck
------------------
Q: What is the policy for when a client does not receive an message acknowledge?

A: Starting with RSMP 3.1.4 is it specified in section 5.1.5 to treat a
missing MessageAck as a communication disruption and force a disconnection and
reconnection.
