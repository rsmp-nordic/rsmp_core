.. _signal-exchange-list:

Signal Exchange List
====================

.. raw:: latex

   % Skip the contents chapter
   \refstepcounter{section}

Purpose
-------
The purpose with this appendix is to define the format and function of the
signal exchange list. This appendix works as a 'best practice' and does not
define requirements.

Scope
-----
The scope of this appendix is signal exchange list (SXL) which plays a
central role for the function of RSMP. It is recommended to read this
document to get a deeper understanding of for instance implementation
of the RSMP and when designing a new SXL.

Definitions
-----------
All definitions are defined in the RSMP specification.

Responsibility
--------------
The STA provides this interface specification only as information. The
STA does not take responsibility for any consequences which implementation
of the specification can cause manufacturers or third parties.

Signal exchange list
--------------------
The signal exchange list an important functional part of RSMP. The
specification of RSMP is defined in the main document. A template
of the signal exchange list is available on request.

Since the information in every message which is sent with the
communication protocol is dynamic is a predefined signal exchange list
is prerequisite to be able to establish communication. The signal
exchange list defines which message types (signals) which is possible
to send to a specific equipment or object. It is formatted according to
predefined principles which is defined below.

Structure
^^^^^^^^^
The following sections presents the format and contens of the SXL. Each
section corresponds to the names of each sheet in the SXL.

First page
""""""""""
The sheet "First page" defines site(s), revision and date of the SXL.

Object types and object
"""""""""""""""""""""""
The "object types" sheet defines the types of object that can exist in a
site, i.e. "LED".

The object sheet defines the number of each type of object that exists in
the site. If more that one site is defined in the SXL; then one object
sheet needs to be defined for each site.

If more that one site is defined in the same SXL; then the object sheet
is renamed to the name of the site.

The status for an object is suitable to be transmitted to NTS if the
NTS identity (externalNtsId) is defined.

Object definitions
""""""""""""""""""
Depending on applicability, each object type can either have it's own
series or common series of alarm suffix (alarmCodeId), status codes
(statusCodeId) and command codes (commandCodeId).

Single and grouped objects
""""""""""""""""""""""""""
An object can either be categorized as a **single object** or **grouped
object**.

An object is defined under the title **group object** if the object is a
component group according to TDOK 2012:1171. Other objects are defined
under **single object**.

If the **externalNtsId** field is used; it means that the object is adapted
to be sent to NTS.

Other sheets
""""""""""""
The sheets **Alarm**, **Aggregated status**, **Status** and **Command**
corresponds to the respective message type which is defined in the RSMP
specification.

- Italic text which is used as title in columns is not part of the
  protocol, but is only used as a guiding explanation text.
- Return values and argument are optional and there is no limitation on
  how many return values and arguments which can be used for a single
  message.

Overview on functional differencies between different message types
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
The following table defines the functional differences between
different message types.

.. figtable::
   :nofig:
   :label: table-functional-differencies
   :caption: Functional differencies
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.20\linewidth} p{0.40\linewidth} p{0.30\linewidth}

   =================  =========================================  ================================
   Message type       Sent when                                  Adapted to be transmitted to NTS
   =================  =========================================  ================================
   Alarm              On change                                  Yes
   Aggregated status  On change                                  Yes
   Status             On request *or* according to subscription  No
   Command            On request                                 Yes, partly (functional status)
   =================  =========================================  ================================

..

Definitions
^^^^^^^^^^^
The following notions are used as titles from the columns in the SXL. All
the notions corresponds to the element with the same name in the
basic structure.

The following table defines the different versions of command messages.

.. figtable::
   :nofig:
   :label: table-different-commands
   :caption: Commands - different versions
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.25\linewidth} p{0.65\linewidth}

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
   | Manouver               | Possible command options for individual       |
   |                        | objects for groups of objects from management |
   |                        | system (not NTS). May also apply to automatic |
   |                        | control. For instance, "start" or "stop"      |
   +------------------------+-----------------------------------------------+
   | Parameter              | Used for modification of technical or         |
   |                        | autonomous traffic parameters of the equipment|
   +------------------------+-----------------------------------------------+

..

Functional relationships in the signal exchange list
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Functional states
"""""""""""""""""
The functional which an object can have should also be possible to control.
Therefore should the command codes which are defined in **"Functional
states** in the **Commands** sheet also correlate the functional states
which are defined in **functionalPosition** in "**Aggregated status**".

Arguments and return values
"""""""""""""""""""""""""""
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

.. figtable::
   :nofig:
   :label: table-support
   :caption: Support for arguments and return values
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.20\linewidth} p{0.20\linewidth} p{0.20\linewidth}

   =================  ========  ============
   Message type       Argument  Return value
   =================  ========  ============
   Alarm              No        Yes
   Aggregated status  No        No
   Status             No        Yes
   Commands           Yes       No
   =================  ========  ============

..

Version mangement
^^^^^^^^^^^^^^^^^

Version of RSMP
"""""""""""""""
The version of RSMP defines the overall version of RSMP. All documents
which are part of the RSMP specification refers to version of RSMP. The
following table defines the principles for version numbering for each
document.

.. figtable::
   :nofig:
   :label: table-version-management
   :caption: Version management
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.30\linewidth} p{0.40\linewidth}

   =================================  ========================
   Document                           Principles of versioning
   =================================  ========================
   RSMP specification                 Version of RSMP
   Signal exchange list (SXL)         Own version *and* version of RSMP
   =================================  ========================

..

The document "RSMP specification" uses the version of RSMP, for instance, "1.0".

The signal exchange list (SXL) has it's own version but which version RSMP
that the SXL uses must de defined.

When a new version RSMP is established all associated documents need to be
updated to reflect this.

Revision of SXL
"""""""""""""""
Revision of SXL is unique for a site. In order to uniquely identify a SXL
for a supervision system the identity of the site (siteId) and it's
version of SXL (SXL Revision) needs to be known. In each SXL there must
defined which version of RSMP which it is conforms to.

In order to support a common SXL for many sites where the alarms, status,
and command message types are mostly shared - but there is a risk of
differences can emerge; it is recommended that a table is added on the
front page of each SXL the sites are using. The following table defines
an example for the design of the table.

.. figtable::
   :nofig:
   :label: table-revision
   :caption: Revision of SXL
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.10\linewidth} p{0.30\linewidth}

   ======  =============================
   Site    Revision of SXL which is used
   ======  =============================
   Site 1  1.1
   Site 2  1.0
   Site 3  1.1
   ======  =============================

..

The purpose is to be able to update the SXL with a new revision and at the
samt time inform about which sites which the revision applies to.


Required signals
^^^^^^^^^^^^^^^^

Status messages
"""""""""""""""

Version of component
~~~~~~~~~~~~~~~~~~~~
To make sure that the site is equipped with the correct version of
components and to simplify troubleshooting there need to exists a special
status to request version of a component.

Current date and time
~~~~~~~~~~~~~~~~~~~~~
To make sure that the site is configured with the correct date and time
there needs to be a special status to request this. This type of status is
especially important for those implementations where the equipment's
protocol interface and the rest of it's logic doesn't share the same
clock. Please note that UTC should be used.

Command messages
""""""""""""""""

Change date and time
~~~~~~~~~~~~~~~~~~~~
If the automatic time synchronization is missing or disabled there should
be a possibility to set the date and time using a special command. Please
note that UTC should be used.

Best practices
^^^^^^^^^^^^^^
In order to fit as many technical areas as possible there some flexibility
while designing a signal exchange list. Below are some suggested
recommendations.

Definition of object types
""""""""""""""""""""""""""
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
""""""""""""""""""""""""
Read and write operations uses different message types in RSMP.

Read operation
~~~~~~~~~~~~~~
Status messages are used for read operations. Read operations works
as "Process value".

Sequence for a read operation:

1. When data is about to be read a status request is sent from supervision
   system or other site to the relevant site.
2. The site responds by sending the value from the equipment. The value
   is attached as a return value.

Write operation
~~~~~~~~~~~~~~~
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
   determine if the new value could be sent or or not.

Help and references
-------------------

- RSMP Specification
- RSMP - Template Signal Exchange list (SXL)

Change log
----------

.. figtable::
   :nofig:
   :label: table-changelog-sxl
   :caption: Changelog
   :loc: H
   :spec: >{\raggedright\arraybackslash}p{0.15\linewidth} p{0.15\linewidth} p{0.30\linewidth} p{0.15\linewidth}

   =========== ========== ============================================================= ==============
   Version     Date       Change                                                        Name (initals)
   =========== ========== ============================================================= ==============
   1.0         2011-05-20 Protocol clarified and watchdog revised                       DO
   3.0         2011-11-04 Protocol revised                                              DO
   3.1.1       2011-12-23 Minor revision                                                DO
   3.1.2       2012-02-29 Minor revision                                                DO
   3.1.3       2014-11-24 Minor revision                                                DO
   3.1.4       2017-11-03 Protocol revised                                              DO
   =========== ========== ============================================================= ==============

..
