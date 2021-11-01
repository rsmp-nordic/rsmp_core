.. _basic-structure:

Basic structure
---------------

Unicode (ISO 10646) and UTF-8 are used for all messages. Please note that
the JSon elements are formatted as JSon string elements and not as JSon
number elements or as JSon boolean elements, with the exception of the
message type "aggregated status" and "status subscribe" where
JSon boolean elements are used.

The reason why JSon string elements are heavily used is to simplify
deserialisation of values where the data type in unknown before casting is
performed, for instance for the values in "return values".

Parsing needs to be performed case insensitive.

Empty values are sent as **""** for simple values and as **[]** for arrays.
Optional values can be omitted, but can not be sent as **null** unless
otherwise stated.

In the following example the message type is an alarm message.

.. code-block:: json
   :name: json-basic

   {
       "mType": "rSMsg",
       "type": "Alarm",
       "mId": "E68A0010-C336-41ac-BD58-5C80A72C7092",
       "ntsOId": "F+40100=416CG100",
       "xNId": "23055",
       "cId": "AB+84001=860SG001",
       "aCId": "A0001",
       "xACId": "Serious lamp error",
       "xNACId": "3143",
       "aSp": "Issue",
       "ack": "notAcknowledged",
       "aS": "Active",
       "sS": "notSuspended",
       "aTs": "2009-10-01T11:59:31.571Z",
       "cat": "D",
       "pri": "2",
       "rvs": [
           {
               "n": "color",
               "v": "red"
           }
       ]
   }

JSon code 2: An RSMP message

The following table is describing the variable content of all message types.

.. figtable::
   :nofig:
   :label: table-variable-content
   :caption: Variable content
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.20\linewidth} p{0.55\linewidth}

   +---------+-------------------+---------------------------------------+
   | Element | Value             | Description                           |
   +=========+===================+=======================================+
   | mType   | rSMsg             | RSMP identifier                       |
   +---------+-------------------+---------------------------------------+
   | type    | Alarm             | Alarm message                         |
   |         +-------------------+---------------------------------------+
   |         | AggregatedStatus  | Aggregated status message             |
   |         +-------------------+---------------------------------------+
   |         | StatusRequest     | Status message. Request status        |
   |         +-------------------+---------------------------------------+
   |         | StatusResponse    | Status message. Status response       |
   |         +-------------------+---------------------------------------+
   |         | StatusSubscribe   | Status message. Start subscription    |
   |         +-------------------+---------------------------------------+
   |         | StatusUpdate      | Status message. Update of status      |
   |         +-------------------+---------------------------------------+
   |         | StatusUnsubscribe | Status message. End subscription      |
   |         +-------------------+---------------------------------------+
   |         | CommandRequest    | Command message. Request command      |
   |         +-------------------+---------------------------------------+
   |         | CommandResponse   | Command message. Response of command  |
   |         +-------------------+---------------------------------------+
   |         | MessageAck        | Message acknowledegment. Successful   |
   |         +-------------------+---------------------------------------+
   |         | MessageNotAck     | Message acknowledegment. Unsuccessful |
   |         +-------------------+---------------------------------------+
   |         | Version           | RSMP / SXL version message            |
   |         +-------------------+---------------------------------------+
   |         | Watchdog          | Watchdog message                      |
   +---------+-------------------+---------------------------------------+
   | mId     | *(GUID)*          | Message identity. Generated as a GUID |
   | *(or)*  |                   | (Globally unique identifier) in the   |
   | oMId    |                   | equipment that sent the message. Only |
   |         |                   | version 4 of Leach-Salz UUID is used. |
   |         |                   |                                       |
   |         |                   | * **mId** is used i all messages as a |
   |         |                   |   reference for the message ack       |
   |         |                   | * **oMId** is used in the message ack |
   |         |                   |   to refer to the message which is    |
   |         |                   |   being acked                         |
   +---------+-------------------+---------------------------------------+

..

The following table describes the variable content in all message types
which is defined by the signal exchange list (SXL), except version
messages, message acknowledgement messages and watchdog messages.

The *SXL element* column describes the correlation between the JSon
elements and the titles in the SXL.

.. figtable::
   :nofig:
   :label: table-variable-content-sxl
   :caption: Variable content defined by SXL
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.08\linewidth} p{0.15\linewidth} p{0.65\linewidth}

   ============ ============== ===================
   Element      SXL element    Description
   ============ ============== ===================
   ntsOId       NTSObjectId    Component id for the NTS object which the  message is referring to.
   xNId         externalNtsId  Identity for the NTS object in communcation between NTS and other systems. The format is 5 integers. Defined in cooperation with representatives from NTS. Unique for the site.
   cId          componentId    Component id for the object which the message is referring to.
   ============ ============== ===================

..

.. _alarm-messages:

Alarm messages
^^^^^^^^^^^^^^

An alarm message is sent to the supervision system when:

- An alarm becomes active / inactive
- An alarm is requested
- An alarm is acknowledged
- An alarm is being suspended / un-suspended

An acknowledgment of an alarm does not cause a single alarm event to
be acknowledged but all alarm events for the specific object with the
associated alarm code id. This approach simplifies both in
implementation but also in handling - if many alarms occur on the same
equipment with short time intervals.

The ability to request an alarms is used in case the supervision system
looses track of the latest state of the alarms.

A suspend of an alarm causes all alarms from the specific object with
the associated alarm code id to be suspended. This means that alarm messages
stops being sent from the site as long as the suspension is active. As soon
as the suspension is inactivated alarms can be sent again.

Suspending alarms does not affect alarm acknowledgment. This means that
when unsuspending an alarm an alarm can be inactive and not acknowledged.

Alarm messages are event driven and sent to the supervision system
when the alarm occurs. Acknowledgement of alarms and alarm suspend
messages are interaction driven.

Alarm events are referring to 'active' (aSp:Issue), 'suspended' (aSp:Suspend)
and 'acknowledged' (aSp:Acknowledged).

The timestamp (aTs) reflects the individual event according to the
element 'aSp'.

Message structure
"""""""""""""""""

.. _structure-for-an-alarm-message:

Structure for an alarm message
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

An alarm message has the structure according to the example below.

.. code-block:: json
   :name: json-alarm-issue

   {
       "mType": "rSMsg",
       "type": "Alarm",
       "mId": "E68A0010-C336-41ac-BD58-5C80A72C7092",
       "ntsOId": "F+40100=416CG100",
       "xNId": "23055",
       "cId": "AB+84001=860SG001",
       "aCId": "A0001",
       "xACId": "Serious lamp error",
       "xNACId": "3143",
       "aSp": "Issue",
       "ack": "notAcknowledged",
       "aS": "Active",
       "sS": "notSuspended",
       "aTs": "2009-10-01T11:59:31.571Z",
       "cat": "D",
       "pri": "2",
       "rvs": [
           {
               "n": "color",
               "v": "red"
           }
       ]
   }

JSon code 3: An alarm message

The following table describes the variable content of the message which is
defined by the SXL.

The *SXL element* column describes the correlation between the JSon
elements and the titles in the signal exchange list (SXL).

.. figtable::
   :nofig:
   :label: table-alarm
   :caption: Alarm message
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.08\linewidth} p{0.25\linewidth} p{0.55\linewidth}

   ============ ====================== =============
   Element      SXL element            Description
   ============ ====================== =============
   aCId         alarmCodeId            Alarm suffix with in combination with the component id identifies an alarm. The examples in this document are defined according to the following format: *Ayyyy*, where *yyyy* is a unique number.
   xACId        externalAlarmCodeId    Manufacturer specific alarm code and alarm description. Manufacturer, model, alarm code och additional alarm description.
   xNACId       externalNtsAlarmCodeId Alarm code in order to identify alarm type during communication with NTS
   ============ ====================== =============

..

The following table describes additional variable content of the message.


.. figtable::
   :nofig:
   :label: table-alarm-status-change
   :caption: Alarm status change
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.08\linewidth} p{0.12\linewidth} p{0.20\linewidth} p{0.40\linewidth}

   +--------------+--------------------+--------------------+----------------------------------------------+
   | Element      | Value              | Origin             | Description                                  |
   +==============+====================+====================+==============================================+
   | aSp          | Issue              | Site               | An alarm becomes active/inactive.            |
   |              +--------------------+--------------------+----------------------------------------------+
   |              | Request            | Supervision system | Request the current state of an alarm        |
   |              +--------------------+--------------------+----------------------------------------------+
   |              | Acknowledge        | Supervision system | Acknowledge an alarm                         |
   |              |                    +--------------------+----------------------------------------------+
   |              |                    | Site               | An alarm becomes acknowledged.               |
   |              +--------------------+--------------------+----------------------------------------------+
   |              | Suspend            | Supervision system | Suspend an alarm                             |
   |              |                    +--------------------+----------------------------------------------+
   |              |                    | Site               | An alarm becomes suspended/unsuspended       |
   |              +--------------------+--------------------+----------------------------------------------+
   |              | Resume             | Supervision system | Unsuspend an alarm                           |
   +--------------+--------------------+--------------------+----------------------------------------------+

..


.. _alarm-status:

Alarm status
~~~~~~~~~~~~

Alarm status are only used by alarm messages (not by alarm acknowledgement
or alarm suspend messages).

.. figtable::
   :nofig:
   :label: table-alarm-status
   :caption: Alarm status
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.15\linewidth} p{0.60\linewidth}

   +-------------------+--------------------+------------------------------------------------------------------------------------+
   | Element           | Value              | Description                                                                        |
   +===================+====================+====================================================================================+
   | ack               | Acknowledged       | The alarm is acknowledged                                                          |
   |                   +--------------------+------------------------------------------------------------------------------------+
   |                   | notAcknowledged    | The alarm is not acknowledged                                                      |
   +-------------------+--------------------+------------------------------------------------------------------------------------+
   | aS                | inActive           | The alarm is inactive                                                              |
   |                   +--------------------+------------------------------------------------------------------------------------+
   |                   | Active             | The alarm is active                                                                |
   +-------------------+--------------------+------------------------------------------------------------------------------------+
   | sS                | suspended          | The alarm is suspended                                                             |
   |                   +--------------------+------------------------------------------------------------------------------------+
   |                   | notSuspended       | The alarm is not suspended                                                         |
   +-------------------+--------------------+------------------------------------------------------------------------------------+
   | aTs               | *(timestamp)*      | Timestamp for when the alarm changes status.                                       |
   |                   |                    | See the contents of aSp to determine which type of timetamp is used                |
   |                   |                    |                                                                                    |
   |                   |                    | | - aSp: Issue: Timestamp for when the alarm gets **active** or **inactive**       |
   |                   |                    | | - aSp: Acknowledge: Timestamp for when the alarm gets **acknowledged** or        |
   |                   |                    |   **not acknowledged**                                                             |
   |                   |                    | | - aSp: Suspend: Timestamp for when the alarm gets **suspended** or               |
   |                   |                    |   **not suspended**                                                                |
   |                   |                    |                                                                                    |
   |                   |                    | The timestamp uses the W3C XML **dateTime** definition with 3 decimal places.      |
   |                   |                    | All timestamps are set at the local level (and not in the supervision system) when |
   |                   |                    | the alarm occurs (and not when the message is sent). All timestamps uses UTC.      |
   +-------------------+--------------------+------------------------------------------------------------------------------------+

..

:numref:`alarm-transitions` show possible transitions between
different alarm states.

Continuous lines defines possible alarm status changes controlled by logic
and dashed lines defines possible changes controlled by user.

.. figure:: /img/dot/alarm_transitions.png
   :name: alarm-transitions
   :alt: Alarm transitions
   :align: center

   Alarm transitions

Alarms should not be sent unless:

* Alarms are unblocked and it's state changes
* Alarms are sent as part of
  :ref:`communication-establishment-between-sites-and-supervision-system`
* Alarms are explicitly requested using :ref:`alarmmessages-req`

The following table describes the variable content of the message which is
defined by the SXL.

The *SXL element* column describes the correlation between the JSon
elements and the titles in the signal exchange list (SXL).

.. figtable::
   :nofig:
   :label: table-alarm-status-details-sxl
   :caption: Alarm status details defined by SXL
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.12\linewidth} p{0.60\linewidth}

   +-------------------+--------------------+------------------------------------------------------------------------------------+
   | Element           | SXL element        | Description                                                                        |
   +===================+====================+====================================================================================+
   | cat               | category           | A character, either **T** or **D**.                                                |
   |                   |                    |                                                                                    |
   |                   |                    | | An alarm belongs to one of these categories:                                     |
   |                   |                    | | - T. Traffic alarm                                                               |
   |                   |                    | | - D. Technical alarm                                                             |
   |                   |                    |                                                                                    |
   |                   |                    | **Traffic alarm:**                                                                 |
   |                   |                    | Traffic alarms indicate events in the traffic related functions or the technical   |
   |                   |                    | processes that effects traffic.                                                    |
   |                   |                    |                                                                                    |
   |                   |                    | | A couple of examples from a tunnel:                                              |
   |                   |                    | | - Stopped vehicle                                                                |
   |                   |                    | | - Fire alarm                                                                     |
   |                   |                    | | - Error which affects message to motorists                                       |
   |                   |                    | | - High level of :math:`CO_{2}` in traffic room                                   |
   |                   |                    | | - Etc.                                                                           |
   |                   |                    |                                                                                    |
   |                   |                    | **Technical alarm:**                                                               |
   |                   |                    | Technical alarms are alarms that do not directly affect the traffic. One example   |
   |                   |                    | of a technical alarm is when an impulse fan stops working.                         |
   +-------------------+--------------------+------------------------------------------------------------------------------------+
   | *(not sent)*      | description        | Description of the alarm. Defined in SXL but is never actually sent.               |
   |                   |                    | The format of the description is free of choice but has the following              |
   |                   |                    | requirements:                                                                      |
   |                   |                    |                                                                                    |
   |                   |                    | - The text is unique for the object type                                           |
   |                   |                    | - The text is defined in cooperation with the Purchaser before use                 |
   +-------------------+--------------------+------------------------------------------------------------------------------------+
   | pri               | priority           | The priority of the alarm.                                                         |
   |                   |                    | The following values are defined:                                                  |
   |                   |                    |                                                                                    |
   |                   |                    | 1. Alarm that requires immediate action.                                           |
   |                   |                    | 2. Alarm that does not require immediate action, but action is planned during      |
   |                   |                    |    the next work shift.                                                            |
   |                   |                    | 3. Alarm that will be corrected during the next planned maintenance shift.         |
   +-------------------+--------------------+------------------------------------------------------------------------------------+

..

.. _return-values:

Return values
~~~~~~~~~~~~~

Return values ("rvs") are used by alarm messages (but not by alarm
acknowledgment or alarm suspend messages) and is always sent but can
be empty (i.e. **[]**) if no return values are defined.

.. figtable::
   :nofig:
   :label: table-alarm-return
   :caption: Alarm return values
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.08\linewidth} p{0.10\linewidth} p{0.60\linewidth}

   ======= ========== ===========
   Element Value      Description
   ======= ========== ===========
   rvs     *(array)*  Return values. Contains the element **n** and **v** in an array
   ======= ========== ===========

..

The following table describes the content for each return value which is
defined by the signal exchange list (SXL).

The *SXL element* column describes the correlation between the JSon
elements and the titles in the SXL.

.. figtable::
   :nofig:
   :label: table-alarm-return-values
   :caption: Alarm return value defined by SXL
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.12\linewidth} p{0.12\linewidth} p{0.60\linewidth}

   +-----------------+--------------------+-----------------------------------------------+
   | Element         | SXL element        | Description                                   |
   +=================+====================+===============================================+
   | n               | name               | Unique reference of the value                 |
   +-----------------+--------------------+-----------------------------------------------+
   | *(not sent)*    | type               | The data type of the value.                   |
   |                 |                    | Defined in the SXL but is not actually sent   |
   |                 |                    |                                               |
   |                 |                    | | General definition:                         |
   |                 |                    | | **string**: Text information                |
   |                 |                    | | **integer**: Numerical value                |
   |                 |                    |   (16-bit signed integer), [-32768 – 32767]   |
   |                 |                    | | **long**: Numerical value                   |
   |                 |                    |   (32-bit signed long)                        |
   |                 |                    | | **real**: Float                             |
   |                 |                    |   (64-bit double precision floating point)    |
   |                 |                    | | **boolean**: Boolean data type              |
   |                 |                    | | **base64**: Binary data expressed in        |
   |                 |                    |   base64 format according to RFC-4648         |
   |                 |                    |                                               |
   |                 |                    | Point (".") is always used as decimal mark    |
   +-----------------+--------------------+-----------------------------------------------+
   | v               | value              | Value from equipment                          |
   +-----------------+--------------------+-----------------------------------------------+

..

.. _alarmmessages-req:

Structure for alarm request message
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

An alarm request message has the structure according to the example below.

.. code-block:: json
   :name: json-alarm-req
   
   {
        "mType": "rSMsg",
        "type": "Alarm",
        "mId": "3d2a0097-f91c-4249-956b-dac702545b8f",
        "ntsOId": "",
        "xNId": "",
        "cId": "AB+84001=860VA001",
        "aCId": "A0004",
        "xACId": "",
        "xNACId": "",
        "aSp": "Request"
   }

JSon code 4: An alarm request message

.. _alarmmessages-ack:

Structure for alarm acknowledgement message
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

An alarm acknowledgement message has the structure according to the example
below.

.. code-block:: json
   :name: json-alarm-ack
   
   {
        "mType": "rSMsg",
        "type": "Alarm",
        "mId": "3d2a0097-f91c-4249-956b-dac702545b8f",
        "ntsOId": "",
        "xNId": "",
        "cId": "AB+84001=860VA001",
        "aCId": "A0004",
        "xACId": "",
        "xNACId": "",
        "aSp": "Acknowledge"
   }

JSon code 5: An alarm acknowledgement message which acknowledges an alarm

An alarm acknowledgement response message has the structure according to the
example below.

.. code-block:: json
   :name: json-alarm-ack-resp

   {
        "mType": "rSMsg",
        "type": "Alarm",
        "mId": "f6843ac0-40a0-424e-8ddf-d109f4cfe487",
        "ntsOId": "",
        "xNId": "",
        "cId": "AB+84001=860VA001",
        "aCId": "A0004",
        "xACId": "",
        "xNACId": "",
        "aSp": "Acknowledge",
        "ack": "Acknowledged",
        "aS": "Active",
        "sS": "notSuspended",
        "aTs": "2015-05-29T08:55:04.691Z",
        "cat": "D",
        "pri": "3",
        "rvs": [
            {
                "n": "Temp",
                "v": "-18.5"
            }
        ]
   }

JSon code 6: Response of an alarm acknowledgement message

.. _alarmmessages-suspend:

Structure for alarm suspend message
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

An alarm suspend message has the structure according to the example below.

.. code-block:: json
   :name: json-alarm-suspend

   {
        "mType": "rSMsg",
        "type": "Alarm",
        "mId": "b6579d6d-3a9d-4169-b777-f094946a863e",
        "ntsOId": "",
        "xNId": "",
        "cId": "AB+84001=860VA001",
        "aCId": "A0004",
        "xACId": "",
        "xNACId": "",
        "aSp": "Suspend"
   }

JSon code 7: Suspending an alarm using an alarm suspend message

.. code-block:: json
   :name: json-alarm-suspend-response

   {
        "mType": "rSMsg",
        "type": "Alarm",
        "mId": "2ea7edfc-8e3a-4765-85e7-db844c4702a0",
        "ntsOId": "",
        "xNId": "",
        "cId": "AB+84001=860VA001",
        "aCId": "A0004",
        "xACId": "",
        "xNACId": "",
        "aSp": "Suspend",
        "ack": "Acknowledged",
        "aS": "Active",
        "sS": "Suspended",
        "aTs": "2015-05-29T08:56:25.390Z",
        "cat": "D",
        "pri": "3",
        "rvs": [
            {
                "n": "Temp",
                "v": "-18.5"
            }
        ]
   }

JSon code 8: Response of alarm suspend message

.. code-block:: json
   :name: json-alarm-resume

   {
        "mType": "rSMsg",
	"type": "Alarm",
	"mId": "2a744145-403a-423f-ba80-f38e283a778e",
	"ntsOId": "",
	"xNId": "",
	"cId": "AB+84001=860VA001",
	"aCId": "A0004",
	"xACId": "",
	"xNACId": "",
	"aSp": "Resume"
   }

JSon code 9: Resuming an alarm using an alarm suspend message

.. code-block:: json
   :name: json-alarm-resume-response

   {
        "mType": "rSMsg",
        "type": "Alarm",
        "mId": "3313526e-b744-434a-b4dd-0cfa956512e0",
        "ntsOId": "",
        "xNId": "",
        "cId": "AB+84001=860VA001",
        "aCId": "A0004",
        "xACId": "",
        "xNACId": "",
        "aSp": "Suspend",
        "ack": "Acknowledged",
        "aS": "Active",
        "sS": "notSuspended",
        "aTs": "2015-05-29T08:58:28.166Z",
        "cat": "D",
        "pri": "3",
        "rvs": [
            {
                "n": "Temp",
                "v": "-18.5"
            }
        ]
   }

JSon code 10: Response of a resume message

Allowed content in alarm suspend message is the same as for alarm messages
(See :ref:`structure-for-an-alarm-message`) with the exception for alarm status
(See :ref:`alarm-status`) and (See :ref:`return-values`).

Message exchange between site and supervision system
""""""""""""""""""""""""""""""""""""""""""""""""""""

Message acknowledgement (see section :ref:`message-acknowledgement`) is
implicit in the following figures.

**An alarm is active/inactive**

.. image:: /img/msc/alarm_active_inactive.png
   :align: center

1. An alarm message is sent to supervision system with the status of the alarm (the alarm is active/inactive)

**An alarm is requested**

.. image:: /img/msc/alarm_request.png
   :align: center

1. An alarm is requested from the supervision system
2. An alarm message is sent to supervision system with the status of the alarm

**An alarm is acknowledged at the supervision system**

.. image:: /img/msc/alarm_ack_system.png
   :align: center

1. An alarm acknowledgement message is sent to the site
2. An alarm message is sent to the supervision system (that the alarm is acknowledged)

**An alarm is acknowledged at the site**

.. image:: /img/msc/alarm_ack_site.png
   :align: center

1. An alarm message is being sent to the supervision system with the status of the alarm (that the alarm is acknowledged)

**An alarm is suspended/unsuspended from the supervision system**

.. image:: /img/msc/alarm_suspend_system.png
   :align: center

1. An alarm suspend message is being sent to the site
2. An alarm message is sent to the supervision system with the status of the alarm (that the suspension is activated/deactivated)

**An alarm is suspended/unsuspended from the site**

.. image:: /img/msc/alarm_suspend_site.png
   :align: center

1. An alarm message is sent to the supervision system with the status of the alarm (that suspension is activated/deactivated)

.. _aggregated-status-message:

Aggregated status message
^^^^^^^^^^^^^^^^^^^^^^^^^

This type of message is sent to the supervision system to inform about the
status of the site. The aggregated status applies to the object which is
defined by **ObjectType** in the signal exchange list. If no object is defined
then no aggregated status message is sent.

Aggregated status message are interaction driven and are sent if state
bits, functional position or functional status are changed at the site.

Message structure
"""""""""""""""""

An aggregated status message has the structure according to the example
below.

.. code-block:: json
   :name: json-agg-status

   {
        "mType": "rSMsg",
	"type": "AggregatedStatus",
	"mId": "be12ab9a-800c-4c19-8c50-adf832f22420",
	"ntsOId": "O+14439=481WA001",
	"xNId": "",
	"cId": "O+14439=481WA001",
	"aSTS": "2015-06-08T08:05:06.584Z",
	"fP": null,
	"fS": null,
	"se": [
                true,false,false,false,false,false,false,false
              ]
   }

JSon code 11: An aggregated status message

The following tables are describing the variable content of the message:

.. figtable::
   :nofig:
   :label: table-agg-basic
   :caption: Aggregated status
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.15\linewidth} p{0.60\linewidth}

   ================== ============= ==========================================
   Element            Value         Description
   ================== ============= ==========================================
   aSTS               *(timestamp)* The timestamp uses the W3C XML dateTime
                                    definition with a 3 decimal places. All
                                    timestamps are set at the local level
                                    (and not in the supervision system) when
                                    the event occurs (and not when the
                                    message is sent). All timestamps uses UTC.
   ================== ============= ==========================================

..

The following table describes the variable content defined by the signal
exchange list (SXL). The *SXL element* column describes the correlation
between the JSon elements and the titles in the SXL.

.. figtable::
   :nofig:
   :label: table-agg-specialisation
   :caption: Aggregated status SXL content
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.20\linewidth} p{0.50\linewidth}

   +--------------------+--------------------+----------------------------------------------------------------+
   | Element            | SXL element        | Description                                                    |
   +====================+====================+================================================================+
   | fP                 | functionalPosition | Functional position. Is **null** if no value is defined in SXL.|
   +--------------------+--------------------+----------------------------------------------------------------+
   | fS                 | functionalState    | Functional state. Is **null** if no value is defined in SXL.   |
   +--------------------+--------------------+----------------------------------------------------------------+
   | se                 | State              | Status bits. 8 bit status bit array, where each element is     |
   |                    |                    | defined as either **true** or **false**.                       |
   |                    |                    | This status bit array defines the status of the site to NTS    |
   +--------------------+--------------------+----------------------------------------------------------------+

..


Status bits (state)
~~~~~~~~~~~~~~~~~~~

The principle of aggregating of statuses for each bit is defined by the
associated comments in the signal exchange list (SXL). A generic
description of each bit is presented in the figure below

.. image:: /img/msc/agg_status_bits.png
   :align: center

.. _aggregated-status-req:

Aggregated status request message
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This type of message is sent from the supervision system to request the
latest aggregated status, in case the supervision system has lost track
of the current status.

Message structure
"""""""""""""""""

An aggregated status request message has the structure according to the example
below.

.. code-block:: json
   :name: json-agg-req-status

   {
        "mType": "rSMsg",
	"type": "AggregatedStatusRequest",
	"mId": "be12ab9a-800c-4c19-8c50-adf832f22425",
	"ntsOId": "O+14439=481WA001",
	"xNId": "",
	"cId": "O+14439=481WA001",
   }

JSon code 12: An aggregated status request message


Message exchange between site and supervision system
""""""""""""""""""""""""""""""""""""""""""""""""""""

Message acknowledgement (see section :ref:`message-acknowledgement`) is
implicit in the following figures.

**Functional state, functional position or status bits changes at the
site**


.. image:: /img/msc/aggregated_status.png
   :align: center

1. An aggregated status message is sent to the supervision system.

**The supervision system request aggregated status**

.. image:: /img/msc/aggregated_status_request.png
   :align: center

1. An aggregated status request message is sent to the site.
2. An aggregated status message is sent to the supervision system.

Status Messages
^^^^^^^^^^^^^^^

The status message is a type of message that is sent to the
supervision system or other equipment with the status of one or more
requested objects.

The status message can both be interaction driven or event driver and
can be sent during the following prerequisites:

- When status is requested from the supervision system or other equipment.
- According to subscription – either by using a fixed time interval or
  when the status changes.

Message structure
"""""""""""""""""

Structure for a request of a status of one or several objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A status request message has the structure according to the example
below.

.. code-block:: json
   :name: json-status-req

   {
        "mType": "rSMsg",
	"type": "StatusRequest",
	"mId": "f1a13213-b90a-4abc-8953-2b8142923c55",
	"ntsOId": "O+14439=481WA001",
	"xNId": "",
	"cId": "O+14439=481WA001",
	"sS": [
            {
                "sCI": "S0003",
                "n": "inputstatus"
            },{
                "sCI": "S0003",
	        "n": "extendedinputstatus"
            }
        ]
   }

JSon code 13: A status request message

The status code id (**sCI**) and name (**n**) are placed in an array
(**sS**) in order to enable support for requesting multiple status at once.
The following table is describing the variable content of the message.

The *SXL element* column describes the correlation between the JSon
elements and the titles in the SXL.

.. _table-statusrequest:

.. figtable::
   :nofig:
   :caption: Status request
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.15\linewidth} p{0.60\linewidth}

   ============ ============ ===================
   Element      SXL element  Description
   ============ ============ ===================
   sCI          statusCodeId The Status code id. The examples is this document are defined according to the following format: *Syyyy*, where *yyyy* is a unique number.
   n            name         Unique reference of the value
   ============ ============ ===================

..

Structure for a message with status of one or several objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A message with status of one or several objects has the structure
according to the example below.

If the component (**cId**) is not known, then the site must not disconnect but
instead answer with this type of message where **q** is set to **undefined**.

.. code-block:: json
   :name: json-status-response

   {
        "mType": "rSMsg",
        "type": "StatusResponse",
        "mId": "0a95e463-192a-4dd7-8b57-d2c2da636584",
        "ntsOId": "O+14439=481WA001",
        "xNId": "",
        "cId": "O+14439=481WA001",
        "sTs": "2015-06-08T09:15:18.266Z",
        "sS": [
            {
                "sCI": "S0003",
                "n": "inputstatus",
                "s": "100101",
                "q": "recent"
            },{
                "sCI": "S0003",
                "n": "extendedinputstatus",
                "s": "100100101",
                "q": "recent"
            }
       ]
   }

JSon code 14: A status response message


The following table is describing the variable content of the message:

.. _table-statusresponse:

.. figtable::
   :nofig:
   :caption: Status response
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.15\linewidth} p{0.55\linewidth}

   +-----------------+--------------------+--------------------------------------------+
   | Element         | Value              | Description                                |
   +=================+====================+============================================+
   | sTs             | *(timestamp)*      | Timestamp for the status. The timestamp    |
   |                 |                    | uses the W3C XML dateTime                  |
   |                 |                    | definition with a 3 decimal places. All    |
   |                 |                    | timestamps are set at the site (and not in |
   |                 |                    | the supervision system) when the status is |
   |                 |                    | fetched (and not when the message is sent) |
   |                 |                    | All timestamps uses UTC.                   |
   +-----------------+--------------------+--------------------------------------------+

..

Return values (returnvalue)
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Return values ("sS") are always sent but can be empty if no return values exists.

.. figtable::
   :nofig:
   :label: table-statusresponse-returnvalues-sS
   :caption: Return values (returnvalue)
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.10\linewidth} p{0.70\linewidth}

   ========== ========== ===================
   Element    Value      Description
   ========== ========== ===================
   sS         *(array)*  Return values. Contains the elements "sCI", "s", "n" and "q" in an array.
   ========== ========== ===================

..

.. _table-statusresponse-returnvalues:

.. figtable::
   :nofig:
   :caption: Return values (returnvalue)
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.15\linewidth} p{0.60\linewidth}

   +-----------------+--------------------+-----------------------------------------------+
   | Element         | SXL element        | Description                                   |
   +=================+====================+===============================================+
   | sCI             | statusCodeId       | The Status code id.                           |
   |                 |                    | The examples in this document are defined     |
   |                 |                    | according to the following format: *Syyyy*,   |
   |                 |                    | where *yyyy* is a unique number.              |
   +-----------------+--------------------+-----------------------------------------------+
   | n               | Name               | Unique reference of the value                 |
   +-----------------+--------------------+-----------------------------------------------+
   | *(not sent)*    | Type               | The data type of the value.                   |
   |                 |                    | Defined in the SXL but is not actually sent   |
   |                 |                    |                                               |
   |                 |                    | | General definition:                         |
   |                 |                    | | **string**: Text information                |
   |                 |                    | | **integer**: Numerical value                |
   |                 |                    |   (16-bit signed integer), [-32768 – 32767]   |
   |                 |                    | | **long**: Numerical value                   |
   |                 |                    |   (32-bit signed long)                        |
   |                 |                    | | **real**: Float                             |
   |                 |                    |   (64-bit double precision floating point)    |
   |                 |                    | | **boolean**: Boolean data type              |
   |                 |                    | | **base64**: Binary data expressed in        |
   |                 |                    |   base64 format according to RFC-4648         |
   +-----------------+--------------------+-----------------------------------------------+
   | s               | Value              | Value                                         |
   +-----------------+--------------------+-----------------------------------------------+
   | *(not sent)*    | Comment            | Description for the status request.           |
   |                 |                    | Defined in the SXL but is not actually        |
   |                 |                    | sent.                                         |
   +-----------------+--------------------+-----------------------------------------------+

..

The following table describes additional variable content of the message.

.. figtable::
   :nofig:
   :label: table-statusresponse-returnvalues-quality
   :caption: Return value quality
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.08\linewidth} p{0.15\linewidth} p{0.65\linewidth}

   +-----------------+--------------------+-----------------------------------------------+
   | Element         | Value              | Description                                   |
   +=================+====================+===============================================+
   | q               | recent             | The value is up to date                       |
   |                 +--------------------+-----------------------------------------------+
   |                 | old                | The value is not up to date.                  |
   |                 |                    | Used when sending buffered values             |
   |                 +--------------------+-----------------------------------------------+
   |                 | undefined          | The component does not exist and no           |
   |                 |                    | subscription will be performed.               |
   |                 |                    | **s** should be set to **null**.              |
   |                 +--------------------+-----------------------------------------------+
   |                 | unknown            | The value is unknown and no subscription will |
   |                 |                    | be performed.                                 |
   |                 |                    | **s** should be set to **null**.              |
   +-----------------+--------------------+-----------------------------------------------+

..

Structure for a status subscription request message on one or several objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A message with the request of subscription to a status has the
structure according to the example below. The message is used for
constructing a list of subscriptions of statuses, digital and analogue
values and events that are desirable to send to supervision system,
e.g. temperature, wind speed, power consumption, manual control.

.. code-block:: json
   :name: json-status-subscribe

   {
        "mType": "rSMsg",
        "type": "StatusSubscribe",
        "mId": "d6d97f8b-e9db-4572-8084-70b55e312584",
        "ntsOId": "O+14439=481WA001",
        "xNId": "",
        "cId": "O+14439=481WA001",
        "sS": [
            {
                "sCI": "S0001",
                "n": "signalgroupstatus",
                "uRt": "5",
                "sOc": false
            },{
                "sCI": "S0001",
                "n": "cyclecounter",
                "uRt": "5",
                "sOc": false
            },{
                "sCI": "S0001",
                "n": "basecyclecounter",
                "uRt": "5",
                "sOc": false
            },{
                "sCI": "S0001",
                "n": "stage",
                "uRt": "5",
                "sOc": false
            }
        ]
   }

JSon code 15: A status subscribe message 

The following table is describing the variable content of the message:

.. figtable::
   :nofig:
   :label: table-statusrequest-basic
   :caption: Status Request
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.10\linewidth} p{0.70\linewidth}

   +------------+------------+--------------------------------------------------------+
   | Element    | Value      | Description                                            |
   +============+============+========================================================+
   | uRt        | *(string)* | updateRate. Determines the interval of which the       |
   |            |            | message should be sent.                                |
   |            |            | Defined in seconds with decimals, e.g. ”2.5” for       |
   |            |            | 2.5 seconds. Dot (.) is used as decimal point.         |
   |            |            | If “0” it means that the value should not be sent      |
   |            |            | according to an interval                               |
   +------------+------------+--------------------------------------------------------+
   | sOc        | boolean    | sendOnChange. Determines if the message should be sent |
   |            |            | when the value changes.                                |
   +------------+------------+--------------------------------------------------------+

..

The **updateRate** (uRt) and **sendOnChange** (sOc) determines when a
status update should be sent. **updateRate** defines a specific interval
when to send updates. If **updateRate** is set to "0" it means that no
update is sent using an interval. **sendOnChange** defines if an status
update should be sent as soon as the value changes.

It is possible to combine **updateRate** and **sendOnChange** to send an
update when the value changes and at the same time using a specific
interval.


Structure for a response message with answer to a request for status subscription for one or several objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A response message with answer to a request for status subscription
has the structure according to the example below. This response is
always sent immediately after request for subscription regardless if
the value recently changed or as an effect of the interval for the
subscription. The reason for sending the response immediately is
because subscriptions usually are established shortly after RSMP
connection establishment and the supervision system needs to update
with the current statuses and events.
If an subscription is already active then the site must not establish
a new subscription but use the existing one. This message type should
not be sent if the subscription already exist.
If the object is not known then the site must not disconnect
but instead answer with this type of message where **q** is set to
**undefined**.

.. code-block:: json
   :name: json-status-update

   {
        "mType": "rSMsg",
        "type": "StatusUpdate",
        "mId": "dabb67f9-2601-4db9-bb8a-c7c47f57e100",
        "ntsOId": "O+14439=481WA001",
        "xNId": "",
        "cId": "O+14439=481WA001",
        "sTs": "2015-06-08T09:33:04.735Z",
        "sS": [
            {
                "sCI": "S0001",
                "n": "signalgroupstatus",
                "s": "A021BC01",
                "q": "recent"
            },{
                "sCI": "S0001",
                "n": "cyclecounter",
                "s": "20",
                "q": "recent"
            },{
                "sCI": "S0001",
                "n": "basecyclecounter",
                "s": "10",
                "q": "recent"
            },{
                "sCI": "S0001",
                "n": "stage",
                "s": "1",
                "q": "recent"
            }
        ]
   }

JSon code 16: A status update message

The allowed content is described in Table
:ref:`Status response<table-statusresponse>` and
:ref:`Return values<table-statusresponse-returnvalues>`.

Since different UpdateRate can be defined for different objects it means that
partial StatusUpdates can be sent.

.. code-block:: json
   :name: json-status-request-partial

   {
        "mType": "rSMsg",
        "type": "StatusSubscribe",
        "mId": "6bbcb26e-78fe-4517-9e3d-8bb4f972c076",
        "ntsOId": "",
        "xNId": "",
        "cId": "O+14439=481WA001",
        "sS": [
            {
                "sCI": "S0096",
                "n": "hour",
                "uRt": "120",
                "sOc": false
            },{
                "sCI": "S0096",
                "n": "minute",
                "uRt": "60",
                "sOc": false
            }
        ]
   }

JSon code 17: A subscription request to subscribe to statues with different update rates

.. code-block:: json
   :name: json-status-request-partial-resp

   {
        "mType": "rSMsg",
        "type": "StatusUpdate",
        "mId": "b6bd7c96-f150-4756-9752-47a661e116db",
        "ntsOId": "",
        "xNId": "",
        "cId": "O+14439=481WA001",
        "sTs": "2015-05-29T13:47:56.740Z",
        "sS": [
            {
                "sCI": "S0096",
                "n": "minute",
                "s": "47",
                "q": "recent"
            }
        ]
   }

JSon code 18: A partial status update. Only a single status is updated


Structure for a status unsubscription message on one or several objects
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A message with the request of unsubscription to a status has the structure
according to the example below. The request unsubscribes on one or several
objects. No particular answer is sent for this request, other than the
usual message acknowledgement.

.. code-block:: json
   :name: json-status-unsubscribe

   {
        "mType": "rSMsg",
        "type": "StatusUnsubscribe",
        "mId": "5ff528c5-f2f0-4bc4-a335-280c52b6e6d8",
        "ntsOId": "O+14439=481WA001",
        "xNId": "",
        "cId": "O+14439=481WA001",
        "sS": [
            {
                "sCI": "S0001",
                "n": "signalgroupstatus"
            },{
                "sCI": "S0001",
                "n": "cyclecounter"
            },{
                "sCI": "S0001",
                "n": "basecyclecounter"
            },{
                "sCI": "S0001",
                "n": "stage"
            }
        ]
   }

JSon code 19: A status unsubscribe message

The allowed content is described in Table
:ref:`Status Request <table-statusrequest>`

Message exchange between site and supervision system/other equipment - request
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Message acknowledgement (see section :ref:`message-acknowledgement`) is
implicit in the following figure.

.. image:: /img/msc/status_request_response.png
   :align: center

1. Request of status for an object
2. Response with status of an object

Message exchange between site and supervision system/other equipment - subscription
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Message acknowledgement (see section :ref:`message-acknowledgement`) is
implicit in the following figure.

.. image:: /img/msc/status_update.png
   :align: center

Example of message exchange with subscription, status updates and unsubscription.

Command messages
^^^^^^^^^^^^^^^^

Command messages are used to give order to do something at the site.
The site responds with a command acknowledgement.

Command messages are interaction driven and are sent when command are
requested on any given object by the supervision system or other equipment

Message structure
"""""""""""""""""

Structure of a command message request

A command request message has the structure according to the example
below. A command request message with the intent to change a value of the
requested object

.. code-block:: json
   :name: json-command-req

   {
        "mType": "rSMsg",
        "type": "CommandRequest",
        "mId": "cf76365e-9c7b-44a4-86bd-d107cdfc3fcf",
        "ntsOId": "O+14439=481WA001",
        "xNId": "",
        "cId": "O+14439=481WA001",
        "arg": [
            {
                "cCI": "M0001",
                "n": "status",
                "cO": "setValue",
                "v": "YellowFlash"
            },{
                "cCI": "M0001",
                "n": "securityCode",
                "cO": "setValue",
                "v": "123"
            },{
                "cCI": "M0001",
                "n": "timeout",
                "cO": "setValue",
                "v": "30"
            },{
                "cCI": "M0001",
                "n": "intersection",
                "cO": "setValue",
                "v": "1"
            }
        ]
   }

JSon code 20: A command request message


The following table is describing the variable content of the message:

Values to send with the command (arguments)

.. figtable::
   :nofig:
   :label: table-commands-argument
   :caption: Command argument
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.10\linewidth} p{0.60\linewidth}

   ============ ============ =============
   Element      Value        Description
   ============ ============ =============
   arg          *(array)*    Argument. Contains the element **cCI**, **n**, **cO**, **v** in an array
   ============ ============ =============
..

The following table describes the variable content of the message which is
defined by the SXL.

The *SXL element* column describes the correlation between the JSon
elements and the titles in the signal exchange list (SXL).

.. figtable::
   :nofig:
   :label: table-command-arguments-sxl
   :caption: Command arguments defined by SXL
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.18\linewidth} p{0.60\linewidth}

   +-----------------+--------------------+-----------------------------------------------+
   | Element         | SXL element        | Description                                   |
   +=================+====================+===============================================+
   | cCI             | commandCodeId      | The uniqe code of a command request.          |
   |                 |                    | The examples in this document are defined     |
   |                 |                    | according to the following format: *Myyyy*,   |
   |                 |                    | where *yyyy* is a unique number.              |
   +-----------------+--------------------+-----------------------------------------------+
   | *(not sent)*    | Description        | Description for the command request.          |
   |                 |                    | Defined in the SXL but is not actually        |
   |                 |                    | sent.                                         |
   +-----------------+--------------------+-----------------------------------------------+
   | n               | Name               | Unique reference of the value                 |
   +-----------------+--------------------+-----------------------------------------------+
   | cO              | Command            | Command                                       |
   +-----------------+--------------------+-----------------------------------------------+
   | *(not sent)*    | Type               | The data type of the value.                   |
   |                 |                    | Defined in the SXL but is not actually sent   |
   |                 |                    |                                               |
   |                 |                    | | General definition:                         |
   |                 |                    | | **string**: Text information                |
   |                 |                    | | **integer**: Numerical value                |
   |                 |                    |   (16-bit signed integer), [-32768 – 32767]   |
   |                 |                    | | **long**: Numerical value                   |
   |                 |                    |   (32-bit signed long)                        |
   |                 |                    | | **real**: Float                             |
   |                 |                    |   (64-bit double precision floating point)    |
   |                 |                    | | **boolean**: Boolean data type              |
   |                 |                    | | **base64**: Binary data expressed in        |
   |                 |                    |   base64 format according to RFC-4648         |
   +-----------------+--------------------+-----------------------------------------------+
   | v               | Value              | Value                                         |
   +-----------------+--------------------+-----------------------------------------------+

..

Structure of command response message
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A command response message has the structure according to the example
below. A command response message informs about the updated value of the
requested object.
If the object is not known then the site must not disconnect
but instead answer with this type of message where **age** is set to
**undefined**.

.. code-block:: json
   :name: json-command-response

   {
        "mType": "rSMsg",
        "type": "CommandResponse",
        "mId": "0fd63726-be19-4c09-8553-48451735cb0b",
        "ntsOId": "O+14439=481WA001",
        "xNId": "",
        "cId": "O+14439=481WA001",
        "cTS": "2015-06-08T11:49:03.293Z",
        "rvs": [
             {
                "cCI": "M0001",
                "n": "status",
                "v": "YellowFlash",
                "age": "recent"
             },{
                "cCI": "M0001",
                "n": "securityCode",
                "v": "123",
                "age": "recent"
             },{
                "cCI": "M0001",
                "n": "timeout",
                "v": "30",
                "age": "recent"
             },{
                "cCI": "M0001",
                "n": "intersection",
                "v": "1",
                "age": "recent"
             }
        ]
   }

JSon code 21: A command response message

The following table is describing the variable content of the message:

.. figtable::
   :nofig:
   :label: table-command-response
   :caption: Command response
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.15\linewidth} p{0.65\linewidth}

   +------------------+--------------------+------------------------------------------------------------------------------------+
   | Element          | Value              | Description                                                                        |
   +==================+====================+====================================================================================+
   | cTS              | *(timestamp)*      | The timestamp uses the W3C XML dateTime definition with a 3 decimal places.        |
   |                  |                    | All timestamps are set at the local level (and not in the supervision system) when |
   |                  |                    | the alarm occurs (and not when the message is sent). All timestamps uses UTC.      |
   +------------------+--------------------+------------------------------------------------------------------------------------+

..

Return values (returnvalue)
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Return values (**rvs**) is always sent but can
be empty if not return values are defined.

.. figtable::
   :nofig:
   :label: table-command-returnvalues-rvs
   :caption: Command return values
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.10\linewidth} p{0.70\linewidth}

   ========= ========= =============
   Element   Value     Description
   ========= ========= =============
   rvs       *(array)* Return values. Contains the elements **cCI**, **v**, **n** and **q** in an array.
   ========= ========= =============

..

The following table describes the variable content defined by the signal
exchange list (SXL). The *SXL element* column describes the correlation
between the JSon elements and the titles in the SXL.

.. figtable::
   :nofig:
   :label: table-command-returnvalue-sxl
   :caption: Command return value defined by SXL
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.20\linewidth} p{0.60\linewidth}

   +-----------------+--------------------+-----------------------------------------------+
   | Element         | SXL element        | Description                                   |
   +=================+====================+===============================================+
   | cCI             | commandCodeId      | The uniqe code of a command.                  |
   |                 |                    | The examples in this document are defined     |
   |                 |                    | according to the following format: *Myyyy*,   |
   |                 |                    | where *yyyy* is a unique number.              |
   +-----------------+--------------------+-----------------------------------------------+
   | n               | Name               | Unique reference of the value                 |
   +-----------------+--------------------+-----------------------------------------------+
   | *(not sent)*    | Type               | The data type of the value.                   |
   |                 |                    | Defined in the SXL but is not actually sent   |
   |                 |                    |                                               |
   |                 |                    | | General definition:                         |
   |                 |                    | | **string**: Text information                |
   |                 |                    | | **integer**: Numerical value                |
   |                 |                    |   (16-bit signed integer), [-32768 – 32767]   |
   |                 |                    | | **long**: Numerical value                   |
   |                 |                    |   (32-bit signed long)                        |
   |                 |                    | | **real**: Float                             |
   |                 |                    |   (64-bit double precision floating point)    |
   |                 |                    | | **boolean**: Boolean data type              |
   |                 |                    | | **base64**: Binary data expressed in        |
   |                 |                    |   base64 format according to RFC-4648         |
   +-----------------+--------------------+-----------------------------------------------+
   | v               | Value              | Value                                         |
   +-----------------+--------------------+-----------------------------------------------+

..

The following table describes additional variable content of the message.

.. figtable::
   :nofig:
   :label: table-command-returnvalue
   :caption: Command return value
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.08\linewidth} p{0.10\linewidth} p{0.30\linewidth}

   +-----------------+--------------------+-----------------------------------------------+
   | Element         | Value              | Description                                   |
   +=================+====================+===============================================+
   | age             | recent             | The value is up to date                       |
   |                 +--------------------+-----------------------------------------------+
   |                 | old                | The value is not up to date                   |
   |                 +--------------------+-----------------------------------------------+
   |                 | undefined          | The component does not exist.                 |
   |                 |                    | **v** should be set to **null**.              |
   |                 +--------------------+-----------------------------------------------+
   |                 | unknown            | The value is unknown.                         |
   |                 |                    | **v** should be set to **null**.              |
   +-----------------+--------------------+-----------------------------------------------+

..

Message exchange between site and supervision system/other equipment
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Message acknowledgement (see section :ref:`message-acknowledgement`) is
implicit in the following figure.

.. image:: /img/msc/command_request_response.png
   :align: center

1. Command request for an object
2. Command response of an object

.. _message-acknowledgement:

Message acknowledgement
^^^^^^^^^^^^^^^^^^^^^^^

Message acknowledgement is sent as an initial answer to all other
messages. This type of message should not be mixed up with alarm
acknowledgement, which has a different function. The purpose of
message acknowledgement is to detect communication disruptions,
function as an acknowledgment that the message has reached its
destination and to verify that the message was understood.

There are two types of message acknowledgement – **Message
acknowledgment** (MessageAck) which confirms that the message was understood and
**Message not acknowledged** (MessageNotAck) which indicates that the message
was not understood.

* If no message acknowledgement is received within a predefined time, then
  each communicating party should treat it as a communication disruption.
  (See :ref:`communication-disruption`)

* The default timeout value should be 30 seconds.

* If the version messages has not been exchanged according to communication
  establishment sequence
  (See :ref:`communication-establishment-between-sites-and-supervision-system`
  and :ref:`communication-establishment-between-sites`) then
  message acknowledgement (MessageAck/MessageNotAck) should not be sent as a
  response to any other messages other than the version message
  (See :ref:`rsmpsxl-version`). The lack of acknowledgement forces the other
  communicating party to treat it as communication disruption and disconnect
  and reconnect, ensuring that the connection restarts with communication
  establishment sequence.

The acknowledgement messages are interaction driven and are sent when
any other type message are received.

Message structure – Message acknowledgement
"""""""""""""""""""""""""""""""""""""""""""

An acknowledgement message has the structure according to the example
below.

.. code-block:: json
   :name: json-ack

   {
        "mType": "rSMsg",
        "type": "MessageAck",
        "oMId": "49c6c824-d593-4c16-b335-f04feda16986"
   }

JSon code 22: An acknowledgement message

Message structure – Message not acknowledged
""""""""""""""""""""""""""""""""""""""""""""

A "not acknowledgement" message has the structure according to the example
below.

.. code-block:: json
   :name: json-notack

   {
        "mType": "rSMsg",
        "type": "MessageNotAck",
        "oMId": "554dff0-9cc5-4232-97a9-018d5796e86a",
        "rea": "Unknown packet type: Watchdddog"
   }

JSon code 23: A not acknowledgement message

The following table is describing the variable content of the message:

.. figtable::
   :nofig:
   :label: table-messagenoteack-basic
   :caption: Message not ack
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.08\linewidth} p{0.10\linewidth} p{0.70\linewidth}

   ======== ============ ===============
   Element  Value        Description
   ======== ============ ===============
   rea      *(optional)* Error message where all relevant information about the nature of the error can be provided.
   ======== ============ ===============

..

Message exchange between site and supervision system/other equipment
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Supervision system sends initial message

.. image:: /img/msc/message_ack_system.png
   :align: center

1. A message is sent from supervision system or other equipment
2. The site responds with an message acknowledgement

Site sends initial message

.. image:: /img/msc/message_ack_site.png
   :align: center

1. A message is sent from the site
2. The supervision system or other equipment responds with an message acknowledgement

.. _rsmpsxl-version:

RSMP/SXL Version
^^^^^^^^^^^^^^^^

Version of RSMP and revision of SXL are always sent directly after
establishing communication. Both communicating systems send this as
their first message and waits for message response until any other
messages are sent. Information regarding all supported RSMP versions
should be included in the version message. The version message should
be implemented in such a way that is should be possible to add
additional tags/variables (e.g. date) without affecting existing
implementations.

If any discrepancies with the version numbers are detected between the
two communicating systems this should be set using a MessageNotAck.
The communication is terminated after that and an internal alarm is
activated in both communicating system. If both communicating systems
support several RSMP versions it is always the latest version that
should be used.

The principle of the message exchange is defined by the communication
establishment (See
:ref:`communication-establishment-between-sites-and-supervision-system`
and :ref:`communication-establishment-between-sites`).

Message structure
"""""""""""""""""

A version message has the structure according to the example below. In
the example below the system has support for RSMP version **3.1.1**,
**3.1.2** and SXL version **1.0.13** for site **O+14439=481WA001**.

.. code-block:: json
   :name: json-version

   {
        "mType": "rSMsg",
        "type": "Version",
        "mId": "6f968141-4de5-42ff-8032-45f8093762c5",
        "RSMP": [
            {
                "vers": "3.1.1"
            },{
                "vers": "3.1.2"
            }
        ],
        "siteId": [
            {
                "sId": "O+14439=481WA001"
            }
        ],
        "SXL": "1.0.13"
   }

JSon code 24: A RSMP / SXL message

The following table describes the variable content of the message which is
defined by the SXL.

The *SXL element* column describes the correlation between the JSon
elements and the titles in the signal exchange list (SXL).

.. figtable::
   :nofig:
   :label: table-version-basic-sxl
   :caption: Version information defined by SXL
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.08\linewidth} p{0.18\linewidth} p{0.65\linewidth}

   +-------------+--------------------+--------------------------------------------------------------------+
   | Element     | SXL element        | Description                                                        |
   +=============+====================+====================================================================+
   | sId         | SiteId             | Site identity. Used in order to refer to a “logical” identity of a |
   |             |                    | site.                                                              |
   |             |                    |                                                                    |
   |             |                    | At the STA, the following formats can be used:                     |
   |             |                    |                                                                    |
   |             |                    | - The site id from the STAs component id standard TDOK 2012:1171   |
   |             |                    |   e.g. ”40100”.                                                    |
   |             |                    | - It is also possible to use the full component id (TDOK 2012:1171)|
   |             |                    |   of the grouped object in the site in case the site id part of    |
   |             |                    |   the component id is insufficient in order to uniquely identify a |
   |             |                    |   site.                                                            |
   |             |                    |                                                                    |
   |             |                    | All the site ids that are used in the RSMP connection are sent     |
   |             |                    | in the message using an array (**siteId**)                         |
   +-------------+--------------------+--------------------------------------------------------------------+
   | SXL         | SXL revision       | Revision of SXL. E.g ”1.3”                                         |
   +-------------+--------------------+--------------------------------------------------------------------+

..

The following table describes additional variable content of the message.

.. figtable::
   :nofig:
   :label: table-version-basic
   :caption: Version information
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.80\linewidth}

   ========= ===============
   Element   Description
   ========= ===============
   vers      Version of RSMP. E.g. ”3.1.2”, ”3.1.3” or ”3.1.4”. All the supported RSMP versions are sent in the message using an array (**RSMP**).
   ========= ===============

..

.. _watchdog:

Watchdog
^^^^^^^^

The primary purpose of watchdog messages is to ensure that the
communication remains established and to detect any communication
disruptions between site and supervision system. For any subsystem
alarms are used instead.

The secondary purpose of watchdog messages is to provide a timestamp that can
be used for simple time synchronization.

* Time synchronization using the watchdog message should be configurable at the
  site (enabled/disabled)
* If time synchronization is enabled, the site should synchronize its clock
  using the timestamp from watchdog messages – at communication establishment and
  then at least once every 24 hours.
* The interval duration for sending watchdog messages should be
  configurable at both the site and the supervision system. The default
  setting should be (1) once a minute.

Watchdog messages are sent in both directions, both from the site and
from the supervision system. At initial communication establishment
(after version message) the watchdog message should be sent.

Message structure
"""""""""""""""""

A watchdog message has the structure according to the example below.

.. code-block:: json
   :name: json-watchdog

   {
        "mType": "rSMsg",
        "type": "Watchdog",
        "mId": "f48900bc-e6fb-431a-8ca4-05070016f64a",
        "wTs": "2015-06-08T12:01:39.654Z"
   }

JSon code 25: A watchdog message

The following table is describing the variable content of the message:

.. figtable::
   :nofig:
   :label: table-watchdog-basic
   :caption: Watchdog
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.15\linewidth} p{0.60\linewidth}

   ================== ============= ==========================================
   Element            Value         Description
   ================== ============= ==========================================
   wTs                *(timestamp)* Watchdog timestamp.
                                    The timestamp uses the W3C XML dateTime
                                    definition with a 3 decimal places. All
                                    timestamps are set at the local level
                                    (and not in the supervision system) when
                                    the event occurs (and not when the
                                    message is sent). All timestamps uses UTC.
   ================== ============= ==========================================

..

Message exchange between site and supervision system/other equipment
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Message acknowledgement (see section :ref:`message-acknowledgement`) is
implicit in the following figures.

Site sends watchdog message

.. image:: /img/msc/watchdog_site.png

1. Watchdog message is sent from site

Supervision system/other equipment sends watchdog message

.. image:: /img/msc/watchdog_system.png

1. Watchdog message is sent from supervision system/other equipment

