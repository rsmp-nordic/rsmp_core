.. _signal-exchange-list:

Signal Exchange List (SXL)
==========================
A signal exchange list (:term:`SXL`) specifies the interface for a type of equipment or area of functionality.

The interface consists of component types, and the alarm, command, and status messages
used to interact with these component types.

SXLs are machine-readable specifications, not executable artifacts.

A site implements one or more SXLs, which together form the site interface, used to interact with the site.

An SXL can depend on other SXLs, which makes it possible to organize and compose SXLs to facilitate reuse.

Before publishing an SXL site interface, SXL dependency resolution must be performed to check dependencies,
resulting in a manifest of exact versions.

.. _sxl-definition:

SXL Definition
--------------
An SXL is identified by it's name, and is published with a version.

It defines component types, which are logical or physical parts of a site,
and the alarm, command, and status messages used to interact with these component types.

It also details the meaning of aggregated status bits, functional positions and functional states.

It can declare dependencies on other SXLs, which allows it to rely on component types and message codes from these SXLs.

.. _sxl-name:

SXL Name and Description
^^^^^^^^^^^^^^^^^^^^^^^^
An SXL is identified by a name, for example ``traffic_light_controller`` or ``tlc``.
Names can contain only lowercase letters, digits, hyphens, underscores and forrward slashes.

It also has description, which is a short descriptive text that.

.. code-block:: yaml

meta:
  name: traffic_light_controller
  description: Nordic Traffic Light Controller Interface

A site cannot use two SXLs with the same name. You should therefore take care
in choosing names that are unique within the context where they will be used.

.. _sxl-version:

SXL Version
^^^^^^^^^^^
An SXL has a version, e.g. "1.3.1", which must follow Semantic Versioning (SemVer) format.

.. code-block:: yaml

meta:
  version: 1.3.1

Given a version number MAJOR.MINOR.PATCH, you must increment the:

MAJOR version when you make incompatible API changes
MINOR version when you add functionality in a backward compatible manner
PATCH version when you make backward compatible bug fixes

SXL versions are used to determine whether a site and the supervisor has compatible versions,
as well as when resolving dependencies between SXLs.

.. _sxl-prefix:

SXL Prefix
^^^^^^^^^^
An SXL can optionally define a prefix which is prepended to all component types and message codes
in the SXL.

A prefix is a convenience feature that reduces the need to repeat the same prefix in all component types and message codes.
It has functional significance. Implementations must still use the full component type and message code ids

.. code-block:: yaml

meta:
  prefix: tlc/
types:
  group:
    description: Signal group

Here, the type defined will be ``tlc/group`` (``tlc/`` concatenated with ``group``).

If you need to define component types or message codes with different prefixes in the same SXL,
e.g. "sensor/radar" and "tlc/radar", a prefix cannot be used.

.. _sxl-component-types:

SXL Component Types
^^^^^^^^^^^^^^^^^^^
An SXL defines the available :term:`component types<type>`. Components are the logical or physical part of a site.

Only lowercase letters, digits, hyphens, underscores and forward slashes are allowed in component types.

Component type ids must be unique within the SXL. 

Component types can be organized into a hierarchy using forward slashes.
You can use multiple levels if needed.

.. code-block:: yaml

  types:
    tlc/sg:
      description: Signal group
    tlc/dl:
      description: Detector logic

Each type must have a short description.

Using an abbreviated version  of the SXL name as a scope for component types is often practical,
but not required, please see the section on :ref:`sxl-scopes`.

.. _sxl_codes:

SXL Message Codes
^^^^^^^^^^^^^^^^^
An SXL can define alarms, commands and statuses, each identified by a :term:`message code`.

Only lowercase letters, digits, hyphens, underscores and forward slashes are allowed.
Codes must be unique within the SXL.

Message codes can be organized into a hierarchy using forward slashes.

For example, a traffic light controller SXL might define the code id ``tlc/M0001``
or ``tlc/plan/set`` for a command to set the current time plan.

Using an abbreviated version of the SXL name as a scope for message codes is often practical,
but not required, please see the section on :ref:`sxl-scopes`.

.. _sxl-message-types:

Message types
^^^^^^^^^^^^^
The message types **Aggregated status**, **Alarm**, **Status** and **Commands**
are defined in the SXL.

Using the Excel format: alarms, aggregated status, statuses, and commands are
defined in their own sheets.

Using the YAML format: each message type is defined like this:

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

At least one argument is required for commands and statuses; arguments are optional for alarms.


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
The alarm category is defined by a single character, either ``T`` or ``D``.

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
   In addition to :term:`functional position`, the Excel version of the SXL
   can also differentiate between different kinds of command messages using
   :term:`maneuver` and :term:`parameter` sections. However, their use has no
   functional significance from a protocol point of view.

Arguments and return values
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Argument and return values make it possible to send extra information in
messages. It is possible to send binary data (base64), such as bitmap
pictures or other data, both to a site and to supervision system. The
signal exchange list must clarify exactly which data type which is used
in each case. There is no limitation of the number of arguments and
return values which can be defined for a given message. Argument and return
values is defined as extra columns for each row in the signal exchange
list.

- Arguments can be sent with command messages
- Return values can be sent with responses to status requests or as extra
  information with alarm messages

The following table defines the message types which support arguments and
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

.. _sxl-scope:

SXL Scopes
^^^^^^^^^^
Two SXLs that define the same component type or message code cannot be used together on the same site.

To ensure relevant SXLs can be used together, forward slashes should therefore be used to
scope component types and message codes into hierarchies that avoid clashes.

While it's often practical to use a scope that relate to the SXL name, e.g. ``tlc/`` for a
traffic light controller SLX , this is not a requirement.
You have the freedom to organize types and codes as needed.

For example, two SXLs could define different component types and message codes, but placed under the same
scope. For example, one SXL might define ``tlc/sg`` while another defines ``tlc/dl``.
This can be useful in case you want to split a big SXL into smaller SXLs while keeping the same scope,
or you  want to create an extension SXL that adds new types or codes under an existing scope.

If two SXLs define the exact same component type or message code you cannot use the SXLs together.
But it might be useful if you want to create a replacement SXL that is compatible with an existing SXL.

To maintain backward compatibility, some existing SXLs might use component types or message codes without
any forward slashes, e.g. a component type like ``sg`` or a command code like ``M0001``.
This works as long as you don't try to use another SXL with conflicting codes on the same site.

.. _sxl-dependencies:

SXL Dependencies
^^^^^^^^^^^^^^^^
An SXL can list other SXLs as dependencies. It can then rely on the definitions of component types and
message codes in the dependency SXLs.

For example, the SXL ``traffic_light_controller_advanced`` might depend on the SXL ``traffic_light_controller``.
It can then define a command ``tlc/adaptive`` which operates the component type ``tlc/dl`` already defined in
the ``traffic_light_controller`` SXL.

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

Before an SXL is published or updated, dependency resolution and reconciliation must be performed to ensure that dependencies can be met
and that there are no clashing component types or message codes.
Success results in a manifest which must be published together with the SXL.

.. _sxl-interface:

SXL Interface
^^^^^^^^^^^^^
A site can support one or more SXLs, which together form the site interface.

The supported SXLs are specified using SXL names and exact versions. Order is not significant.

.. code-block:: yaml

  interface:
    traffic_light_controller: 1.3.0
    public_priority: 2.1.0

The site interface is transmitted in the Version message sent by the site as part of the connection handshake.

All component types and message codes defined in the listed SXLs must be implemented by the site.
Component types and message codes from dependency SXLs will not be available, unless you explicitely list them in 
the interface.

Before the site interface is published (e.g. as part of a software update or a reconfiguration), dependency resolution
and reconciliation must be performed to ensure that the interface is congruent.
The resulting manifest is not published.

.. _sxl-processing:

SXL Processing
--------------
Before an SXL or site interface is published or updated, dependencies must be resolved and reconciled.

If both steps succeed, a manifest is created which lists all SXLs with exact versions, including (transitive) dependencies.

This SXL processing should be done using an appropriate tool which reads SXL definitions,
resolves dependencies, checks for symbol clashes and creates manifests.

.. _sxl-dependency-resolution:

SXL Dependency Resolution
^^^^^^^^^^^^^^^^^^^^^^^^^
Dependency resolution attempts to establish a set of exact SXL versions that satisfy all version requirements.

Dependency order is ignored. All requirements (including transitive requirements) are collected recursively.
The highest SemVer-compatible version for each SXL is then selected deterministically.

If any version requirement is unsatisfiable or a cyclic dependency is detected, resolution fails.

.. _sxl-reconcilitation::

SXL Reconcilation
^^^^^^^^^^^^^^^^^
Once a set of exact SXL version have been established by dependency resolution, they must be reconciled.
Reconcilitation checks that no two SXLs define the same component type or message code.

Identical definitions across SXLs are not allowed.

.. _sxl-manifest:

SXL Manifest
^^^^^^^^^^^^
If dependency resolution and reconcilitation succeeds, a manifest is created.

A manifest represents a set of SXLs at exact versions that satisfy all version requirements,
and is guaranteed not to have any conflicting component types or message codes.

SXLs are listed using their names and exact versions, and must be ordered by name according to natural sorting.

.. code-block:: yaml

  meta:
    created_at: 2025-01-05T12:00:00Z
    created_by: sxl-tool v1.0.0
    format: 3.3.0
  manifest:
    public_priority: 2.1.0
    traffic_light_controller: 1.3.0
    traffic_light_controller_advanced: 1.0.0

The ``meta`` section contains metadata about the manifest itself, including:
- ``created_at`` is the timestamp when the manifest was created
- ``created_by`` is the tool and version used to create the manifest
- ``format`` is the RSMP core version that the manifest conforms to

When publishing an SXL, a valid manifest must be included.

For a site interface, the manifest is not published directly, but is reflected in the Version message sent by the site.
