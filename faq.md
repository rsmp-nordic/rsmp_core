FAQ
===

1, CommandResponse and verifing executed commands
-------------------------------------------------
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

2, CommandResponse and MessageAck
---------------------------------
Q: Does a CommandRequest return both a CommandResponse and a MessageAck?
Or is the CommandResponse sent instead of the MessageAck?

A: The equipment answers with both an ACK/NACK as well as an CommandResponse.

The NACK message is sent when there is an error on a protocol level, e.g.
incorrect JSon-format, command not found, etc. This message can be sent more or
less immediately after receiving the CommandRequest.


3, Version message and MessageAck
----------------------------------

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

4, Conditions for aggregated status bit 2 and bit 8
---------------------------------------------------
Q: Under which conditions would a TLC transmit an aggregated status where bit 2 is set to true *(No Communications)* or bit 8 *(The supervision system is not connected to the supervision system)*?

A: The purpose of aggregated status is to give a basic overview of the status of a site from the perspective of the supervision system. The 8 status bits are generically designed to fit all technical areas for road side equipment and they are not unique to RSMP.

It is true that the RSMP specification doesn't really explain this which bits are possible to send and which aren't, but it can theoretically differ depending of technical area and implementation of TLC.

The 8 status bits doesn't really contain any unique data - all the information are available in alarms and statuses. The 8 status bits are only present to ease the integration work with the existing NTS system within Trafikverket. We use seperate requirement documents for our supervision systems to explain the integration work needed for interfacing with our existing NTS system.
