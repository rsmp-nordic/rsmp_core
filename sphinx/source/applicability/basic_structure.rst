.. _basic-structure:

Basic structure
---------------

Unicode (ISO 10646) and UTF-8 are used for all messages. All messages
are based on the structure presented below. In the following example the
message type is an alarm message.

.. code-block:: xml
   :name: xml-basic

   <?xml version="1.0" encoding="UTF-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4 RoadSideMessage_1_0_1_4.xsd">
       <message xsi:type="Alarm">
           <messageId>{E68A0010-C336-41ac-BD58-5C80A72C7092}</messageId>
           <ntsObjectId>F+40100=416CG100</ntsObjectId>
           <externalNtsId>23055</externalNtsId>
           <componentId>AB+84001=860VA001</componentId>
       </message>
   </roadSideMessage>

The following table is describing the variable content of the message:

.. figtable::
   :nofig:
   :label: table-variable-content
   :caption: Variable content
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.15\linewidth} p{0.10\linewidth} p{0.60\linewidth}

   ========================== ================== =====================================================================================================================================================================================================================
   Element                    Value              Description
   ========================== ================== =====================================================================================================================================================================================================================
   messageId                  *(GUID)*           Message identity. Generated as a GUID (Globally unique identifier) in the equipment that sent the message. Only version 4 of Leach-Salz UUID is used.
   ntsObjectId *(optional)*   *(Defined in SXL)* Component-id for the NTS object which the message is referring to.
   externalNtsId *(optional)* *(Defined in SXL)* Identity for the NTS objects in communication between NTS and other systems. The format is 5 integers (Mentioned in SL31 Object-Identity). Defined in cooperation with representatives from NTS. Unique for the site.
   componentId                *(Defined in SXL)* Component id for the object which the message is referring to
   ========================== ================== =====================================================================================================================================================================================================================

..

.. _alarm-messages:

Alarm messages
^^^^^^^^^^^^^^

An alarm message is sent to the supervision system when:

- An alarm becomes active / inactive
- An alarm is acknowledged
- An alarm is being suspended / un-suspended

An acknowledgment of an alarm does not cause a single alarm event to
be acknowledged but all alarm events for the specific object with the
associated alarm code id. This approach simplifies both in
implementation but also in handling - if many alarms occur on the same
equipment with short time intervals.

A suspend of an alarm causes all alarms from the specific object with
the associated alarm code id to be suspended.

Alarm messages are event driven and sent to the supervision system
when the alarm occurs. Acknowledgement of alarms and alarm suspend
messages are interaction driven.

Message structure
"""""""""""""""""

.. _structure-for-an-alarm-message:

Structure for an alarm message

An alarm message has the same structure when it’s sent regardless
whether or not it is a new alarm, being acknowledged or being
suspended, with the exception of “alarmSpecialisation”.

The following table describes the differences:

.. figtable::
   :nofig:
   :label: table-alarm-specialisation
   :caption: alarm-specialisation
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.45\linewidth} p{0.45\linewidth}

   ================================================ =====================================================
   Element and value                                Meaning
   ================================================ =====================================================
   <alarmSpecialisation xsi:type=”**Issue**”>       An alarm becomes active/in-active
   <alarmSpecialisation xsi:type=”**Acknowledge**”> An alarm is acknowledged
   <alarmSpecialisation xsi:type=”**Suspend**”>     Suspension of an alarm is being activated/deactivated
   ================================================ =====================================================

..

An alarm message has the structure according to the example below. In the 
following example the message contains an alarm for a lamp error at the
site "AB+84001=860VA001".

.. code-block:: xml
   :name: xml-alarm-issue

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4 RoadSideMessage_1_0_1_4.xsd">
   <message xsi:type="Alarm">
   <messageId>{E68A0010-C336-41ac-BD58-5C80A72C7092}</messageId>
   <ntsObjectId>F+40100=416CG100</ntsObjectId>
   <externalNtsId>23055</externalNtsId>
   <componentId>AB+84001=860VA001</componentId>
   <alarmCodeId>A001</alarmCodeId>
   <externalAlarmCodeId>Lampfel på lykta 1 (röd)</externalAlarmCodeId>
   <externalNtsAlarmCodeId>3143</externalNtsAlarmCodeId>
   <alarmSpecialisation xsi:type="Issue">
      <acknowledgeState>notAcknowledged</acknowledgeState>
      <alarmState>active</alarmState>
      <suspendState>notSuspended</suspendState>
      <timestamp>2009-10-01T11:59:31.571Z</timestamp>
      <category>T</category>
      <priority>2</priority>
      <returnvalues>
         <returnvalue>
             <name>signalgrupp</name>
             <value>1</value>
         </returnvalue>
         <returnvalue>
            <name>färg</name>
            <value>röd</value>
         </returnvalue>
      </returnvalues>
   </alarmSpecialisation>
   </message>
   </roadSideMessage>

The following table is describing the variable content of the message:

Basic (xsi:type = Alarm)

.. figtable::
   :nofig:
   :label: table-alarm-basic
   :caption: alarm-basic
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.25\linewidth} p{0.20\linewidth} p{0.45\linewidth}

   =================================== ========================= =============================================================================================================================================================================
   Element                             Value                     Description
   =================================== ========================= =============================================================================================================================================================================
   alarmCodeId                         *(Defined in SXL)*        Alarm code id. Determined in the signal exchange list (SXL). The examples in this document are defined according to the following format: Ayyy, where yyy is a unique number.
   externalAlarmCodeId *(optional)*    *(Manufacturer specific)* Manufacturer specific alarm code and alarm description Manufacturer, model, alarm code och additional alarm description.
   externalNtsAlarmCodeId *(optional)* *(Defined in SXL)*        Alarm code in order to identify alarm type during communication with NTS and other system. *(See SL31 Alarm-Code)*
   =================================== ========================= =============================================================================================================================================================================

..

Alarm status

.. figtable::
   :nofig:
   :label: table-alarm-status
   :caption: alarm-status
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.15\linewidth} p{0.15\linewidth} p{0.60\linewidth}

   +-------------------+--------------------+------------------------------------------------------------------------------------+
   | Element           | Value              | Description                                                                        |
   +===================+====================+====================================================================================+
   | acknowledegeState | acknowledged       | The alarm is acknowledged                                                          |
   |                   +--------------------+------------------------------------------------------------------------------------+
   |                   | notAcknowledged    | The alarm is not acknowledged                                                      |
   +-------------------+--------------------+------------------------------------------------------------------------------------+
   | alarmState        | inactive           | The alarm is inactive                                                              |
   |                   +--------------------+------------------------------------------------------------------------------------+
   |                   | active             | The alarm is active                                                                |
   +-------------------+--------------------+------------------------------------------------------------------------------------+
   | suspendState      | suspended          | The alarm is suspended                                                             |
   |                   +--------------------+------------------------------------------------------------------------------------+
   |                   | notSuspended       | The alarm is not suspended                                                         |
   +-------------------+--------------------+------------------------------------------------------------------------------------+
   | timestamp         | *(timestamp)*      | Timestamp for when the alarm either occurs, gets acknowledged or gets suspended.   |
   |                   |                    | See the contents of **alarmSpecialisation** to determine which type timetamp is    |
   |                   |                    | used. The timestamp uses the W3C XML **dateTime** definition with 3 decimal places |
   |                   |                    | All timestamps are set at the local level (and not in the supervision system) when |
   |                   |                    | the alarm occurs (and not when the message is sent). All timestamps uses UTC.      |
   +-------------------+--------------------+------------------------------------------------------------------------------------+
   | category          | T *or* D           | A character, either ”T” or ”D”.                                                    |
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
   |                   |                    | | - High level of CO2 in traffic room                                              |
   |                   |                    | | - Etc.                                                                           |
   |                   |                    |                                                                                    |
   |                   |                    | **Technical alarm:**                                                               |
   |                   |                    | Technical alarms are alarms that do not directly affect the traffic. One example   |
   |                   |                    | of a technical alarm is when an impulse fan stops working.                         |
   +-------------------+--------------------+------------------------------------------------------------------------------------+
   | description       | *(Defined in SXL)* | Description of the alarm. Only defined in SXL and is never actually sent.          |
   | *(only in SXL,    |                    | (The format of the description is free of choice but has the following             |
   | never actually    |                    | requirements:                                                                      |
   | sent)*            |                    | - The text is unique for the object type                                           |
   |                   |                    | - The text is defined in cooperation with the Purchaser before use)                |
   +-------------------+--------------------+------------------------------------------------------------------------------------+
   | priority          | [0-9]              | The priority of the message. The following values are defined:                     |
   |                   |                    |                                                                                    |
   |                   |                    | 1. Alarm that requires immediate action.                                           |
   |                   |                    | 2. Alarm that does not require immediate action, but action is planned during      |
   |                   |                    |    the next work shift.                                                            |
   |                   |                    | 3. Alarm that will be corrected during the next planned maintenance shift.         |
   +-------------------+--------------------+------------------------------------------------------------------------------------+

..

Return values

.. figtable::
   :nofig:
   :label: table-alarm-return-values
   :caption: alarm-return-values
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.20\linewidth} p{0.10\linewidth} p{0.60\linewidth}

   +-----------------+--------------------+-----------------------------------------------+
   | Element         | Value              | Description                                   |
   +=================+====================+===============================================+
   | name            | *(Defined in SXL)* | Unique reference of the value                 |
   +-----------------+--------------------+-----------------------------------------------+
   | type            | *(Defined in SXL)* | The data type of the value.                   |
   | *(Only in SXL,  |                    | Defined in the SXL but is not actually sent   |
   | not actually    |                    |                                               |
   | sent)*          |                    | | General definition:                         |
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
   | unit            | *(Defined in SXL)* | The unit of the value. Defined in SXL but     |
   | *(Only is SXL,  |                    | are not actually sent                         |
   | not actually    |                    |                                               |
   | sent)*          |                    |                                               |
   +-----------------+--------------------+-----------------------------------------------+
   | value           | *(Defined in SXL)* | Value                                         |
   +-----------------+--------------------+-----------------------------------------------+

..

Structure for alarm acknowledgement message

An alarm acknowledgement message has the structure according to the example
below.

.. code-block:: xml
   :name: xml-alarm-ack

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4 RoadSideMessage_1_0_1_4.xsd">
   <message xsi:type="Alarm">
   <messageId>{E68A0010-C336-41ac-BD58-5C80A72C7092}</messageId>
   <ntsObjectId>F+40100=416CG100</ntsObjectId>
   <externalNtsId>23055</externalNtsId>
   <componentId>AB+84001=860VA001</componentId>
   <alarmCodeId>A001</alarmCodeId>
   <externalAlarmCodeId>Larmfel på lykta 1 (röd)</externalAlarmCodeId>
   <externalNtsAlarmCodeId>3143</externalNtsAlarmCodeId>
   <alarmSpecialisation xsi:type="Acknowledge" />
   </message>
   </roadSideMessage>

The following table is describing the variable content of the message:

Basic (xsi:type = Alarm)

.. figtable::
   :nofig:
   :label: table-alarm-ack-basic-values
   :caption: alarm-ack-basic-values
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.25\linewidth} p{0.20\linewidth} p{0.45\linewidth}

   +------------------------+--------------------+--------------------------------------------------------------------+
   | Element                | Value              | Description                                                        |
   +========================+====================+====================================================================+
   | alarmCodeId            | *(Defined in SXL)* | Alarm code id. Determined in the signal exchange list (SXL).       |
   |                        |                    | The examples in this document are defined according to the         |
   |                        |                    | following format: Ayyy, where yyy is a unique number.              |
   +------------------------+--------------------+--------------------------------------------------------------------+
   | externalAlarmCodeId    | *(Manufacturer     | Manufacturer specific alarm code and alarm description.            |
   | *(optional)*           | specific)*         | Manufacturer, model, alarm code och additional alarm description   |
   +------------------------+--------------------+--------------------------------------------------------------------+
   | externalNtsAlarmCodeId | *(Defined in SXL)* | Alarm code in order to identify alarm type during communication    |
   | *(optional)*           |                    | with NTS and other systems. *(See SL31 Alarm-Code)*                |
   +------------------------+--------------------+--------------------------------------------------------------------+

..

Alarm acknowledgement (xsi:type = Acknowledge)

(no content)

Structure for alarm suspend message

An alarm suspend message has the structure according to the example
below.

.. code-block:: xml
   :name: xml-alarm-suspend

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4 RoadSideMessage_1_0_1_4.xsd">
   <message xsi:type="Alarm">
   <messageId>{E68A0010-C336-41ac-BD58-5C80A72C7092}</messageId>
   <ntsObjectId>F+40100=416CG100</ntsObjectId>
   <externalNtsId>23055</externalNtsId>
   <componentId>AB+84001=860VA001</componentId>
   <alarmCodeId>A001</alarmCodeId>
   <externalAlarmCodeId>Larmfel på lykta 1 (röd)</externalAlarmCodeId>
   <externalNtsAlarmCodeId>3143</externalNtsAlarmCodeId>
   <alarmSpecialisation xsi:type="Suspend">
   <suspendAction>suspend</suspendAction>
   </alarmSpecialisation>
   </message>
   </roadSideMessage>

The following table is describing the variable content of the message:

Basic (xsi:type = Alarm)

.. figtable::
   :nofig:
   :label: table-alarm-block-basic
   :caption: alarm-block-basic
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.25\linewidth} p{0.20\linewidth} p{0.45\linewidth}

   +------------------------+--------------------+--------------------------------------------------------------------+
   | Element                | Value              | Description                                                        |
   +========================+====================+====================================================================+
   | alarmCodeId            | *(Defined in SXL)* | Alarm code id. Determined in the signal exchange list (SXL).       |
   |                        |                    | The examples in this document are defined according to the         |
   |                        |                    | following format: Ayyy, where yyy is a unique number.              |
   +------------------------+--------------------+--------------------------------------------------------------------+
   | externalAlarmCodeId    | *(Manufacturer     | Manufacturer specific alarm code and alarm description.            |
   | *(optional)*           | specific)*         | Manufacturer, model, alarm code och additional alarm description   |
   +------------------------+--------------------+--------------------------------------------------------------------+
   | externalNtsAlarmCodeId | *(Defined in SXL)* | Alarm code in order to identify alarm type during communication    |
   | *(optional)*           |                    | with NTS and other system. *(See SL31 Alarm-Code)*                 |
   +------------------------+--------------------+--------------------------------------------------------------------+

..

Alarm suspend (xsi:type = Suspend)

.. figtable::
   :nofig:
   :label: table-alarm-suspend
   :caption: alarm-suspend
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.20\linewidth} p{0.10\linewidth} p{0.40\linewidth}

   +------------------------+------------------+----------------------------------------------------------------------+
   | Element                | Value            | Description                                                          |
   +========================+==================+======================================================================+
   | suspendAction          | suspend          | Activate suspend of an alarm                                         |
   |                        +------------------+----------------------------------------------------------------------+
   |                        | resume           | Deactivate a suspend of an alarm                                     |
   +------------------------+------------------+----------------------------------------------------------------------+

..

Message exchange between site and supervision system
""""""""""""""""""""""""""""""""""""""""""""""""""""

Message acknowledgement (see section :ref:`message-acknowledgement`) is
implicit in the following figures.

**An alarm is active/inactive**

.. image:: /img/msc/alarm_active_inactive.png
   :align: center

1. An alarm message is sent to supervision system with the status of the alarm (the alarm is active/inactive)

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
status of the site.

Aggregated status message are interaction driven and are sent if state
bits, functional position or functional status are changed at the site.

Message structure
"""""""""""""""""

An aggregated status message has the structure according to the example
below.

.. code-block:: xml
   :name: xml-agg-status

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4 RoadSideMessage_1_0_1_4.xsd">
   <message xsi:type="AggregatedStatus">
   <messageId>{E68A0010-C336-41ac-BD58-5C80A72C7092}</messageId>
   <ntsObjectId>F+40100=416CG100</ntsObjectId>
   <externalNtsId>23055</externalNtsId>
   <componentId>F+40100=416CG100</componentId>
   <aggstatusTimeStamp>2009-10-02T14:34:34.345Z</aggstatusTimeStamp>
   <aggregatedStatusSpecialisation>
      <functionalPosition>Trafikstyrning</functionalPosition>
      <functionalState>Automatiskt nedsatt hastighet</functionalState>
      <state>
         <name>1</name>
         <state>false</state>
      </state>
      <state>
         <name>2</name>
         <state>true</state>
      </state>
      <state>
         <name>3</name>
         <state>true</state>
      </state>
      <state>
         <name>4</name>
         <state>false</state>
      </state>
      <state>
         <name>5</name>
         <state>false</state>
      </state>
      <state>
         <name>6</name>
         <state>false</state>
      </state>
      <state>
         <name>7</name>
         <state>false</state>
      </state>
      <state>
         <name>8</name>
         <state>false</state>
      </state>
   </aggregatedStatusSpecialisation>
   </message>
   </roadSideMessage>

The following tables are describing the variable content of the message:

Basic (aggregatedStatus)

.. figtable::
   :nofig:
   :label: table-agg-basic
   :caption: Basic (aggregatedStatus)
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.20\linewidth} p{0.15\linewidth} p{0.50\linewidth}

   ================== ============= ==========================================
   Element            Value         Description
   ================== ============= ==========================================
   aggstatusTimeStamp *(timestamp)* The timestamp uses the W3C XML dateTime
                                    definition with a 3 decimal places. All
                                    timestamps are set at the local level
                                    (and not in the supervision system) when
                                    the event occurs (and not when the
                                    message is sent). All timestamps uses UTC.
   ================== ============= ==========================================

..

Aggregated status (aggregatedStatusSpecialisation)

.. figtable::
   :nofig:
   :label: table-agg-specialisation
   :caption: Aggregated status (aggregatedStatusSpecialisation)
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.20\linewidth} p{0.20\linewidth} p{0.30\linewidth}

   +--------------------+--------------------+-------------------------+
   | Element            | Value              | Description             |
   +====================+====================+=========================+
   | functionalPosition | *(Defined in SXL)* | Functional position     |
   +--------------------+--------------------+-------------------------+
   | functionalState    | *(Defined in SXL)* | Functional state        |
   | *(optional)*       |                    |                         |
   +--------------------+--------------------+-------------------------+
   | state              | *(see below)*      | Status bits (see below) |
   +--------------------+--------------------+-------------------------+

..


Status bits (state)

The status bits are a set of 8 bits that describes the state of the site
for NTS. Every bit can either be true or false

.. figtable::
   :nofig:
   :label: table-agg-status
   :caption: Aggregated status
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.15\linewidth} p{0.40\linewidth}

   +--------------------+--------------------+---------------------------+
   | Element            | Value              | Description               |
   +====================+====================+===========================+
   | state              | true               | State bit                 |
   |                    +--------------------+                           |
   |                    | false              |                           |
   +--------------------+--------------------+---------------------------+
   | name               | [1-8]              | Bit nr                    |
   |                    |                    | (integer between 1 and 8) |
   +--------------------+--------------------+---------------------------+

..

The principle of aggregating of statuses for each bit is defined by the
associated comments in the signal exchange list (SXL). A generic
description of each bit is presented in the figure below

.. image:: /img/msc/agg_status_bits.png
   :align: center

Message exchange between site and supervision system
""""""""""""""""""""""""""""""""""""""""""""""""""""

Message acknowledgement (see section :ref:`message-acknowledgement`) is
implicit in the following figure.

.. image:: /img/msc/aggregated_status.png
   :align: center

**(Functional state, functional position or status bits changes at the
site)**

1. An aggregated status message is sent to the supervision system.

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
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A status request message has the structure according to the example
below. If the object is not known, then the site must not disconnect
but instead answer with this type of message where "ageState" contains
"undefined".

.. code-block:: xml
   :name: xml-status-req

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4 RoadSideMessage_1_0_1_4.xsd">
   <message xsi:type="StatusRequest">
   <messageId>{E68A0010-C336-41ac-BD58-5C80A72C7092}</messageId>
   <ntsObjectId>F+40100=416CG100</ntsObjectId>
   <externalNtsId>23055</externalNtsId>
   <componentId>AB+84001=860VA001</componentId>
   <statuses>
      <status>
         <statusCodeId>S003</statusCodeId>
         <name>speed</name>
      </status>
      <status>
         <statusCodeId>S003</statusCodeId>
         <name>occupancy</name>
      </status>
   </statuses>
   </message>
   </roadSideMessage>

The following tables are describing the variable content of the message:

Basic (xsi:type = StatusRequest)

.. figtable::
   :nofig:
   :label: table-statusrequest
   :caption: Basic (xsi:type = StatusRequest)
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.15\linewidth} p{0.20\linewidth} p{0.50\linewidth}

   +--------------+--------------------+----------------------------------------------------------------------+
   | Element      | Value              | Description                                                          |
   +==============+====================+======================================================================+
   | statusCodeId | *(Defined in SXL)* | Status code id. Determined by the signal exchange list (SXL).        |
   |              |                    | The examples in this document are defined according to the following |
   |              |                    | format: syyy, where yyy is a unique number.                          |
   +--------------+--------------------+----------------------------------------------------------------------+
   | name         | *(Defined in SXL)* | Unique reference                                                     |
   +--------------+--------------------+----------------------------------------------------------------------+

..

Structure for a message with status of one or several objects
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A message with status of one or several objects has the structure
according to the example below.

.. code-block:: xml
   :name: xml-status-response

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4 RoadSideMessage_1_0_1_4.xsd">
       <message xsi:type="StatusResponse">
           <messageId>{E68A0010-C336-41ac-BD58-5C80A72C7092}</messageId>
           <ntsObjectId>F+40100=416CG100</ntsObjectId>
           <externalNtsId>23055</externalNtsId>
           <componentId>AB+84001=860VA001</componentId>
           <statusTimeStamp>2009-10-02T14:34:34.345Z</statusTimeStamp>
           <returnvalues>
               <returnvalue>
                   <statusCodeId>S003</statusCodeId>
                   <name>speed</name>
                   <status>70</status>
                   <ageState>recent</ageState>
               </returnvalue>
               <returnvalue>
                   <statusCodeId>S003</statusCodeId>
                   <name>occupancy</name>
                   <status>14</status>
                   <ageState>recent</ageState>
               </returnvalue>
           </returnvalues>
       </message>
   </roadSideMessage>

The following table is describing the variable content of the message:

Basic (xsi:type = StatusResponse)

.. figtable::
   :nofig:
   :label: table-statusresponse
   :caption: Basic (xsi:type = StatusResponse)
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.20\linewidth} p{0.20\linewidth} p{0.45\linewidth}

   +-----------------+--------------------+--------------------------------------------+
   | Element         | Value              | Description                                |
   +=================+====================+============================================+
   | statusTimeStamp | *(timestamp)*      | The timestamp uses the W3C XML dateTime    |
   |                 |                    | definition with a 3 decimal places. All    |
   |                 |                    | timestamps are set at the local level (and |
   |                 |                    | not in the supervision system) when the    |
   |                 |                    | alarm occurs (and not when the message     |
   |                 |                    | message is sent). All timestamps uses UTC. |
   +-----------------+--------------------+--------------------------------------------+
   | description     | *(Defined in SXL)* | Description for the status request.        |
   | *(Only in SXL,  |                    | Defined in the SXL but is not actually     |
   | not actually    |                    | sent.                                      |
   | sent)*          |                    |                                            |
   +-----------------+--------------------+--------------------------------------------+

..

Return values (returnvalue)
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. figtable::
   :nofig:
   :label: table-statusresponse-returnvalues
   :caption: Return values (returnvalue)
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.20\linewidth} p{0.10\linewidth} p{0.60\linewidth}

   +-----------------+--------------------+-----------------------------------------------+
   | Element         | Value              | Description                                   |
   +=================+====================+===============================================+
   | statusCodeId    | *(Defined in SXL)* | Status code id. Determined by the signal      |
   |                 |                    | exchange list (SXL). The examples in this     |
   |                 |                    | document are defined according to the         |
   |                 |                    | following format: Syyy, where yyy is a        |
   |                 |                    | unique number.                                |
   +-----------------+--------------------+-----------------------------------------------+
   | name            | *(Defined in SXL)* | Unique reference of the value                 |
   +-----------------+--------------------+-----------------------------------------------+
   | type            | *(Defined in SXL)* | The data type of the value.                   |
   | *(Only in SXL,  |                    | Defined in the SXL but is not actually sent   |
   | not actually    |                    |                                               |
   | sent)*          |                    | | General definition:                         |
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
   | unit            | *(Defined in SXL)* | The unit of the value. Defined in SXL but     |
   | *(Only is SXL,  |                    | are not actually sent                         |
   | not actually    |                    |                                               |
   | sent)*          |                    |                                               |
   +-----------------+--------------------+-----------------------------------------------+
   | status          | *(Defined in SXL)* | Value                                         |
   +-----------------+--------------------+-----------------------------------------------+
   | ageState        | recent             | The value is up to date                       |
   |                 +--------------------+-----------------------------------------------+
   |                 | old                | The value is not up to date                   |
   |                 +--------------------+-----------------------------------------------+
   |                 | undefined          | The component does not exist and no           |
   |                 |                    | subscription will be performed                |
   |                 +--------------------+-----------------------------------------------+
   |                 | unknown            | The value is unknown and no subscription will |
   |                 |                    | be performed.                                 |
   +-----------------+--------------------+-----------------------------------------------+

..

Structure for a status subscription request message on one or several objects
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A message with the request of subscription to a status has the
structure according to the example below. The message is used for
constructing a list of subscriptions of statuses, digital and analogue
values and events that are desirable to send to supervision system,
e.g. temperature, wind speed, power consumption, manual control.

.. code-block:: xml
   :name: xml-status-subscribe

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4 RoadSideMessage_1_0_1_4.xsd">
       <message xsi:type="StatusSubscribe">
           <messageId>{E68A0010-C336-41ac-BD58-5C80A72C7092}</messageId>
           <ntsObjectId>F+40100=416CG100</ntsObjectId>
           <externalNtsId>23055</externalNtsId>
           <componentId>AB+84001=860VA001</componentId>
           <statuses>
               <status>
                   <statusCodeId>S003</statusCodeId>
                   <name>speed</name>
                   <updateRate>10</updateRate>
               </status>
               <status>
                   <statusCodeId>S003</statusCodeId>
                   <name>occupancy</name>
                   <updateRate>10</updateRate>
               </status>
           </statuses>
       </message>
   </roadSideMessage>

The following table is describing the variable content of the message:

Basic (xsi:type = StatusRequest)

.. figtable::
   :nofig:
   :label: table-statusrequest-basic
   :caption: Basic (xsi:type = StatusRequest)
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.10\linewidth} p{0.45\linewidth}

   +------------+------------+--------------------------------------------------------+
   | Element    | Value      | Description                                            |
   +============+============+========================================================+
   | updateRate | *(string)* | Determines the interval of which the message should be |
   |            |            | sent. Defined in seconds with decimals, e.g. ”2.5” for |
   |            |            | 2.5 seconds. Dot (.) is used as decimal point. If “0”  |
   |            |            | means that the value should be sent when changed.      |
   +------------+------------+--------------------------------------------------------+

..

Structure for a response message with answer to a request for status subscription for one or several objects
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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
but instead answer with this type of message where "ageState" contains
"undefined".

.. code-block:: xml
   :name: xml-status-update

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4 RoadSideMessage_1_0_1_4.xsd">
       <message xsi:type="StatusUpdate">
           <messageId>{E68A0010-C336-41ac-BD58-5C80A72C7092}</messageId>
           <ntsObjectId>F+40100=416CG100</ntsObjectId>
           <externalNtsId>23055</externalNtsId>
           <componentId>AB+84001=860VA001</componentId>
           <statusTimeStamp>2009-10-02T14:34:34.345Z</statusTimeStamp>
           <returnvalues>
               <returnvalue>
                   <statusCodeId>S003</statusCodeId>
                   <name>speed</name>
                   <status>70</status>
                   <ageState>recent</ageState>
               </returnvalue>
               <returnvalue>
                   <statusCodeId>S003</statusCodeId>
                   <name>occupancy</name>
                   <status>14</status>
                   <ageState>recent</ageState>
               </returnvalue>
           </returnvalues>
       </message>
   </roadSideMessage>

The allowed content is described in Table :num:`table-statusresponse` and
:num:`table-statusresponse-returnvalues`.

Structure for a status unsubscription message on one or several objects
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A message with the request of unsubscription to a status has the structure
according to the example below. The request unsubscribes on one or several
objects. No particular answer is sent for this request, other than the
usual message acknowledgement.

.. code-block:: xml
   :name: xml-status-unsubscribe

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4 RoadSideMessage_1_0_1_4.xsd">
       <message xsi:type="StatusUnSubscribe">
           <messageId>{E68A0010-C336-41ac-BD58-5C80A72C7092}</messageId>
           <ntsObjectId>F+40100=416CG100</ntsObjectId>
           <externalNtsId>23055</externalNtsId>
           <componentId>AB+84001=860VA001</componentId>
           <statuses>
               <status>
                   <statusCodeId>S003</statusCodeId>
                   <name>speed</name>
               </status>
               <status>
                   <statusCodeId>S003</statusCodeId>
                   <name>occupancy</name>
               </status>
           </statuses>
       </message>
   </roadSideMessage>

The allowed content is described in Table :num:`table-statusrequest`

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

1. Update with status of an object

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

.. code-block:: xml
   :name: xml-command-req

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4 RoadSideMessage_1_0_1_4.xsd">
       <message xsi:type="CommandRequest">
       <messageId>{E68A0010-C336-41ac-BD58-5C80A72C7092}</messageId>
       <ntsObjectId>F+40100=416CG100</ntsObjectId>
       <externalNtsId>23055</externalNtsId>
       <componentId>AB+84001=860VA001</componentId>
       <arguments>
           <argument>
               <commandCodeId>M002</commandCodeId>
               <name>1</name>
               <command>setValue</command>
               <value>Auto</value>
           </argument>
       </arguments>
       </message>
   </roadSideMessage>

The following table is describing the variable content of the message:

Values to send with the command (arguments)

.. figtable::
   :nofig:
   :label: table-command-arguments
   :caption: command-arguments
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.20\linewidth} p{0.10\linewidth} p{0.60\linewidth}

   +-----------------+--------------------+-----------------------------------------------+
   | Element         | Value              | Description                                   |
   +=================+====================+===============================================+
   | commandCodeId   | *(Defined in SXL)* | Command code id. Determined in the signal     |
   |                 |                    | exchange list (SXL). The examples in this     |
   |                 |                    | document are defined according to the         |
   |                 |                    | following format: Myyy, where yyy is a unique |
   |                 |                    | number.                                       |
   +-----------------+--------------------+-----------------------------------------------+
   | name            | *(Defined in SXL)* | Unique reference of the value                 |
   +-----------------+--------------------+-----------------------------------------------+
   | command         | *(Defined in SXL)* | Command                                       |
   +-----------------+--------------------+-----------------------------------------------+
   | type            | *(Defined in SXL)* | The data type of the value.                   |
   | *(Only in SXL,  |                    | Defined in the SXL but is not actually sent   |
   | not actually    |                    |                                               |
   | sent)*          |                    | | General definition:                         |
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
   | unit            | *(Defined in SXL)* | The unit of the value. Defined in SXL but     |
   | *(Only is SXL,  |                    | are not actually sent                         |
   | not actually    |                    |                                               |
   | sent)*          |                    |                                               |
   +-----------------+--------------------+-----------------------------------------------+
   | value           | *(Defined in SXL)* | Value                                         |
   +-----------------+--------------------+-----------------------------------------------+

..

Structure of command response message
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A command response message has the structure according to the example
below. A command response message informs about the updated value of the
requested object.
If the object is not known then the site must not disconnect
but instead answer with this type of message where "ageState" contains
"undefined".

.. code-block:: xml
   :name: xml-command-response

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4 RoadSideMessage_1_0_1_4.xsd">
       <message xsi:type="CommandResponse">
           <messageId>{E68A0010-C336-41ac-BD58-5C80A72C7092}</messageId>
           <ntsObjectId>F+40100=416CG100</ntsObjectId>
           <externalNtsId>23055</externalNtsId>
           <componentId>AB+84001=860VA001</componentId>
           <commandTimeStamp>2009-10-02T14:34:34.345Z</commandTimeStamp>
           <returnvalues>
               <returnvalue>
                   <commandCodeId>M002</commandCodeId>
                   <ageState>recent</ageState>
                   <name>1</name>
                   <value>Auto</value>
               </returnvalue>
           </returnvalues>
       </message>
   </roadSideMessage>

The following table is describing the variable content of the message:

Basic (xsi:type = CommandResponse)

.. figtable::
   :nofig:
   :label: table-command-response
   :caption: command-response
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.20\linewidth} p{0.15\linewidth} p{0.45\linewidth}

   +------------------+--------------------+------------------------------------------------------------------------------------+
   | Element          | Value              | Description                                                                        |
   +==================+====================+====================================================================================+
   | commandTimeStamp | *(timestamp)*      | The timestamp uses the W3C XML dateTime definition with a 3 decimal places.        |
   |                  |                    | All timestamps are set at the local level (and not in the supervision system) when |
   |                  |                    | the alarm occurs (and not when the message is sent). All timestamps uses UTC.      |
   +------------------+--------------------+------------------------------------------------------------------------------------+

..

Return values (returnvalue)
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. figtable::
   :nofig:
   :label: table-command-returnvalue
   :caption: command-returnvalue
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.20\linewidth} p{0.10\linewidth} p{0.60\linewidth}

   +-----------------+--------------------+-----------------------------------------------+
   | Element         | Value              | Description                                   |
   +=================+====================+===============================================+
   | commandCodeId   | *(Defined in SXL)* | Command code id. Determined in the signal     |
   |                 |                    | exchange list (SXL). The examples in this     |
   |                 |                    | document are defined according to the         |
   |                 |                    | following format: Myyy, where yyy is a unique |
   |                 |                    | number.                                       |
   +-----------------+--------------------+-----------------------------------------------+
   | ageState        | recent             | The value is up to date                       |
   |                 +--------------------+-----------------------------------------------+
   |                 | old                | The value is not up to date                   |
   |                 +--------------------+-----------------------------------------------+
   |                 | undefined          | The component does not exist                  |
   |                 +--------------------+-----------------------------------------------+
   |                 | unknown            | The value is unknown                          |
   +-----------------+--------------------+-----------------------------------------------+
   | name            | *(Defined in SXL)* | Unique reference of the value                 |
   +-----------------+--------------------+-----------------------------------------------+
   | type            | *(Defined in SXL)* | The data type of the value.                   |
   | *(Only in SXL,  |                    | Defined in the SXL but is not actually sent   |
   | not actually    |                    |                                               |
   | sent)*          |                    | | General definition:                         |
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
   | unit            | *(Defined in SXL)* | The unit of the value. Defined in SXL but     |
   | *(Only is SXL,  |                    | are not actually sent                         |
   | not actually    |                    |                                               |
   | sent)*          |                    |                                               |
   +-----------------+--------------------+-----------------------------------------------+
   | value           | *(Defined in SXL)* | Value                                         |
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

There are two types of message acknowledgement – Message
acknowledgment which confirms that the message was understood and
Message not acknowledged which indicates that the message was not
understood.

The acknowledgement messages are interaction driven and are sent when
any other type message are received.

Message structure – Message acknowledgement
"""""""""""""""""""""""""""""""""""""""""""

An acknowledgement message has the structure according to the example
below.

.. code-block:: xml
   :name: xml-ack

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4 RoadSideMessage_1_0_1_4.xsd">
       <message xsi:type="MessageAck">
           <originalMessageId>{E4FSD010-C336-41ac-BD58-5C80A72C7092}</originalMessageId>
       </message>
   </roadSideMessage>

The following table is describing the variable content of the message:

Basic (xsi:type = MessageAck)

.. figtable::
   :nofig:
   :label: table-messageack-basic
   :caption: Basic (xsi:type = MessageAck)
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.15\linewidth} p{0.10\linewidth} p{0.65\linewidth}

   +-------------------+------------+--------------------------------------------------------------------+
   | Element           | Value      | Description                                                        |
   +===================+============+====================================================================+
   | originalMessageId | *(GUID)*   | Message identity. Generated as a GUID (Globally unique identifier) |
   |                   |            | in the equipment that sent the message. Only version 4 of          |
   |                   |            | Leach-Salz UUID is used. This message identity is used in order to |
   |                   |            | inform about which message is being acknowledged.                  |
   +-------------------+------------+--------------------------------------------------------------------+

..

Message structure – Message not acknowledged
""""""""""""""""""""""""""""""""""""""""""""

A not acknowledgement message has the structure according to the example
below.

.. code-block:: xml
   :name: xml-notack

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4 RoadSideMessage_1_0_1_4.xsd">
       <message xsi:type="MessageNotAck">
           <originalMessageId>{E4FSD010-C336-41ac-BD58-5C80A72C7092}</originalMessageId>
           <reason>alarmCode: A054 does not exist</reason>
       </message>
   </roadSideMessage>

The following table is describing the variable content of the message:

Basic (xsi:type = MessageNotAck)

.. figtable::
   :nofig:
   :label: table-messagenoteack-basic
   :caption: Basic (xsi:type = MessageNotAck)
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.15\linewidth} p{0.10\linewidth} p{0.65\linewidth}

   +-------------------+--------------+--------------------------------------------------------------------+
   | Element           | Value        | Description                                                        |
   +===================+==============+====================================================================+
   | originalMessageId | *(GUID)*     | Message identity. Generated as a GUID (Globally unique identifier) |
   |                   |              | in the equipment that sent the message. Only version 4 of          |
   |                   |              | Leach-Salz UUID is used. This message identity is used in order to |
   |                   |              | inform about which message is being acknowledged.                  |
   +-------------------+--------------+--------------------------------------------------------------------+
   | reason            | *(optional)* | Error message where all relevant information about the nature of   |
   |                   |              | the error can be provided.                                         |
   +-------------------+--------------+--------------------------------------------------------------------+

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

Message structure
"""""""""""""""""

A version message has the structure according to the example below. In
the example below the system has support for RSMP version 1.0, 1.2 and
1.3 and SXL version 1.3 for site "F+40100=416".

.. code-block:: xml
   :name: xml-version

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4/RoadSideMessage_1_0_1_4.xsd">
       <message xsi:type="Version">
           <messageId>{E68A0010-C336-41ac-BD58-5C80A72C7092}</messageId>
           <siteIds>
               <siteId>F+40100=416</siteId>
           </siteIds>
           <rsmpVersions>
               <rsmpVersion>1.0</rsmpVersion>
               <rsmpVersion>1.2</rsmpVersion>
               <rsmpVersion>1.3</rsmpVersion>
           </rsmpVersions>
           <sxlVersion>1.3</sxlVersion>
       </message>
   </roadSideMessage>

The following table is describing the variable content of the message:

Basic (xsi:type = Version)

.. figtable::
   :nofig:
   :label: table-version-basic
   :caption: Basic (xsi:type = Version)
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.12\linewidth} p{0.18\linewidth} p{0.65\linewidth}

   +-------------+--------------------+--------------------------------------------------------------------+
   | Element     | Value              | Description                                                        |
   +=============+====================+====================================================================+
   | siteId      | *(Defined in SXL)* | Site identity. Used in order to refer to a “logical” identity of a |
   |             |                    | site.                                                              |
   |             |                    |                                                                    |
   |             |                    | | At the STA, the following formats can be used:                   |
   |             |                    |                                                                    |
   |             |                    | - The site id from the STAs component id standard TDOK 2012:1171   |
   |             |                    |   e.g. ”40100”.                                                    |
   |             |                    | - It is also possible to use the full component id (TDOK 2012:1171)|
   |             |                    |   of the grouped object in the site in case the site id part of    |
   |             |                    |   the component id is insufficient in order to uniquely identify a |
   |             |                    |   site.                                                            |
   |             |                    |                                                                    |
   |             |                    | All the site ids that are used in the RSMP connection are sent     |
   |             |                    | in the message                                                     |
   +-------------+--------------------+--------------------------------------------------------------------+
   | rsmpVersion | *(Defined in the   | Version of RSMP. E.g. ”1.0”, ”1.1” or ”1.3”                        |
   |             | guideline)*        |                                                                    |
   +-------------+--------------------+--------------------------------------------------------------------+
   | sxlRevision | *(Defined in SXL)* | Revision of SXL. E.g ”1.3”                                         |
   +-------------+--------------------+--------------------------------------------------------------------+

..

Message exchange between site and supervision system/other equipment
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Message acknowledgement (see section :ref:`message-acknowledgement`) is
implicit in the following figures.

The site sends a version message

.. image:: /img/msc/version_site.png

1. Version message is sent from the site

Supervision system/other equipment sends version message

.. image:: /img/msc/version_system.png

1. Version message is send from supervision system/other equipment

.. _watchdog:

Watchdog
^^^^^^^^

The primary purpose of watchdog messages is to ensure that the
communication remains established and to detect any communication
disruptions between site and supervision system. For any subsystem
alarms are used instead. The secondary purpose of watchdog messages is
to provide a timestamp that can be used for simple time
synchronization. Unless other time synchronization method is used or
other reasons apply, the site should synchronize its clock using the
timestamp from watchdog messages – both at communication
establishment and then at least once every 24 hours.

Watchdog messages are sent in both directions, both from the site and
from the supervision system. At initial communication establishment
(after version message) the watchdog message should be sent.

The interval duration for sending watchdog messages should be
configurable at both the site and the supervision system. The default
setting should be (1) once a minute.

Message structure
"""""""""""""""""

A watchdog message has the structure according to the example below.

.. code-block:: xml
   :name: xml-watchdog

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4/RoadSideMessage_1_0_1_4.xsd">
       <message xsi:type="Watchdog">
           <messageId>{E68A0010-C336-41ac-BD58-5C80A72C7092}</messageId>
           <watchdogTimestamp>2009-10-02T14:34:34.341Z</watchdogTimestamp>
       </message>
   </roadSideMessage>

The following table is describing the variable content of the message:

Basic (xsi:type = Watchdog)

.. figtable::
   :nofig:
   :label: table-watchdog-basic
   :caption: Basic (xsi:type = Watchdog)
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.10\linewidth} p{0.60\linewidth}

   ================== ============= ==========================================
   Element            Value         Description
   ================== ============= ==========================================
   watchdogtimestamp  *(timestamp)* The timestamp uses the W3C XML dateTime
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

