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
data types. It also defines the aggregated status (only bit 1 and 2).

At least one argument are required for command and statuses, but they are
optional in alarms.


Site configuration
==================

A site configuration defines the individual objects (or components) that exists
in a specific site. It also defines the relationship between those objects.

The site configuration can either be defined as a separate YAML file or be
combined with the YAML file of the SXL when needed. The Excel file always
combines the SXL and the site configuration.

Meta data
---------
The site configuration may define a set of meta data of a specific site.
It is defined in the first sheet named "Version" in in the Excel version and at
the very top of the YAML version.

It contains:

.. table:: meta data

   ================= ================
   Excel             YAML
   ================= ================
   Plant id          ``id``
   Plant name        ``description``
   Constructor       ``constructor``
   Reviewed          *(not used)*
   Approved          *(not used)*
   Created date      ``created-date``
   SXL revision [#]_ ``version``
   RSMP version      ``rsmp-version``
   ================= ================

.. rubric:: Footnotes

.. [#] Revision number and Revision date


Objects
-------

A site consists of objects, identified by unique component ids (``cId``).

Using the Excel format; objects are defined in it's own sheet - one for each
site.
Using the YAML format, each object is defined lite this:

.. code-block:: yaml

  sites:
    [site-id]:
      description: [site description]
      objects:
        [object type]:
          [object-1]:
            componentId: AA+BBCCC=DDDEEFFF
            ntsObjectId: AA+BBCCC=DDDEEFFF
            externalNtsId: 00000

Where:

* ``[site-id]`` is the site id. This is needed during initial handshake
* ``[site description]``. Site description
* ``[object-type]`` defines which object type the object belongs to
* ``[object-1]`` is the name of the object. For instance "signal group 1"

An object can either be categorized as a **single object** or **grouped
object**. There must be at least one grouped object which is typically also
the main component. Grouped objects are defined by **componentId** and
**ntsObjectId** are being set equal. Single objects have a unique
**componentId** but uses the **ntsObjectId** of their main component.

**externalNtsId** is optional and only used if the object is intended to
be sent to :term:`NTS`.

Overview on functional differences between different message types
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The following table defines the functional differences between
different message types.

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

Definitions
-----------
The following notions are used as titles from the columns in the SXL. All
the notions corresponds to the element with the same name in the
basic structure.

The following table defines the different versions of command messages.

.. tabularcolumns:: |\Yl{0.25}|\Yl{0.75}|

.. table:: Commands - different versions

   +------------------------+-----------------------------------------------+
   | Notion                 | Description                                   |
   +========================+===============================================+
   | Functional position    | Designed for NTS. Provides command options    |
   |                        | for an NTS object. In order to get the status |
   |                        | the corresponding status functionalPosition   |
   |                        | in Aggregated status is used.                 |
   +------------------------+-----------------------------------------------+
   | Functional state       | Not used                                      |
   +------------------------+-----------------------------------------------+
   | Maneuver               | Possible command options for individual       |
   |                        | objects for groups of objects from management |
   |                        | system (not NTS). May also apply to automatic |
   |                        | control. For instance, "start" or "stop"      |
   +------------------------+-----------------------------------------------+
   | Parameter              | Used for modification of technical or         |
   |                        | autonomous traffic parameters of the equipment|
   +------------------------+-----------------------------------------------+

Functional relationships in the signal exchange list
----------------------------------------------------

Functional states
^^^^^^^^^^^^^^^^^
The functional states which an object can enter should also be possible to
control. The commands which are defined in **"Functional states**
in the **Commands** sheet should correlate to the functional states
which are defined in **functionalPosition** in "**Aggregated status**".

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

Version management
------------------

Version of RSMP
^^^^^^^^^^^^^^^
The version of RSMP defines the overall version of RSMP. All documents
which are part of the RSMP specification refers to version of RSMP. The
following table defines the principles for version numbering for each
document.

.. tabularcolumns:: |\Yl{0.30}|\Yl{0.40}|

.. table:: Version management

   =================================  ========================
   Document                           Principles of versioning
   =================================  ========================
   RSMP specification                 Version of RSMP
   Signal exchange list (SXL)         Own version *and* version of RSMP
   =================================  ========================

The document "RSMP specification" uses the version of RSMP, for instance, "1.0".

The signal exchange list (SXL) has it's own version but which version RSMP
that the SXL uses must de defined.

When a new version RSMP is established all associated documents need to be
updated to reflect this.

Revision of SXL
^^^^^^^^^^^^^^^
Revision of SXL is unique for a site. In order to uniquely identify a SXL
for a supervision system the identity of the site (siteId) and it's
version of SXL (SXL Revision) needs to be known. In each SXL there must
defined which version of RSMP which it is conforms to.

In order to support a common SXL for many sites where the alarms, status,
and command message types are mostly shared - but there is a risk of
differences can emerge; it is recommended that a table is added on the
front page of each SXL the sites are using. The following table defines
an example for the design of the table.

.. tabularcolumns:: |\Yl{0.10}|\Yl{0.30}|

.. table:: Revision of SXL

   ======  =============================
   Site    Revision of SXL which is used
   ======  =============================
   Site 1  1.1
   Site 2  1.0
   Site 3  1.1
   ======  =============================

The purpose is to be able to update the SXL with a new revision and at the
same time inform about which sites which the revision applies to.


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

