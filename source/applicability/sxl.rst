.. _signal-exchange-list:

Signal Exchange List
====================

The signal exchange list is an important functional part of RSMP.
Since the contents of every message using RSMP is dynamic, a predefined
signal exchange list (:term:`SXL`) is prerequisite in order to be able to
establish communication.

The signal exchange list defines the alarms, commands and statuses which is
possible to send and receive for each object type.

The SXL can be defined by either a YAML file or an Excel file using predefined
principles which is defined below.

Object types
------------

An **object type** defines a type of object that can exist in a site,
i.e. "LED". Each object type can have a set of alarms, statuses and
commands associated with it.

Using the Excel format; objects types are defined in it's own sheet.
Using the YAML format; each object type is defined like this:

.. code-block:: yaml

   objects:
     [object-type]:

Where ``[object-type]`` is the name of the object type. For instance,
Traffic Light Controller".

Depending on applicability, each object type can either have it's own
series or common series of alarm suffix (alarmCodeId), status codes
(statusCodeId) and command codes (commandCodeId).

Message types
-------------

The message types **Alarm**, **Aggregated status**, **Status** and **Commands**
are defined in the SXL.

Using the Excel format; alarms, aggregated status, status and commands are
defined in their own sheet.

Using the YAML format; each message type is defined like this:

.. code-block:: yaml

  objects:
    object-type:
      aggregated_status:
        1:
          title: Local mode
          description: In local mode
        2:
          title: High priority fault
          description: Fail safe mode
      functional_position:
        position-1: Maximum setting
        position-2: Half setting
        position-3: Minimum setting
      alarms:
        A0001:
          description: alarm description text
          priority: 1
          category: D
          arguments:
            argument-1:
              type: integer
              min: 0
              max: 10
              descrition: A0001 argument 1
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
          arguments:
            argument-1:
              type: boolean
              description: M0001 argument 1

  ..

This example defines the alarm A0001, status S0001 and command M0001.
Each with one argument named "argument-1" using integer, string and boolean
data types.

It also defines the aggregated status (only bit 1 and 2) and :term:`functional
position`.

At least one argument are required for command and statuses, but they are
optional in alarms.

Functional differences between message types
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The following table defines the functional differences between message types.

.. tabularcolumns:: |\Yl{0.20}|\Yl{0.40}|\Yl{0.40}|

.. table:: Functional differences

   =================  =========================================  ================================
   Message type       Sent when                                  Adapted to be transmitted to NTS
   =================  =========================================  ================================
   Alarm              On change *or* request                     Yes
   Aggregated status  On change *or* request                     Yes
   Status             On request *or* according to subscription  No
   Command            On request                                 Yes, partly (functional status)
   =================  =========================================  ================================

.. note::
   In addition of :term:`functional position`, the Excel version of the SXL
   can also differentiate between different kinds of command messages using
   :term:`maneuver` and :term:`parameter` sections. However, their use has no
   functional significance from a protocol point of view.

Arguments and return values
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Argument and return values makes it possible to send extra information in
messages. It is possible to send binary data (base64), such as bitmap
pictures or other data, both to a site and to supervision system. The
signal exchange list must clarify exactly which data type which is used
in each case. There is no limitation of the number of arguments and
return values which can be defined for a given message. Argument and return
values is defined as extra columns for each row in the signal exchange
list.

- Arguments can be sent with command messages
- Return values can be send with response on status requests or as extra
  information with alarm messages

The following table defines the message types which supports arguments and
return values. 

.. tabularcolumns:: |\Yl{0.20}|\Yl{0.20}|\Yl{0.20}|

.. table:: Support for arguments and return values

   =================  ========  ============
   Message type       Argument  Return value
   =================  ========  ============
   Alarm              No        Yes
   Aggregated status  No        No
   Status             No        Yes
   Commands           Yes       No
   =================  ========  ============

Required signals
----------------

Status messages
^^^^^^^^^^^^^^^

Version of component
""""""""""""""""""""
To make sure that the site is equipped with the correct version of
components and to simplify troubleshooting there need to exists a special
status to request version of a component.

Current date and time
"""""""""""""""""""""
To make sure that the site is configured with the correct date and time
there needs to be a special status to request this. This type of status is
especially important for those implementations where the equipment's
protocol interface and the rest of it's logic doesn't share the same
clock. Please note that UTC should be used.

Command messages
^^^^^^^^^^^^^^^^

Change date and time
""""""""""""""""""""
If the automatic time synchronization is missing or disabled there should
be a possibility to set the date and time using a special command. Please
note that UTC should be used.

Best practices
--------------
In order to fit as many technical areas as possible there some flexibility
while designing a signal exchange list. Below are some suggested
recommendations.

Definition of object types
^^^^^^^^^^^^^^^^^^^^^^^^^^
The level of detail in the definition of object types determines the level
of detail of which:

- Messages can be sent, e.g. alarms and status
- Commands of individual object can be performed
- Information can be presented about the site for maintenance engineers in
  supervision system.

The benefits with a high level of details is:

- Provides the possibility to directly with the component identity be able
  to identify which object the status/alarm is relevant to, which help when
  troubleshooting equipment
- Provides the possibility to block alarm for each object identity

The benefit with a low level of detail is:

- Reduced need to update the signal exchange list due to changes at the
  site
  
The disadvantage with the being able to determine to component identity due
to a lower level of detail can be compensated with arguments and return
values.

Reading and writing data
^^^^^^^^^^^^^^^^^^^^^^^^
Read and write operations uses different message types in RSMP.

Read operation
""""""""""""""
Status messages are used for read operations. Read operations works
as "Process value".

Sequence for a read operation:

1. When data is about to be read a status request is sent from supervision
   system or other site to the relevant site.
2. The site responds by sending the value from the equipment. The value
   is attached as a return value.

Write operation
"""""""""""""""
Commands messages are used for write operations. Write operations works as
"Set point"/Desired value.

Sequence for a write operation:

1. When data is about be written a command request is sent from
   supervision system or other site the relevant site. The new value
   is attached as an argument.
2. The site is responding with returning the new value from the site,
   using the corresponding command response. The value from the site is
   attached as a return value.
3. The supervision system/other site compares the sent value (desired)
   with the new value from the site (actual value/process value) and can
   determine if the new value could be set or or not.

