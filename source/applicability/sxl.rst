.. _signal-exchange-list:

Signal Exchange List
====================
A signal exchange list (:term:`SXL`) defines the interface for a specific
type of equipment or area of functionality.

An SXL defines component types, which are logical or physical parts of a site,
and the alarm, command and status message use to interact with them.

It also details the meaning of aggregated status bits, functional positions
and functional states.

A site can support one or more SXLs.

.. _sxl-id:

SXL ID
------
An SXL is identified by an ID, for example ``tlc``.
IDs use UTF-8 and can contain only lowercase letters, digits, hyphens, underscores, full stop and forward slashes.

SXLs IDs must be unique. A site or supervisor cannot use two SXLs with the same ID.

.. _sxl-name:

SXL Name
--------
An SXL has a human readable name, for example "Traffic Light Controller".

.. _sxl-version:

SXL Version
-----------
An SXL has a version, e.g. "1.3.1", which must follow Semantic Versioning (SemVer) format:

<major>.<minor>.<patch>.

Patch versions are for backwards compatible bug fixes.
Minor versions are for backwards compatible new features.
Major versions are for incompatible changes.

This is used to determine whether a supervisor and a site supporting different versions of an SXL can use that SXL.

Compatibility is also important for SXLs :ref:`dependencies<sxl-dependencies>`.

.. _sxl-dependencies:

SXL Dependencies
----------------
An SXL can list other SXLs as dependencies.

A dependency is listed using an SXL ID and a minimum version.
For example, an SXL might list ``tlc`` version ``1.2.0`` as a dependency.

When an SXL lists another SXL as a dependency, it can use the component types defined by it.
It can also rely on alarms, statuses and commands defined by it.

For example, if the ``tlc`` SXL defines a ``sg`` signal group component type,
the ``tlc/advanced`` SXL can define a command that operate on this type of component.

A site can only use an SXL if it also supports all its dependencies, at the required minimum versions.

Cyclic dependencies are not allowed.

.. _sxl-hierarchy:

SXL Hierarchy
-------------
SXLs can be organized in a hierarchy by using forward slashes in their IDs.

For example, ``tlc/advanced`` would be a child SXL of the parent SXL ``tlc``,
which might define advanced features for traffic light controllers.

A child SXL does not automatically inherit the component types, alarms, statuses or commands
defined by the parent SXL.

Instead it must explicitly list the parent SXL as a dependency, at a minimum version.
This ensures that the required versions are explicit.

.. _sxl_codes:

SXL Code IDs
------------
An SXL can define alarms, commands and statuses, which all have a :term:`code id`.
Codes must be unique within the SXL.

Codes can use forward slashes to organize them in a hierarchy.

For example, a ``tlc`` SXL for traffic light controller might use the code id ``M0001``
or ``plan/set`` for a command to set a time plan.

When you send a command, status or alarm, the code must be qualified with the SXL ID. For example, a command defined as
``M0001`` in the ``tlc/advanced`` SXL must be sent using the code ``/tlc/advanced/M0001``.

Sites that support only a single SXL must also accept codes without the SXL ID prefix.

For example, a site using only the ``tlc`` SXL must also accept the unqualified code ``M0001``.


Message types
-------------

The message types **Alarm**, **Aggregated status**, **Status** and **Commands**
are defined in the SXL.

Using the Excel format; alarms, aggregated status, status and commands are
defined in their own sheet.

Using the YAML format; each message type is defined like this:

.. code-block:: yaml

  components:
    <component-type>:
      aggregated_status:
        1:
          title: Local mode
          description: In local mode
        2:
          title: No Communications
        3:
          title: High priority fault
          description: Fail safe mode
        4:
          title: Medium Priority Fault
          description: Medium priority fault, but not in fail safe mode
        5:
          title: Low Priority Fault
        6:
          title: Connected / Normal - In Use
        7:
          title: Connected / Normal - Idle
        8:
          title: Not Connected
      functional_position:
        <position-1>: start
        <position-2>: stop
      alarms:
        A0001:
          description: alarm description text
          priority: 1
          category: D
          externalAlarmCodeId: manufacturer specific alarm text
          externalNtsAlarmCodeId: 0000
          arguments:
            <argument-1>:
              type: integer
              min: 0
              max: 10
              description: A0001 argument 1
      statuses:
        S0001:
          description: status description text
          arguments:
            <argument-1>:
              type: string
              description: S0001 argument 1
      commands:
        M0001:
          description: command description text
          command: setStatus
          arguments:
            <argument-1>:
              type: boolean
              description: M0001 argument 1

  ..

This example defines:

- An alarm with the :term:`alarm code id` ``A0001``
- A status with the :term:`status code id` ``S0001``
- A command with the :term:`command code id` ``M0001``

Each with one argument named ``<argument-1>`` using integer, string and boolean
data types.

The alarm contains the fields:

- ``description`` is the alarm description
- ``category`` is the alarm category
- ``priority`` is the alarm priority
- ``externalAlarmCodeId`` is the :term:`External alarm code id`
- ``externalNtsAlarmCodeId`` is the :term:`External NTS alarm code id`

The status contains the fields:

- ``description`` is the status description

The command contains the fields:

- ``description`` is the command description
- ``command`` is optionally used for RPC (Remote Procedure Call)

An argument contains the fields:

- ``description`` is the argument description
- ``min`` is the minimum value (only for *number* or *integer* data types)
- ``max`` is the maximum value (only for *number* or *integer* data types)
- ``type`` is the :ref:`data type<data_types>`

At least one argument are required for command and statuses, but they are
optional in alarms.


.. note::

    In the Excel version of the SXL, there is no separate min and max columns.
    Instead, allowed values can be defined using the Value column according
    to the following example: [0-100], where 0 is the minimum value and 100 is
    the maximum value.

The aggregated status contains the fields:

- ``functional_position`` is the :term:`Functional position`

- ``functional_state`` is the :term:`Functional state`

- ``1-8`` is an array of eight booleans. Each with a title and optional
  description. See :ref:`state-bits`


.. _alarm-description:

Alarm description
^^^^^^^^^^^^^^^^^
The format of the description is free of choice but has the following
requirements:

- Description is unique for the component type
- Description is defined in cooperation with the Purchaser before use

.. _alarm-category:

Alarm category
^^^^^^^^^^^^^^
The alarm category is defined in by a single character, either ``T`` or ``D``.

==========  ===============
Value       Description
==========  ===============
T           Traffic alarm
D           Technical alarm
==========  ===============

A **traffic alarm** indicates events in the traffic related functions or the
technical processes that affects traffic.

A couple of examples from a tunnel:

- Stopped vehicle
- Fire alarm
- Error which affects message to motorists
- High level of :math:`CO_{2}` in traffic room
- etc.

**Technical alarms** are alarms that do not directly affect the traffic.
One example of technical alarm is when an impulse fan stops working.

.. _alarm-priority:

Alarm priority
^^^^^^^^^^^^^^
The priority of the alarm.

Defined in the SXL as a single character, ``1``, ``2`` or ``3``.

The following values are defined:

=====  ==============================
Value  Description
=====  ==============================
1      Alarm that requires immediate action.
2      Alarm that does not require immediate action, but action is planned during the next work shift.
3      Alarm that will be corrected during the next planned maintenance shift.
=====  ==============================

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

