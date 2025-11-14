.. _signal-exchange-list:

Signal Exchange List
====================
A signal exchange list (:term:`SXL`) defines component types, messages and behaviour for
a specific type of equipment of area of functionality. A site can support one or more SXLs.

An SXL defines component types, which are logical or physical parts of a site.
It then defines the alarm, command and statuse messages for each component type.

For the main component type it also details the meaning of aggregated status bits,
functional positions and functional states,


SXL Identifiers
---------------
An SXL is identified by an id and a name, for example ``tlc``, Traffic Light Controller.

Identifiers can use a hierarchical structure with slashes to define an SXL hierarchy,
for example ``tlc/advanced`` might be an child SXL which define optional advanced
features for traffic light controllers.

Child SXLs can reference the component types defined by their parent SXL(s). For instance,
if the ``tlc`` SXL defines a ``SignalGroup`` component type,
the ``tlc/advanced`` SXL can define messages for this component type, or otherwise refer to it.

When defining an SXL, commands, statuses, and alarms are always listed
with simple codes like ``M0001`` or ``S0002``.

Sites using a single SXL (e.g., just ``tlc``) can accept either qualified codes like ``tlc/M0001``
or simple unqualified codes like ``M0001``.

Sites using more than one SXL can only accept qualified codes.
For example, a command defined as ``M0001`` in the ``tlc/advanced`` SXL must be
sent using the code ``tlc/advanced/M0001`` (if the site uses multiple SXLs).


SXL Format
---------------
An SXL is defined using YAML format as desceribed below.

Alternatively, it can be described using Excel format, in which case each component and
message type is defined on a separate sheet.

.. note::
    In Excel versions, there is no separate min and max columns.
    Instead, allowed values can be defined using the Value column according
    to the following example: [0-100], where 0 is the minimum value and 100 is
    the maximum value.


.. component-types:

Component Types
---------------
An SXL defines **component types** used by the SXL.
For example a Traffic Light Controller SXL might define Signal Group and Detector Logic as component types.

The SXL defines alarms, statuses and commands for each component type.
Aggregated status and functional position/state is only defined for the main component type.


Component types are defined like this:

.. code-block:: yaml

   components:
     <component-type>:
      id: <component-type-id>
      aggregated_status:
        ...
      functional_position:
        ...
      alarms:
        ...
      statuses:
        ...
      commands:
        ...      

Where ``<component-type>`` is the name of the component type, e.g. "Traffic Light Controller",
and ``<component-type-id>`` is the id, e.g. "tc".

Depending on applicability, each component type can either have it's own
series or common series of alarm suffix (alarmCodeId), status codes
(statusCodeId) and command codes (commandCodeId).


Aggregated Status and Functional Position
-----------------------------------------
The main component sends AggregatedStatus messages, which contains eight status bits, as well as the
functional position and functional state.

The general meaning of the bits is defined in the core specification and cannot be fundamentally changed.

The main compoennt type  must define how each bit is used and whethr/how the functional position and
functional state is used.
Other compoennt types must ommit the ``aggregated_status`` and ``functional_position`` sections.

Example:
.. code-block:: yaml

  components:
    Traffic Light Controller:
      aggregated_status:
        1:
          title: Local mode
          description: Traffic Light Controller is in local mode. NTS has no control.
        3:
          title: High Priority Fault
          description: Traffic Light Controller is in fail-safe mode; e.g. yellow flash or dark mode
        4:
          title: Medium Priority Fault
          description: Traffic Light Controller has a medium priority fault, but not in fail-safe mode.
        5:
          title: Low Priority Fault
          description: Traffic Light Controller has a low priority fault. E.g. Detector fault
        6:
          title: Connected - In Use
          description: Traffic Light Controller is not in dark mode or in yellow flash
        7:
          title: Connected - Idle
          description: Traffic Light Controller is in dark mode or in yellow flash
      functional_position:
        start: Traffic Light Controller is starting up
        stop: Traffic Light Controller is stopping
      functional_state:
        normal: Controller is in normal mode
        yellow_flash: Controller is in yellow flash

- ``aggregated_status`` defines the aggregated status bits used by the SXL. Each bit must have a an integer from 1-8 as key,
and contains a title and optional description. See :ref:`state-bits`. Bits not used by the SXL must be omitted,
in which case they must always be set to false in AggregatedStatus messages.
- ``functional_position`` is an array of possible :term:`Functional position`s
- ``functional_state`` is an array of :term:`Functional state`s

``functional_position`` and ``functional_state`` must be omitted if the SXL does not use them.

Note: The actual Traffic Light Controller SXL does not use functional positions or states, so they are shown above
as examples only.

Messages
-------------
An SXL defines **Alarm**, **Status** and **Commands**:

.. code-block:: yaml

  components:
    <component-type>:
      ...
      alarms: ...
        ...
      statuses:
        ...
      commands:
        ...

Example:
.. code-block:: yaml

  components:
    Traffic Light Controller:
      ...
      alarms:
        A0001:
      A0001:
        description: |-
          Serious hardware error.
        priority: 2
        category: D
        from_version: 1.0.0
      statuses:
      S0014:
        description: |-
          Current time plan.
        from_version: 1.0.2
        arguments:
          status:
            type: integer_as_string
            description: Current time plan
            min: 1
            max: 255
          source:
            type: string_list_as_string
            description: Source of the status change
            values:
              operator_panel: Operator panel
              calendar_clock: Calendar/clock
              control_block: Control block
              forced: Forced due to external command e.g. supervisor
              startup: Set after startup mode
              other: Other reason
     commands:
      M0002:
        description: |-
          Sets current time plan.
        from_version: 1.0.1
        arguments:
          status:
            type: boolean_as_string
            description: |-
              False: Controller uses time plan according to programming
              True: Controller uses time plan according to command
          securityCode:
            type: string
            description: Security code 2
          timeplan:
            type: integer_as_string
            description: designation of time plan
            min: 1
            max: 255
        command: setPlan

This example defines:

- An alarm with the :term:`alarm code id` ``A0001``
- A status with the :term:`status code id` ``S0014``
- A command with the :term:`command code id` ``M0002``


Alarms
------
Each alarm is defined by its :term:`alarm code id` and contains the following fields:

- ``description``: alarm description
- ``category``: alarm category
- ``priority``: alarm priority
- ``externalAlarmCodeId`` (optional): :term:`External alarm code id`
- ``externalNtsAlarmCodeId`` (optional): :term:`External NTS alarm code id`
- ``from_version``: core version where this alarm was introduced
- ``arguments`` (optional): return values sent with the alarm

Description
^^^^^^^^^^^
The format of the description is free of choice but has the following requirements:

- Description is unique for the component type
- Description is defined in cooperation with the Purchaser before use

Category
^^^^^^^^
The alarm category is defined by a single character, either ``T`` or ``D``.

==========  ===============
Value       Description
==========  ===============
T           Traffic alarm
D           Technical alarm
==========  ===============

A **traffic alarm** indicates events in the traffic related functions or the technical processes that affects traffic.

A couple of examples from a tunnel:

- Stopped vehicle
- Fire alarm
- Error which affects message to motorists
- High level of :math:`CO_{2}` in traffic room
- etc.

**Technical alarms** are alarms that do not directly affect the traffic. One example of technical alarm is when an impulse fan stops working.

Priority
^^^^^^^^
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

Statuses
--------
Each status is defined by its :term:`status code id` and contains the following fields:

- ``description``: status description
- ``arguments``: the data fields sent with the status (at least one is required)
- ``from_version`` (optional): core version where this status was introduced
- ``deprecated`` (optional): marks the status as deprecated

Arguments
^^^^^^^^^
Arguments define the data fields sent with a status. Each argument contains:

- ``description``: argument description
- ``type``: the :ref:`data type<data_types>`
- ``min`` (optional): minimum value (only for *number* or *integer* data types)
- ``max`` (optional): maximum value (only for *number* or *integer* data types)
- ``values`` (optional): allowed values with descriptions (for enumerations)
- ``optional`` (optional): marks the argument as optional (defaults to required)
- ``pattern`` (optional): regular expression pattern for string validation


Commands
--------
Each command is defined by its :term:`command code id` and contains the following fields:

- ``description``: command description
- ``arguments``: the data fields sent with the command (at least one is required)
- ``command``: optionally used for RPC (Remote Procedure Call)
- ``from_version`` (optional): core version where this command was introduced
- ``deprecated`` (optional): marks the command as deprecated
- ``reserved`` (optional): marks the command as reserved for future use

Arguments
^^^^^^^^^
Arguments define the data fields sent with a command. Each argument contains:

- ``description``: argument description
- ``type``: the :ref:`data type<data_types>`
- ``min`` (optional): minimum value (only for *number* or *integer* data types)
- ``max`` (optional): maximum value (only for *number* or *integer* data types)
- ``values`` (optional): allowed values with descriptions (for enumerations)
- ``optional`` (optional): marks the argument as optional (defaults to required)
- ``pattern`` (optional): regular expression pattern for string validation
