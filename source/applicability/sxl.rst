.. _signal-exchange-list:

Signal Exchange List (SXL)
==========================
A signal exchange list (:term:`SXL`) specifies the interface for a type of equipment or area of functionality.

An SXL is identified by its name, and is published with a version following Semantic Versioning (SemVer) rules.

An SXL defines component types, and the alarm, command, and status messages used to interact with these component types.
It also details the meaning of aggregated status bits, functional positions and functional states.

An SXL can depend on other SXLs, and can then rely on component types and message codes from these SXLs.

A site implements one or more SXLs.

.. _sxl-name:

Name and Description
^^^^^^^^^^^^^^^^^^^^
An SXL is identified by a ``name``, e.g. "traffic_light_controller" or "traffic_light_controller/advanced".

An SXL also has a ``description``, which is a short human-readable text e.g. "Traffic Light Controller".

Forward slashes can be used to organize names in a hierarchy.
Names can contain only lowercase letters, digits, hyphens, underscores and forward slashes.

A site cannot use two SXLs with the same name. SXLs names should therefore be globally unique.

RSMP Nordic maintains a registry of unique SXL names. An SXL that relates to a specific country or region
must indicate this in the name as ``<country_code>/...`` or ``<region>/...``.

.. code-block:: yaml

  meta:
    name: traffic_light_controller/advanced
    description: Advanced Traffic Light Controller Functionality

Note: Some legacy SXL use names without a country code er region, e.g. ``tlc`` for the Nordic Traffic Light Controller SXL.

.. _sxl-version:

Version
^^^^^^^
An SXL has a version, e.g. "1.3.1", which must follow Semantic Versioning conventions.

Given a version number MAJOR.MINOR.PATCH, you must increment the:

- MAJOR version when you make incompatible changes
- MINOR version when you add functionality in a backward compatible manner
- PATCH version when you make backward compatible bug fixes

Preview and build info cannot be used as part of version strings.

SXL versions are used to determine whether a site and the supervisor has compatible versions,
and when resolving dependencies between SXLs.


.. code-block:: yaml

  meta:
    version: 1.3.1

SXL versions are used to determine whether a site and the supervisor
can establish communication. How this is done is explained in :ref:`rsmpsxl-version`.

.. _sxl-prefix:

Prefix
^^^^^^
An SXL can optionally define a prefix which will be prepended to all component types and message codes
in the SXL, e.g. "tlc/" for a traffic light controller SXL.

A prefix can contain letters, digits, hyphens, underscores and forward slashes. It must end with a forward slash.

If you intend to define everything under the same scope, e.g. "tlc/", it is recommended to define a prefix.
It guarantees that everything in the SXL will be scoped under the correct prefix and avoids having to repeat the same prefix
string everywhere. It also makes it easy to change the prefix if this is ever needed.

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

The result is the same and you still need to use the full paths, e.g. "tlc/plan/set" when changing the signal plan,
or ``tlc/deadlock`` when sending a deadlock alarm.

A prefix should be short and does not have to mirror the SXL name. You must ensure that SXLs expected to
be used together do not define the same component types or message codes.

For example, a traffic light controller SXL like ``traffic_light_controller`` could use the prefix ``tlc/``.

Two differnt SXLs can use the same prefix, as long as long as they either don't define the same component types or message codes,
or are not intended to be used together on the same site. The ability for different SXLs to use the same prefix support use cases like:

- modularity: splitting a large SXL into smaller SXLs all using the while same prefix.
- extensions:  a new SXL which adds functionality under a prefix defined in an existing SXL.
- replacement: a new SXL that is compatible with an existing SXL, and can we used as a replacement.

.. _sxl-component-types:

Component Types
^^^^^^^^^^^^^^^
An SXL defines the available :term:`component` types. Components are the logical or physical part of a site.

.. code-block:: yaml

  components:
    tlc/sg:
      description: Signal group
    tlc/dl:
      description: Detector logic

Each type must have a short description.

.. _sxl-messages:

Messages
--------

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

.. _sxl-composition:

SXL Composition
---------------

.. _sxl-dependencies:

SXL Dependencies
^^^^^^^^^^^^^^^^
An SXL can declare dependecy on other SXLs. It can then rely on the definitions of component types,
message codes or behaviour from those SXLs.

For example, a basic SXL ``traffic_light_controller`` might define the component type ``tlc/dl`` for detector logics,
and some messages to interact with this component type.

Another SXL ``traffic_light_controller/advanced`` might depend on ``traffic_light_controller``.
It can then define a command like ``tlc/adaptive`` which operates on the component type ``tlc/dl`` already
defined in ``traffic_light_controller``

Dependencies are listed using SXL names and a version requirement string.
The order of dependencies is not significant.

.. code-block:: yaml

  dependencies:
    traffic_light_controller: "~4.3"

Version requirement strings support exact version, comparison operators ``>``, ``>=``, ``<``, ``<=`` and the compatibility operator ``~``.

.. list-table:: Version requirement operators
   :header: "Requirement", "Translation"

   * - "1.3.1"
     - exact version 1.3.1 only
   * - ">=1.3.0"
     - version 1.3.0 or higher
   * - "<2.0.0"
     - any version lower than 2.0.0
   * - "~1.3"
     - any version from 1.3 compatible with it according to semantic versioning rules, i.e. >=1.3.0 and <2.0.0.

Two comparison operators can be combined with ``and``:

.. list-table:: Version requirement combination
   :header: "Requirement", "Translation"

    * - ">=1.3.0 and <2.0.0"
      - any version from 1.3.0 (inclusive) to 2.0.0 (exclusive)

To ensure that dependency resolution works as intended, you must update
the SXL version correctly when making changes to an SXL, according to Semantic
Versioning (SemVer) rules, please see the section on :ref:`sxl-version`.

Before an SXL is published or updated, dependencies must be resolved to
ensure that dependencies can be met and no component types or message codes clash.

If resolution succeeds, a manifest is produced which list the exact version of all SXLs in the dependency tree,
including the SXL itself. The manifest must be published together with the SXL.

.. _sxl-list:

Site SXLs
^^^^^^^^^
A site can support one or more SXLs, which together form the site sxl list.

The supported SXLs are listed using SXL names and exact versions. Order is not significant.

.. code-block:: yaml

  sxls:
    traffic_light_controller: 1.3.0
    variable_message_sign: 1.0.12

The SXL list is included in the Version message sent by the site as part of the connection handshake.

All component types and message codes defined in the listed SXLs must be implemented by the site.

Component types and message codes from dependency SXLs will not be available unless you explicitely list them.

