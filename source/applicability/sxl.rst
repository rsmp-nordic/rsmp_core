.. _signal-exchange-list:

Signal Exchange List (SXL)
==========================
A signal exchange list (:term:`SXL`) specifies the interface for a type of equipment or area of functionality.

The interface consists of component types, and the alarm, command, and status messages
used to interact with these component types.

It also details the meaning of aggregated status bits, functional positions and functional states.

An SXL is identified by its name, and is published with a version following Semantic Versioning (SemVer) rules.

SXLs are machine-readable specifications, not executable artifacts.

.. _sxl-name:

Name and Description
^^^^^^^^^^^^^^^^^^^^
An SXL is identified by a ``name``, e.g. "nordic/variable_message_sign",  "eu/traffic_light_controller"
or "nordic/traffic_light_controller/advanced".

Forward slashes can be used to organize names in a hierarchy.
Names can contain only lowercase letters, digits, hyphens, underscores and forward slashes.

To enhance visibility and interoperability, RSMP Nordic maintains a global registry of unique SXL names.
To register an SXL, the name must be unique. If it relates to a specific country or region it
must include a top-level part in the form ``<country_code>/...`` or ``<region>/...``,
e.g. ``se/...`` or ``nordic/...``.

Unregistered SXLs can be used, but are not guaranteed to be unique and could therefore cause name clashes
if used together with other SXLs. We therefore recommend registering all SXLs that are intended for public use.

Some legacy SXL use names without slashes, e.g. ``tlc`` for the Nordic Traffic Light Controller SXL. These
should be migrated when possible, e.g. to ``nordic/traffic_light_controller``.

An SXL also has a ``description``, which is a short human-readable text e.g. "Nordic Traffic Light Controller".


.. code-block:: yaml

  meta:
    name: nordic/traffic_light_controller
    description: Nordic Traffic Light Controller

.. _sxl-version:

Version
^^^^^^^
An SXL has a version, e.g. "1.3.1", which must follow Semantic Versioning conventions.

Given a version number MAJOR.MINOR.PATCH, you must increment the:

- MAJOR version when you make incompatible API changes
- MINOR version when you add functionality in a backward compatible manner
- PATCH version when you make backward compatible bug fixes


.. code-block:: yaml

  meta:
    version: 1.3.1

SXL versions are used to determine whether a site and the supervisor has compatible versions and
can establish communication. How this is done is explained in :ref:`rsmpsxl-version`.

.. _sxl-prefix:

Prefix
^^^^^^
An SXL can optionally define a prefix which will be prepended to all component types and message codes
in the SXL, e.g. "tlc/" for a traffic light controller SXL.

A prefix can contain letters, digits, hyphens, underscores and forward slashes. It must end with a forward slash.

If you intend to define everything under the same scope, e.g. "nordic/", it is recommended to define a prefix.
It guarantees that everything in the SXL will be scoped under the same prefix and avoids having to repeat the same prefix
string everywhere.

Using a prefix has no functional difference from manually including the same prefix in all component types and message codes definitions.
When using the SXL you must still refer to component types and message code ids using their full paths including the prefix.

For example, this SXL defines everything by manually using "tlc/" as a prefix everywhere:

.. code-block:: yaml

  components:
    tlc/tc:
      alarms:
        tlc/deadlock:
          description: Signal plan causes deadlock
      statuses:
        tlc/plan/current:
          description: Get the current signal plan
      commands:
        tlc/plan/set:
          description: Set signal plan

Using a prefix, the SXL can be defined like this:

.. code-block:: yaml

  prefix: tlc/
  components:
    tc:
      alarms:
        deadlock:
          description: Signal plan causes deadlock
      statuses:
        plan/current:
          description: Get the current signal plan
      commands:
        plan/set:
          description: Set signal plan

The result is the same, you still need to use the full paths, e.g. ``tlc/plan/set`` when changing the signal plan,
or ``tlc/deadlock`` when sending a deadlock alarm.

A prefix does not have to mirror the SXL name and should be short.

For example, a traffic light controller SXL like ``nordic/traffic_light_controller`` could use the prefix ``tlc/``.

Two different SXLs can use the same prefix, as long as they are not intended to be used together on the same site.
Elements defined under the prefix must still differ if the SXL are going to be used together.
This flexibility enables use cases like a new SXL that is compatible with an existing SXL, and can be used as a drop-in replacement.


.. _sxl-component-types:

SXL Component Types
^^^^^^^^^^^^^^^^^^^
An SXL defines the available :term:`component types<Component type>`. Components are the logical or physical part of a site.

Only lowercase letters, digits, hyphens, underscores and forward slashes are allowed in component types.
Component type must be unique within the SXL. 

Component types can be organized into a hierarchy using forward slashes.

.. code-block:: yaml

  components:
    tlc/sg:
      description: Signal group
    tlc/dl:
      description: Detector logic

Each type must have a short description.

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

