.. _purpose:

Purpose
=======

The purpose of this protocol is to create a standardized way to
communicate between systems at the local level and systems at the
regional level regardless of supplier and technology. The goal is to
be able to easily add and remove signals in new facilities and
applications without having to expand or change the standards and
guidelines. This means that the protocol, as opposed to many other
standards and protocols do not include detailed information about the
signal exchange but is focused on defining the types of signals which
are then described construction or items specifically. The goal is
that in the long term, based on installed systems and objects, is to
be able to produce signal exchange lists of type object that can be
reused in new contracts so that alarm messages, commands, etc. have
the same names regardless of facility or provider.

The purpose of the signal exchange is to provide information relating
to, for example, traffic control managers and administrators. E.g. the
information needed to monitor and control the road side equipment, as
well as the information that can be used for statistics and analysis
of traffic and equipment's status. For instance, alarms contains
sufficient information to be able to create a work order in Maximo
which is then sent to the operating contractor, ie. sufficient
information about the type of skills and equipment necessary to
correct the error. Additional detailed information about an alarm
(e.g. which I/O card has broken, the LED chain that is out of order,
etc.) can read on site via vendor-specific web interface or operator
panel.

Identified requirements
-----------------------

In order to provide an information exchange that is not dependent of
technology area or vendor specific information - four message types
have been identified that cover all types of information that the
Swedish Transport Administration needs. The information in each
message is dynamic and is defined by technical area or specific
equipment using a specific signal exchange list (SXL). The SXL also
represents the interface between the supervision system / other
facilities and equipment. The four message types are:

- **Alarm**. System, traffic- or monitoring alarms that require action
  by the traffic operator or traffic engineer. Usually sent from the
  equipment to the monitoring system when they occur.

- **Aggregated status**. An aggregated status that gives an overview
  glance of the status of the road side equipment. Usually sent from
  the equipment as soon as it changes to the monitoring system.

- **Status**. Status changes, indications and detailed information
  should be logged or made visible at the monitoring system. Sent upon
  request from the supervision system / other facility or using
  subscription (either at status change or at set time interval).

- **Command**. Commands sent from a supervision system or other
  facility to alter the equipment / object status or control
  principle.
