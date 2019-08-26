.. _usage-of-json:

Usage of JSON
-------------

Comparison of elements
^^^^^^^^^^^^^^^^^^^^^^

The following table present a comparison of the names used in XML
verses JSON. Please note that the JSON elements are formatted as JSON
string elements and not JSON number or JSON boolean.

.. figtable::
   :nofig:
   :label: table-compare-xml-json
   :caption: Comparison XML - JSON
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.30\linewidth} p{0.20\linewidth}

   ============================== ===============
   Element in XML                 Element in JSON
   ============================== ===============
   acknowledgeState               ack
   ageState (status message)      age
   ageState (command message)     q
   aggregatedStatusSpecialisation aSS
   aggstatusTimeStamp             aSTS
   alarmCodeId                    aCId
   alarmSpecialisation            aSp
   alarmState                     aS
   timestamp                      ts
   arguments                      arg
   category                       cat
   command                        cO
   commandCodeId                  cCI
   commandTimeStamp               cTS
   componentId                    cId
   externalAlarmCodeId            xACId
   externalEventCodeId            xECId
   externalNtsAlarmCodeId         xNACId
   externalNtsId                  xNId
   functionalPosition             fP
   functionalState                fS
   message xsi:type               type
   messageId                      mId
   name                           n
   originalMessageId              oMId
   priority                       pri
   reason                         rea
   returnvalue                    rv
   returnvalues (alarm)           rvs
   returnvalues (statusresponse)  sS
   rsmpVersion                    vers
   rsmpVersions                   RSMP
   roadSideMessage mType:         rSMsg
   ntsObjectId                    ntsOId
   siteIds                        siteId
   siteId                         sId
   source                         source
   state                          se
   status                         s
   statuses                       sS
   statusCodeId                   sCI
   statusTimestamp                sTs
   suspendState                   sS
   sxlRevision                    SXL
   type                           t
   unit                           u
   updateRate                     uRt
   watchdogTimestamp              wTs
   ============================== ===============

Wrapping of packets
^^^^^^^^^^^^^^^^^^^

Both Json and XML packets can be tricky to decode unless one always
know that the packet is complete. Json lacks an end tag and an XML end
tag may be embedded in the text source. In order to reliably detect
the end of a packet one must therefore make an own parser of perform
tricks in the code, which is not very good.

In both Json and XML there could exist tab characters (0x09), CR
(0x0d) and LF (0x0a). Are the packets serialized using .NET those
special characters does not exist. Therefore it is a good practice to
use formfeed (0x0c), e.g. ’\f’ in C/C++/C#. Formfeed cannot be
embedded in the packets because those are encoded in UTF-8 so the
parser only needs to search the incoming buffer for 0x0c and deal with
every packet.

Example of wrapping of a packet:

.. code::
   :name: json-wrapping

    {
        "mType": "rSMsg",
        "type": "Alarm",
        "mId": "d2e9a9a1-a082-44f5-b4e0-6c9233-a204c",
        "ntsOId": "AB+81102=881WA001",
        "xNId": "23055",
        "cId": "AB+81102=881WA001",
        "aCId": "A001",
        "xACId": "Lamp error #14",
        "xNACId": "3052",
        "aSp": "acknowledge",
        "ack": "Acknowledged",
        "aS": "active",
        "sS": "notSuspended",
        "aTs": "2009-10-02T14:34:34.345Z",
        "cat": "b",
        "pri": "2",
        "rvs": [
         {
             "n": "color",
             "v": "red"
         }]
    }<0x0c>

Character between <> is the bytes binary content in hex (ASCII code),
ex <0x0c> is ASCII code 12, e.g. FF (formfeed).

Alarm messages
^^^^^^^^^^^^^^

Structure for an alarm message
""""""""""""""""""""""""""""""

The example below compares the message structure between the XML and JSON
formats. Please note that some lines may be wrapped.

.. code-block:: xml
   :name: XML - Structure for an alarm message

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
           <category>D</category>
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

.. code-block:: json
   :name: JSON - Structure for an alarm message

   {
       "mType": "rSMsg",
       "type": "Alarm",
       "mId": "E68A0010-C336-41ac-BD58-5C80A72C7092",
       "ntsOId": "F+40100=416CG100",
       "xNId": "23055",
       "cId": "AB+84001=860VA001",
       "aCId": "A001",
       "xACId": "Lampfel på lykta 1 (röd)",
       "xNACId": "3143",
       "aSp": "Issue",
       "ack": "notAcknowledged",
       "aS": "active",
       "sS": "notSuspended",
       "aTs": "2009-10-01T11:59:31.571Z",
       "cat": "D",
       "pri": "2",
       "rvs": [
           {
               "n": "signalgrupp",
               "v": "1"
           },{
               "n": "färg",
               "v": "röd"
           }
       ]
   }

XML/JSON code 1: Comparison of example of alarm message XML/JSON

Structure for alarm acknowledgement message
"""""""""""""""""""""""""""""""""""""""""""

The example below compares the message structure between the XML and JSON
formats. Please note that some lines may be wrapped.

.. code-block:: xml
   :name: XML - Structure for alarm acknowledgement message

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
           <alarmSpecialisation xsi:type="Acknowledge">
       </message>
   </roadSideMessage>

.. code-block:: json
   :name: JSON - Structure for alarm acknowledgement message

   {
       "mType": "rSMsg",
       "type": "Alarm",
       "mId": "E68A0010-C336-41ac-BD58-5C80A72C7092",
       "ntsOId": "F+40100=416CG100",
       "xNId": "23055",
       "cId": "AB+84001=860VA001",
       "aCId": "A001",
       "xACId": "Larmfel på lykta 1 (röd)",
       "xNACId": "3143",
       "aSp": "acknowledge",
       "ack": "Acknowledged",
       "aS": "active",
       "sS": "notSuspended",
       "aTs": "2009-10-01T11:59:31.571Z",
       "cat": "b",
       "pri": "2",
       "rvs": [
       {
           "n": "signalgrupp",
           "v": "1"
       },
       {
           "n": "färg",
           "v": "röd"
       }]
   }

XML/JSON code 2: Comparison of example of alarm acknowledgement XML/JSON

Structure for alarm suspend message
"""""""""""""""""""""""""""""""""""

The example below compares the message structure between the XML and JSON
formats. Please note that some lines may be wrapped.

.. code-block:: xml
   :name: XML - Structure for alarm suspend message

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

.. code-block:: json
   :name: JSON - Structure for alarm suspend message

   {
        "mType": "rSMsg",
        "type": "Alarm",
        "mId": "E68A0010-C336-41ac-BD58-5C80A72C7092",
        "ntsOId": "F+40100=416CG100",
        "xNId": "23055",
        "cId": "AB+84001=860VA001",
        "aCId": "A001",
        "xACId": "Larmfel på lykta 1 (röd)",
        "xNACId": "3143",
        "aSp": "suspend"
   }

XML/JSON code 3: Comparison of example of alarm suspend message XML/JSON

.. _aggregatedstatus:

Aggregated status Message
^^^^^^^^^^^^^^^^^^^^^^^^^

Message structure
"""""""""""""""""

The example below compares the message structure between the XML and JSON
formats. Please note that some lines may be wrapped.

.. code-block:: xml
   :name: XML - Aggregated status Message

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0" xmlns="http://roadsidemessage.vv.se/1_0_1_4"
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

.. code-block:: json
   :name: JSON - Aggregated status Message

   {
       "mType": "rSMsg",
       "type": "AggregatedStatus",
       "mId": "E68A0010-C336-41ac-BD58-5C80A72C7092",
       "ntsOId": "F+40100=416CG100",
       "xNId": "23055",
       "cId": "F+40100=416CG100",
       "aSTS": "2009-10-02T14:34:34.345Z",
       "fP": "Trafikstyrning",
       "fS": "Automatiskt nedsatt hastighet",
       "se": [
           "false",
           "true",
           "true",
           "false",
           "false",
           "false",
           "false",
           "false"
       ]
   }

XML/JSON code 4: Comparison of example of aggregated status message XML/JSON

Status Message
^^^^^^^^^^^^^^

Structure for a request of a status of one or several objects
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

The example below compares the message structure between the XML and JSON
formats. Please note that some lines may be wrapped.

.. code-block:: xml
   :name: XML - Status request

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

.. code-block:: json
   :name: JSON - Status request

   {
       "mType": "rSMsg",
       "type": "StatusRequest",
       "mId": "E68A0010-C336-41ac-BD58-5C80A72C7092",
       "ntsOId": "F+40100=416CG100",
       "xNId": "23055",
       "cId": "AB+84001=860VA001",
       "sS":[{
           "sCI": "S003",
           "n": "speed"
       },{
           "sCI": "S003",
           "n":"occupancy"
       }]
   }

XML/JSON code 5: Comparison of example of status request message XML/JSON

Structure for a message with status of one or several objects
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

The example below compares the message structure between the XML and JSON
formats. Please note that some lines may be wrapped.

.. code-block:: xml
   :name: XML - Status response

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
                   <ageState>recent</ageState>
                   <name>1</name>
                   <status>70</status>
               </returnvalue>
               <returnvalue>
                   <statusCodeId>S007</statusCodeId>
                   <ageState>unknown</ageState>
                   <name>1</name>
                   <status>0</status>
               </returnvalue>
           </returnvalues>
       </message>
   </roadSideMessage>

.. code-block:: json
   :name: JSON - Status response

   {
       "mType": "rSMsg",
       "type": "StatusResponse",
       "mId": "E68A0010-C336-41ac-BD58-5C80A72C7092",
       "ntsOId": "F+40100=416CG100",
       "xNId": "23055",
       "cId": "AB+84001=860VA001",
       "sTs": "2009-10-02T14:34:34.345Z",
       "sS":[{
           "sCI": "S003",
           "n":"1",   
           "s": "70",
           "q": "recent"
       },{
           "sCI": "S007",
           "n":"1",   
           "s": "0",
           "q": "unknown"
       }]
   }

XML/JSON code 6: Comparison of example of status response message XML/JSON

Structure for a status subscription request message on one or several objects
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

The example below compares the message structure between the XML and JSON
formats. Please note that some lines may be wrapped.

.. code-block:: xml
   :name: XML - Status subscribe

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

.. code-block:: json
   :name: JSON - Status subscribe

   {
       "mType": "rSMsg",
       "type": "StatusSubscribe",
       "mId": "E68A0010-C336-41ac-BD58-5C80A72C7092",
       "ntsOId": "F+40100=416CG100",
       "xNId": "23055",
       "cId": "AB+84001=860VA001",
       "sS":[{
           "sCI": "S003",   
           "n": "speed",
           "uRt": "10"
           },{
           "sCI": "S003",   
           "n": "occupancy",
           "uRt": "10"
       }]
   }

XML/JSON code 7: Comparison of example of status subscription message XML/JSON

Structure for a response message with answer to a request for status subscription for one or several objects
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

The example below compares the message structure between the XML and JSON
formats. Please note that some lines may be wrapped.

.. code-block:: xml
   :name: XML - Status update

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
                   <ageState>recent</ageState>
                   <name>1</name>
                   <status>70</status>
               </returnvalue>
               <returnvalue>
                   <statusCodeId>S007</statusCodeId>
                   <ageState>unknown</ageState>
                   <name>1</name>
                   <status>0</status>
               </returnvalue>
           </returnvalues>
       </message>
   </roadSideMessage>

.. code-block:: json
   :name: JSON - Status update

   {
       "mType": "rSMsg",
       "type": "StatusUpdate",
       "mId": "E68A0010-C336-41ac-BD58-5C80A72C7092",
       "ntsOId": "F+40100=416CG100",
       "xNId": "23055",
       "cId": "AB+84001=860VA001",
       "sTs": "2009-10-02T14:34:34.345Z",
       "sS":[{
           "sCI": "S003",
           "n": "1",   
           "s": "70",
           "q": "recent"
       },{
           "sCI": "S007",
           "n": "1",   
           "s": "0",
           "q": "unknown"
       }]
   }

XML/JSON code 8: Comparison of example of answer of status subscription message XML/JSON

Structure for a status unsubscription message on one or several objects
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

The example below compares the message structure between the XML and JSON
formats. Please note that some lines may be wrapped.

.. code-block:: xml
   :name: XML - Status unsubscribe

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

.. code-block:: json
   :name: JSON - Status unsubscribe

   {
       "mType": "rSMsg",
       "type": "StatusUnsubscribe",
       "mId": "E68A0010-C336-41ac-BD58-5C80A72C7092",
       "ntsOId": "F+40100=416CG100",
       "xNId": "23055",
       "cId": "AB+84001=860VA001",
       "sS":[{
           "sCI": "S003",   
           "n": "speed"
       },{
           "sCI": "S003",   
           "n": "occupancy"
       }]
   }

XML/JSON code 9: Comparison of example of answer of status unsubscription message XML/JSON

Command messages
^^^^^^^^^^^^^^^^

Structure of a command message request
""""""""""""""""""""""""""""""""""""""

The example below compares the message structure between the XML and JSON
formats. Please note that some lines may be wrapped.

.. code-block:: xml
   :name: XML - Command request

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
               <name>1</name><command>setValue</command>
               <value>Auto</value>
               </argument>
           </arguments>
       </message>
   </roadSideMessage>

.. code-block:: json
   :name: JSON - Command request

   {
       "mType": "rSMsg",
       "type": "CommandRequest",
       "mId": "E68A0010-C336-41ac-BD58-5C80A72C7092",
       "ntsOId": "F+40100=416CG100",
       "xNId": "23055",
       "cId": "AB+84001=860VA001",
       "arg": [
           {
               "cCI": "M003",
               "n": "1",
               "cO": "setValue",
               "v": "Auto"
           }
       ]
   }

XML/JSON code 10: Comparison of example of command request message XML/JSON

Structure of command response message
"""""""""""""""""""""""""""""""""""""

The example below compares the message structure between the XML and JSON
formats. Please note that some lines may be wrapped.

.. code-block:: xml
   :name: XML - Command response

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

.. code-block:: json
   :name: JSON - Command response

   {
       "mType": "rSMsg",
       "type": "CommandResponse",
       "mId": "E68A0010-C336-41ac-BD58-5C80A72C7092",
       "ntsOId": "F+40100=416CG100",
       "xNId": "23055",
       "cId": "AB+84001=860VA001",
       "cTS": "2009-10-02T14:34:34.345Z",
       "rvs": [
           {
               "cCI": "M002",
               "age": "recent",
               "n": "1",
               "v": "70"
           }
       ]
   }

XML/JSON code 11: Comparison of example of command response message XML/JSON

Message acknowledgement
^^^^^^^^^^^^^^^^^^^^^^^

Message structure – Message acknowledgement
"""""""""""""""""""""""""""""""""""""""""""

The example below compares the message structure between the XML and JSON
formats. Please note that some lines may be wrapped.

.. code-block:: xml
   :name: XML - Message acknowledgement

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4 RoadSideMessage_1_0_1_4.xsd">
       <message xsi:type="MessageAck">
           <originalMessageId>{E4FSD010-C336-41ac-BD58-5C80A72C7092}</originalMessageId>
       </message>
   </roadSideMessage>

.. code-block:: json
   :name: JSON - Message acknowledgement

   {
       "mType": "rSMsg",
       "type": "MessageAck",
       "oMId": "F4FSD010-D587-7A3B-8BD5-5C80A72C7154"
   }

XML/JSON code 12: Comparison of example of message acknowledgement XML/JSON

Message structure – Message not acknowledged
""""""""""""""""""""""""""""""""""""""""""""

The example below compares the message structure between the XML and JSON
formats. Please note that some lines may be wrapped.

.. code-block:: xml
   :name: XML - Message not acknowledged

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

.. code-block:: json
   :name: JSON - Message not acknowledged

   {
       "mType": "rSMsg",
       "type": "MessageNotAck",
       "oMId": "F4FSD010-D587-7A3B-8BD5-5C80A72C7154",
       "rea": "alarmCode: A054 does not exist"
   }

XML/JSON code 13: Comparison of example of message not acknowledged XML/JSON

RSMP/SXL Version
^^^^^^^^^^^^^^^^

Message structure
"""""""""""""""""

The example below compares the message structure between the XML and JSON
formats. Please note that some lines may be wrapped.

.. code-block:: xml
   :name: XML - RSMP/SXL Version

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4/RoadSideMessage_1_0_1_4.xsd">
       <message xsi:type="Version">
           <messageId>{E68A0010-C336-41ac-BD58-5C80A72C7092}</messageId>
           <siteIds>
               <siteId>F+40100=416CG100</siteId>
           </siteIds>
       <rsmpVersions>
           <rsmpVersion>1.0</rsmpVersion>
           <rsmpVersion>1.2</rsmpVersion>
           <rsmpVersion>1.3</rsmpVersion>
       </rsmpVersions>
       <sxlVersion>1.3</sxlVersion>
       </message>
   </roadSideMessage>

.. code-block:: json
   :name: JSON - RSMP/SXL Version

   {
       "mType": "rSMsg",
       "type": "Version",
       "mId": "E68A0010-C336-41ac-BD58-5C80A72C7092",
       "siteId": [
           {"sId": "F+40100=416CG100"}
       ],
       "RSMP": [
           {"vers": "1.0"},
           {"vers": "1.2"},
           {"vers": "1.3"}
       ],
       "SXL":"1.3"
   }

XML/JSON code 14: Comparison of example of version message XML/JSON

Watchdog
^^^^^^^^

Message structure
"""""""""""""""""

The example below compares the message structure between the XML and JSON
formats. Please note that some lines may be wrapped.

.. code-block:: xml
   :name: XML - Watchdog

   <?xml version="1.0" encoding="utf-8"?>
   <roadSideMessage modelBaseVersion="1.0"
      xmlns="http://roadsidemessage.vv.se/1_0_1_4"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://roadsidemessage.vv.se/1_0_1_4 RoadSideMessage_1_0_1_4.xsd">
       <message xsi:type="Watchdog">
           <messageId>{E68A0010-C336-41ac-BD58-5C80A72C7092}</messageId>
           <watchdogTimestamp>2009-10-02T14:34:34.345Z</watchdogTimestamp>
       </message>
   </roadSideMessage>

.. code-block:: json
   :name: JSON - Watchdog

   {
       "mType": "rSMsg",
       "type": "Watchdog",
       "mId": "E68A0010-C336-41ac-BD58-5C80A72C7092",
       "wTs": "2009-10-02T14:34:34.345Z",
   }

XML/JSON code 16: Comparison of watchdog messages XML/JSON

