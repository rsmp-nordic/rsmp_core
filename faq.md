FAQ
===

Contens
-------
+ [CommandResponse and verifying executed commands](#1)
+ [CommandResponse and MessageAck](#2)
+ [Version message and MessageAck](#3)
+ [Conditions for aggregated status bit 2 and bit 8](#4)
+ [Statuses with 'intersection'](#5)
+ [Command with 'intersection'](#6)
+ [Case sensitivity](#7)
+ [Missing MessageAck] (#8)

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
2, Watch the CommandReponse. Was the command accepted by the traffic controller?
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
Conditions for aggregated status bit 2 and bit 8
------------------------------------------------

Q: Under which conditions would a TLC transmit an aggregated status where bit 2
is set to true *(No Communications)* or bit 8 *(The supervision system is not
connected to the supervision system)*?

A: The purpose of aggregated status is to give a basic overview of the status
of a site from the perspective of the supervision system. The 8 status bits are
generically designed to fit all technical areas for road side equipment and they
are not unique to RSMP.

It is true that the RSMP specification doesn't really explain this which bits
are possible to send and which aren't, but it can theoretically differ depending
of technical area and implementation of TLC.

The 8 status bits doesn't really contain any unique data - all the information
are available in alarms and statuses. The 8 status bits are only present to ease
the integration work with the existing NTS system within Trafikverket. We use
separate requirement documents for our supervision systems to explain the
integration work needed for interfacing with our existing NTS system.

<a id="5"></a>
Statuses with 'intersection'
----------------------------

Q: S0007-S0013 and S0020 contain the return value 'intersection'.
How does this argument work?

A: 'intersection' contain the individual intersections of the TLC returned
as a comma separated list, e.g. "1,2,3". This applies to the corresponding
'status' as well, e.g. "True,True,False".

E.g. if a Traffic controller is controlling two intersections and both of
the intersections are using fixed time control the following is returned for
S0009: intersection="1,2", status="True,True".

The TLC may also return intersection='0', where '0' simply means all
intersections of the TLC.

This principle applies for all statuses where 'intersection' is used:
S0007, S0008, S0009 S0010, S0011, S0012, S0013 and S0020.

Using comma separated lists is not a perfect solution, but it is the way it is
solved in the current version of the SXL. A better solution is would be to use
'intersection' as object type in a future version of the SXL.

<a id="6"></a>
Command with 'intersection'
---------------------------

Q: The M0001 command contain the argument 'intersection'. How does this command
work?

A: The 'intersection' argument means which individual intersections the command
applies to. 'intersection' contain a comma separated list e.g. "1,2,3" of all
intersections. Just like the corresponding statuses which uses
'intersection', the 'status' also needs to be a comma separated list, e.g.
M0001: intersection="1,2", status="True,True".

The value of intersection='0' means it applies for all intersections.

Please note that not all TLC supports any other value than intersection='0'.

<a id="7"></a>
Case sensitivity
----------------
Q: Is RSMP case sensitive?

A: Short answer: Yes. It is important to use the same letter case as the
specification and SXL to avoid any unexpected issues.

Please note that the specification usually use elements with lower case,
e.g. "cat", "pri, "v,", q". However, the SXL may use upper case from time to
time, such as "True" and "False".

<a id="8"></a>
Missing MessageAck
------------------
Q: What is the policy for when a client does not receive an message acknowledge?

A: Starting with RSMP 3.1.4 is it specified in section 5.1.5 to treat a
missing MessageAck as a communication disruption and force a disconnection and
reconnection.

However, the assumption of this requirement is the communication has been lost
which is not necessarily true. For instance an equipment can be busy sending
messages and therefore won't reply with message acknowledgement quickly enough.
The recommendation is not to disconnect purely upon missing MessageAck, but
instead disconnect and reconnect in case of TCP timeout.
