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

Parsing needs to be performed case sensitive.
All enum values (e.g. :ref:`alarm-status`) must use the exact casing stated
in this specification.

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

.. tabularcolumns:: |\Yl{0.15}|\Yl{0.30}|\Yl{0.55}|

.. table:: Variable content

   +---------+-------------------------+---------------------------------------+
   | Element | Value                   | Description                           |
   +=========+=========================+=======================================+
   | mType   | rSMsg                   | RSMP identifier                       |
   +---------+-------------------------+---------------------------------------+
   | type    | Alarm                   | Alarm message                         |
   |         +-------------------------+---------------------------------------+
   |         | AggregatedStatus        | Aggregated status message             |
   |         +-------------------------+---------------------------------------+
   |         | AggregatedStatusRequest | Aggregated status request message     |
   |         +-------------------------+---------------------------------------+
   |         | StatusRequest           | Status message. Request status        |
   |         +-------------------------+---------------------------------------+
   |         | StatusResponse          | Status message. Status response       |
   |         +-------------------------+---------------------------------------+
   |         | StatusSubscribe         | Status message. Start subscription    |
   |         +-------------------------+---------------------------------------+
   |         | StatusUpdate            | Status message. Update of status      |
   |         +-------------------------+---------------------------------------+
   |         | StatusUnsubscribe       | Status message. End subscription      |
   |         +-------------------------+---------------------------------------+
   |         | CommandRequest          | Command message. Request command      |
   |         +-------------------------+---------------------------------------+
   |         | CommandResponse         | Command message. Response of command  |
   |         +-------------------------+---------------------------------------+
   |         | MessageAck              | Message acknowledegment. Successful   |
   |         +-------------------------+---------------------------------------+
   |         | MessageNotAck           | Message acknowledegment. Unsuccessful |
   |         +-------------------------+---------------------------------------+
   |         | Version                 | RSMP / SXL version message            |
   |         +-------------------------+---------------------------------------+
   |         | Watchdog                | Watchdog message                      |
   +---------+-------------------------+---------------------------------------+
   | mId     | *(GUID)*                | Message identity                      |
   | *(or)*  |                         |                                       |
   | oMId    |                         |                                       |
   +---------+-------------------------+---------------------------------------+

.. note::
   * **mId** is generated as GUID (Globally unique identifier) in the equipment
     that sent the message
   * **mId** is used in all messages as a reference for the message ack
   * **oMId** is used in the message ack to refer to the message which is being acked
   * Only version 4 of Leach-Salz UUID is used for the GUID
   * Each message sent should have a new GUID, even if the message is resent or the
     content is the same

The following table describes the variable content in all message types
which is defined by the signal exchange list (SXL), except version
messages, message acknowledgement messages and watchdog messages.

.. tabularcolumns:: |\Yl{0.20}|\Yl{0.65}|

.. table:: Variable content

   ============ ================================================
   Element      Description
   ============ ================================================
   ntsOId       :term:`Component id` for the :term:`NTS object`
   xNId         :term:`External NTS id`
   cId          :term:`Component id`
   ============ ================================================

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

.. _structure-of-an-alarm-message:

Structure of an alarm message
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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


.. tabularcolumns:: |\Yl{0.20}|\Yl{0.65}|

.. table:: Alarm message

   ============ ==================================
   Element      Description
   ============ ==================================
   aCId         :term:`Alarm code id`
   xACId        :term:`External alarm code id`
   xNACId       :term:`External NTS alarm code id`
   ============ ==================================

The following table describes additional variable content of the message.

.. tabularcolumns:: |\Yl{0.15}|\Yl{0.20}|\Yl{0.25}|\Yl{0.40}|

.. table:: Alarm status change

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


.. _alarm-status:

Alarm status
~~~~~~~~~~~~

Alarm status are only used by alarm messages (not by alarm acknowledgement
or alarm suspend messages).

.. tabularcolumns:: |\Yl{0.15}|\Yl{0.25}|\Yl{0.60}|

.. table:: Alarm status

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
   | sS                | Suspended          | The alarm is suspended                                                             |
   |                   +--------------------+------------------------------------------------------------------------------------+
   |                   | notSuspended       | The alarm is not suspended                                                         |
   +-------------------+--------------------+------------------------------------------------------------------------------------+
   | aTs               | *(timestamp)*      | Timestamp for when the alarm changes status.                                       |
   |                   |                    | See the contents of aSp to determine which type of timestamp is used               |
   |                   |                    |                                                                                    |
   |                   |                    | | - aSp: Issue: When the alarm gets **active** or **inactive**                     |
   |                   |                    | | - aSp: Acknowledge: When the alarm gets **acknowledged** or **not acknowledged** |
   |                   |                    | | - aSp: Suspend: When the alarm gets **suspended** or **not suspended**           |
   |                   |                    |                                                                                    |
   |                   |                    | All timestamps are set at the local level (and not in the supervision system) when |
   |                   |                    | the alarm occurs (and not when the message is sent).                               |
   |                   |                    | See also the :ref:`data type<data_types>` section.                                 |
   +-------------------+--------------------+------------------------------------------------------------------------------------+

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

.. tabularcolumns:: |\Yl{0.20}|\Yl{0.65}|

.. table:: Alarm status details defined by SXL

   ============= ========================
   Element       Description
   ============= ========================
   cat           :ref:`alarm-category`
   pri           :ref:`alarm-priority`
   ============= ========================

.. _return-values:

Return values
~~~~~~~~~~~~~

Return values ("rvs") are used by alarm messages (but not by alarm
acknowledgment or alarm suspend messages) and is always sent but can
be empty (i.e. **[]**) if no return values are defined.

.. tabularcolumns:: |\Yl{0.15}|\Yl{0.10}|\Yl{0.60}|

.. table:: Alarm return values

   ======= ========== ===========
   Element Value      Description
   ======= ========== ===========
   rvs     *(array)*  Return values. Contains the element **n** and **v** in an array
   ======= ========== ===========

The following table describes the content for each return value which is
defined by the signal exchange list (SXL).

.. tabularcolumns:: |\Yl{0.20}|\Yl{0.65}|

.. table:: Return values

   =============  ========================
   Element        Description
   =============  ========================
   n              Name of the return value
   v              Value from equipment
   =============  ========================

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
(See :ref:`structure-of-an-alarm-message`) with the exception for alarm status
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

Aggregated status message are interaction driven and are sent if state,
functional position or functional status are changed at the site.

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

.. tabularcolumns:: |\Yl{0.10}|\Yl{0.15}|\Yl{0.75}|

.. table:: Aggregated status

   ======= ============= =====================================================================
   Element Value         Description
   ======= ============= =====================================================================
   aSTS    *(timestamp)* Timestamp for the aggregated status.
                         All timestamps are set at the site (and not in the supervision
                         system) when the event occurs (and not when the message is sent).
                         See also the :ref:`data type<data_types>` section.
   ======= ============= =====================================================================

The following table describes the variable content defined by the signal
exchange list (SXL).

.. tabularcolumns:: |\Yl{0.20}|\Yl{0.65}|

.. table:: Aggregated status SXL content

   ======= ==============================================
   Element Description
   ======= ==============================================
   fP      :term:`Functional position`
   fS      :term:`Functional state`
   se      Array of eight booleans. See :ref:`state-bits`
   ======= ==============================================

``fP`` and ``fS`` is set to ``null`` or empty string if no value is defined
in the SXL.

.. _state-bits:

State bits
~~~~~~~~~~

* **State bits** ``se`` is an array of eight booleans. The boolean elements defines
  the status of the site to :term:`NTS`.

* It is technically valid in RSMP to set the boolean elements to a nonsensical
  values, e.g. all boolean elements to ``false``, but it is not defined how to
  interpret it at the receiving end

A definition of each boolean element (1-8) is presented in the figure below.
The signal exchange list (SXL) may define a more detailed definition.

.. image:: /img/msc/agg_state_array.png
   :align: center

* Bit 3 is true if there are any active alarms with priority 1
* Bit 4 is true if there are any active alarms with priority 2
* Bit 5 is true if there are any active alarms with priority 3

Please see section :ref:`alarm-priority`.

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

**Functional state, functional position or state booleans changes at the
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

The status message is a type of message that is sent to the supervision
system or other equipment with the value of one or more requested
statuses, for the referenced object.

The status message can both be interaction driven or event driver and
can be sent during the following prerequisites:

- When status is requested from the supervision system or other equipment.
- According to subscription – either by using a fixed time interval or
  when the status changes.

Message structure
"""""""""""""""""

Structure of a status request
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

The status code id (``sCI``) and name (``n``) are placed in an array
(``sS``) in order to enable support for requesting multiple status at
once.

The following table is describing the variable content of the message.

.. _table-statusrequest:

.. tabularcolumns:: |\Yl{0.15}|\Yl{0.20}|\Yl{0.20}|\Yl{0.45}|

.. table:: Status request

   ============ ===============================
   Element      Description
   ============ ===============================
   sCI          :term:`Status code id`
   n            Name of the return value
   ============ ===============================


Structure for status response message
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A status response message has the structure according to the example below.

The status code id (``sCI``) and name (``n``) are placed in an array
(``sS``) in order to enable support for responding to multiple statuses at once.
The following table is describing the variable content of the message.

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

.. tabularcolumns:: |\Yl{0.15}|\Yl{0.15}|\Yl{0.70}|

.. table:: Status response

   ======= ============= ==============
   Element Value         Description
   ======= ============= ==============
   sTs     *(timestamp)* Timestamp
   ======= ============= ==============

All timestamps are set at the site (and not in the supervision system) when
the status is fetched (and not when the message is sent).
See also the :ref:`data type<data_types>` section.

Return values (returnvalue)
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Return values ("sS") are always sent but can be empty if no return values exists.

.. tabularcolumns:: |\Yl{0.15}|\Yl{0.10}|\Yl{0.75}|

.. table:: Return values (returnvalue)

   ========== ========== ===================
   Element    Value      Description
   ========== ========== ===================
   sS         *(array)*  Return values. Contains the elements "sCI", "s", "n" and "q" in an array.
   ========== ========== ===================

.. _table-statusresponse-returnvalues:

.. tabularcolumns:: |\Yl{0.20}|\Yl{0.65}|

.. table:: Return values

   =============   =================================
   Element         Description
   =============   =================================
   sCI             :term:`Status code id`
   n               Name of the return value
   s               Value from equipment
   =============   =================================


The following table describes additional variable content of the message.

.. tabularcolumns:: |\Yl{0.15}|\Yl{0.15}|\Yl{0.65}|

.. table:: Return value quality

   +-----------------+--------------------+-----------------------------------------------+
   | Element         | Value              | Description                                   |
   +=================+====================+===============================================+
   | q               | recent             | The value is up to date                       |
   |                 +--------------------+-----------------------------------------------+
   |                 | old                | The value is not up to date.                  |
   |                 |                    | Used when sending buffered values             |
   |                 +--------------------+-----------------------------------------------+
   |                 | undefined          | The component does not exist                  |
   |                 +--------------------+-----------------------------------------------+
   |                 | unknown            | The value is unknown                          |
   +-----------------+--------------------+-----------------------------------------------+

If the component does not exist or the value ``s`` is unknown then:

* Subscription will not be performed
* ``q`` is set according to the table above
* ``s`` must be set to ``null``


Structure for a status subscription request message
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

.. tabularcolumns:: |\Yl{0.15}|\Yl{0.10}|\Yl{0.75}|

.. table:: Status Request

   ======== ========== =============
   Element  Value      Description
   ======== ========== =============
   uRt      *(string)* updateRate
   sOc      boolean    sendOnChange
   ======== ========== =============

The **updateRate** ``uRt`` and **sendOnChange** ``sOc`` determines when a
status update should be sent.

The following applies:

* **updateRate** defines a specific interval when to send updates.
  Defined in seconds with decimals, e.g. "2.5" for 2.5 seconds.
  Dot (.) is used as a decimal point.

* If **updateRate** is set to "0" it means that no update is sent using an
  interval.

* **sendOnChange** defines if an status update should be sent as soon as the
  value changes.

* It is possible to combine **updateRate** and **sendOnChange** to send an
  update when the value changes and at the same time using a specific
  interval.

* If **updateRate** and **sendOnChange=true** are combined, the updateRate
  timer is reset when the value changes.
  For example, if updateRate is set to 5 seconds but the value changes after
  2 seconds (triggering sendOnChange) the updateRate timer starts over and
  waits another 5 seconds to trigger.

* It is not valid to set **updateRate=0** and **sendOnChange=false** since
  it means that no subscription updates will be sent.

* It is allowed to change **updateRate** and **sendOnChange** by sending a
  new StatusSubscribe during an active subscription.


Structure for a status update message
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The status update message is an answer to a request for status subscription.
It has the structure according to the example below.

The following applies:

* A StatusUpdate is always sent immediately after subscription request,
  unless the subscription is already active. The reason for sending the
  response immediately is because subscriptions usually are established
  shortly after RSMP connection establishment and the supervision system
  needs to update with the current statuses.

* If an subscription is already active then the site must not establish
  a new subscription but use the existing one. It's allowed to change
  **updateRate** and **sendOnChange**.

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


Structure for a status unsubscription message
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A message with the request of unsubscription to a status has the structure
according to the example below. The request unsubscribes on one or several
statuses. No particular answer is sent for this request, other than the
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

1. Status request
2. Status response

Message exchange between site and supervision system/other equipment - subscription
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Message acknowledgement (see section :ref:`message-acknowledgement`) is
implicit in the following figure.

.. image:: /img/msc/status_update.png
   :align: center

Example of message exchange with subscription, status updates and unsubscription.

Command messages
^^^^^^^^^^^^^^^^

Command messages are used to give order using one or more commands, for the
referenced object.
The site responds with a command acknowledgement.

All arguments needs to included in a command, otherwise it results a serious
error resulting in MessageNotAck. See section about :ref:`incomplete-commands`.

Command messages are interaction driven and are sent when command are
requested on any given object by the supervision system or other equipment

Message structure
"""""""""""""""""

Structure of a command request
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

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

The command code (``cCI``) and name (``n``) are placed in an array
(``arg``) in order to enable support for requesting multiple commands at
once.

The following table is describing the variable content of the message:

Values to send with the command (arguments)

.. tabularcolumns:: |\Yl{0.15}|\Yl{0.10}|\Yl{0.60}|

.. table:: Command argument

   ============ ============ =============
   Element      Value        Description
   ============ ============ =============
   arg          *(array)*    Argument. Contains the element **cCI**, **n**, **cO**, **v** in an array
   ============ ============ =============

The following table describes the variable content of the message which is
defined by the SXL.

.. tabularcolumns:: |\Yl{0.25}|\Yl{0.65}|

.. table:: Command arguments defined by SXL

   =============  ========================================================
   Element        Description
   =============  ========================================================
   cCI            :term:`Command code id`
   n              Name of the argument
   cO             Command. Optionally used for RPC (Remote Procedure Call)
   v              Value
   =============  ========================================================

Structure of a command response message
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A command response message has the structure according to the example
below. A command response message informs about the updated value of the
requested object.

The command code (``cCI``) and name (``n``) are placed in an array
(``rvs``) in order to enable support for responding to multiple commands at
once.

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

.. tabularcolumns:: |\Yl{0.10}|\Yl{0.15}|\Yl{0.75}|

.. table:: Command response

   ======= ============= =====================================================================
   Element Value         Description
   ======= ============= =====================================================================
   cTS     *(timestamp)* Timestamp for the command reponse.
                         All timestamps are set at the site (and not in the supervision
                         system) when the event occurs (and not when the message is sent).
                         See also the :ref:`data type<data_types>` section.
   ======= ============= =====================================================================

Return values (returnvalue)
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Return values (**rvs**) is always sent but can
be empty if not return values are defined.

.. tabularcolumns:: |\Yl{0.15}|\Yl{0.10}|\Yl{0.70}|

.. table:: Command return values

   ========= ========= =============
   Element   Value     Description
   ========= ========= =============
   rvs       *(array)* Return values. Contains the elements **cCI**, **v**, **n** and **q** in an array.
   ========= ========= =============

The following table describes the variable content defined by the signal
exchange list (SXL).

.. tabularcolumns:: |\Yl{0.20}|\Yl{0.65}|

.. table:: Return values

   =============  ===============================================
   Element        Description
   =============  ===============================================
   cCI            :term:`Command code id`
   n              Name of the return value
   v              Value from equipment
   =============  ===============================================

The following table describes additional variable content of the message.

.. tabularcolumns:: |\Yl{0.15}|\Yl{0.15}|\Yl{0.60}|

.. table:: Command return value

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

Message exchange between site and supervision system/other equipment
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Message acknowledgement (see section :ref:`message-acknowledgement`) is
implicit in the following figure.

.. image:: /img/msc/command_request_response.png
   :align: center

1. Command request
2. Command response

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

.. tabularcolumns:: |\Yl{0.15}|\Yl{0.15}|\Yl{0.70}|

.. table:: Message not ack

   ======== ============ ===============
   Element  Value        Description
   ======== ============ ===============
   rea      *(optional)* Error message where all relevant information about the nature of the error can be provided.
   ======== ============ ===============

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

RSMP/SXL Version is the initial message when establishing communication.

It contains:

* Site Id
* SXL revision
* All supported RSMP versions

The Site Id and SXL revision must match between the communicating parties.

If there is a mismatch or if there are no RSMP version that both
communicating parties support, see :ref:`communication-rejection`.

The version message should be implemented in such a way that it should be
possible to add additional tags/variables (e.g. date) without affecting
existing implementations.

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

The *Site config* columns describes the correlation between the JSon
elements and the titles in the site configuration.

.. tabularcolumns:: |\Yl{0.15}|\Yl{0.20}|\Yl{0.20}|\Yl{0.45}|

.. table:: Version information defined by site configuration

   ======= ==================== ================== ===========================
   Element Site config (Excel)  Site config (YAML) Description
   ======= ==================== ================== ===========================
   sId     SiteId                                  :term:`Site id`
   SXL     SXL revision         version            Revision of SXL. E.g ”1.3”
   ======= ==================== ================== ===========================

It is possible to use more than one site id in a single RSMP connection.
Therefore the site ids that are used in the RSMP connection are sent
in the message using an array with ``sId``.

The following table describes additional variable content of the message.

.. tabularcolumns:: |\Yl{0.15}|\Yl{0.85}|

.. table:: Version information

   ========= ===============
   Element   Description
   ========= ===============
   vers      Version of RSMP. E.g. ”3.1.2”, ”3.1.3” or ”3.1.4”. All the supported RSMP versions are sent in the message using an array (**RSMP**).
   ========= ===============

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

.. tabularcolumns:: |\Yl{0.15}|\Yl{0.15}|\Yl{0.70}|

.. table:: Watchdog

   ======= ============= =====================================================================
   Element Value         Description
   ======= ============= =====================================================================
   wTs     *(timestamp)* Timestamp for the watchdog.
                         See also the :ref:`data type<data_types>` section.
   ======= ============= =====================================================================

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

.. |br| replace:: |br_html| |br_latex|

.. |br_html| raw:: html

   <br>

.. |br_latex| raw:: latex

   \newline

