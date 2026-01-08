.. _signal-exchange-list:

Signal Exchange List (SXL)
==========================
A signal exchange list (:term:`SXL`) specifies the interface for a type of equipment or area of functionality.

SXLs are machine-readable specifications, not executable artifacts.

A site implements one or more SXLs, which together form the site interface, used to interact with the site.

An SXL can depend on other SXLs, which makes it possible to organize and compose SXLs to facilitate reuse.

Before publishing an SXL site interface, SXL dependency resolution must be performed to check dependencies,
resulting in a manifest of exact versions.

.. _sxl-definition:

SXL Definition
--------------
An SXL has a name and a version.

It defines component types, which are logical or physical parts of a site,
and the alarm, command, and status messages used to interact with these component types.

It also details the meaning of aggregated status bits, functional positions and functional states.

It can declare dependencies on other SXLs, which allows it to rely on component types and message codes from these SXLs.

.. _sxl-name:

SXL Name
^^^^^^^^
The SXL is identified by a name, for example ``traffic_light_controller``.
Names can contain only lowercase letters, digits, hyphens, underscores and forrward slashes.

.. code-block:: yaml

  name: traffic_light_controller

A site cannot use two SXLs with the same name. You should therefore take care
in choosing names that are unique within the context where they will be used.

.. _sxl-version:

SXL Version
^^^^^^^^^^^
An SXL has a version, e.g. "1.3.1", which must follow Semantic Versioning (SemVer) format.

Given a version number MAJOR.MINOR.PATCH, you must increment the:

MAJOR version when you make incompatible API changes
MINOR version when you add functionality in a backward compatible manner
PATCH version when you make backward compatible bug fixes

SXL versions are used to determine whether a site and the supervisor has compatible versions,
as well as when resolving dependencies between SXLs.

.. _sxl-component-types:

SXL Component Types
^^^^^^^^^^^^^^^^^^^
SXLs can define component types, which represent the types of logical or physical parts of a site.

When defining alarms, commands and statuses, the component types are used to indicate what a message applies to.

Each component type is identified by a :term:`type id`.
Only lowercase letters, digits, hyphens, underscores and forward slashes are allowed.

Component type ids must be unique within the SXL. 

Component types can be organized into a hierarchy using forward slashes.

For example, a traffic light controller SXL might define the type ``tlc/sg`` for signal groups
and ``tlc/dl`` for detector logics. You can use several levels if needed.

.. _sxl_codes:

SXL Codes
^^^^^^^^^
An SXL can define alarms, commands and statuses, each identified by a :term:`code`.
Only lowercase letters, digits, hyphens, underscores and forward slashes are allowed.
Codes must be unique within the SXL.

Codes are used to identify specific alarms, commands and statuses when sending messages.

Codes can be organized into a hierarchy using forward slashes.

For example, a traffic light controller SXL might define the code id ``tlc/M0001``
or ``tlc/plan/set`` for a command to set a time plan.

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
A site interface is composed of the SXLs that the site supports.
An SXL can depend on other SXLs.

.. _sxl-prefixes:

SXL Prefixes
^^^^^^^^^^^^
To ensure relevant SXLs can be used together, forward slashes should be used to
organize component types and alarm, status, and command codes into hierarchies
that avoid clashes.

While it's often practical to use a prefix that relate to
the SXL name, e.g. ``tlc/`` for a traffic light controller SLX , this is not a requirement.
You have the freedom to organize types and codes as needed.

For example, two SXLs with different names could both define types and codes under the same
 prefix ``tlc/``, e.g. ``tlc/sg`` in one SXL and ``tlc/dl`` in the other.
This ccan be useful in case you want to split a big SXL into smaller SXLs, while keeping the same prefix,
or if you want to create an extension SXL that adds new types and codes under an existing prefix.

Two SXLs can also define the exact same code. This means you cannot use them together, but it can be
useful if you want to create a replacement SXL that is compatible with an existing SXL.

To maintain backward compatibility, some existing SXLs might use codes without any forward slashes,
e.g. a command code like ``M0001``. As long as you don't use another SXL with conflicting
codes on the same site, this is not a problem.

.. _sxl-dependencies:

SXL Dependencies
^^^^^^^^^^^^^^^^
An SXL can list other SXLs as dependencies.

When an SXL depend on another SXL, it can rely on the definitions of component types and alarm,
status and command codes that the dependency SXL defines.

For example, let's assume that the ``traffic_light_controller`` SXL defines a ``tlc/sg`` component type.
If the ``traffic_light_controller_advanced`` SXL depends
on ``traffic_light_controller``, then it can define a command that operates on the ``tlc/sg`` type of component.

Dependencies are listed using the SXL names and a version requirement. The order of dependencies is not significant.

For example, a radar SXL might depend on a more basic sensor SXL like this:

.. code-block:: yaml

  dependencies:
    sensor: "~1.3"

Requirements support exact version, comparison operators ``>``, ``>=``, ``<``, ``<=`` and the compatibility operator ``~``.

.. list-table:: Version requirement operators
   :header: "Requirement", "Translation"

   * - "1.3.1"
     - exact version 1.3.1 only
   * - ">=1.3.0"
     - version 1.3.0 or higher
   * - "<2.0.0"
     - any version lower than 2.0.0
   * - "~1.3"
     - any version compatible with 1.3 according to semantic versioning rules, i.e. >=1.3.0 and <2.0.0.

Two comparison operators can be combined with ``and``:

.. list-table:: Version requirement combination
   :header: "Requirement", "Translation"

    * - ">=1.3.0 and <2.0.0"
      - any version from 1.3.0 (inclusive) to 2.0.0 (exclusive)

To ensure that dependency resolution works as intended, it's important to update
the SXL version correctly when making changes to an SXL, according to Semantic
Versioning (SemVer) rules.

Before an SXL, or SXL update, is published, dependency resolution must be performed to ensure that dependencies can be met.
A manifest must be created as a result of the dependecy resolution and must be published together with the SXL.

.. _sxl-site-specification:

SXL Site Interface
^^^^^^^^^^^^^^^^^^
A site can support one or more SXLs, which together form the site interface.

The supported SXLs are specified using SXL names and exact versions:

.. code-block:: yaml

  interface:
    traffic_light_controller: 1.3.0
    public_priority: 2.1.0

The site interface (list of SXLs) is transmitted in the Version message sent by the site as part of the connection handshake.

All types and message defined in the listed SXLs will be available to supervisor.
Component types, alarms, commands and statuses from dependency SXLs will not be available. If you want them available,
you must explicitely list relevant dependency SXL in the site interface.

Before the site interface can published (e.g as part of a firmware update or a reconfiguration), dependency resolution must
be performed to ensure that all SXL dependencies are met and the interface is congruent.

.. _sxl-processing:

SXL Processing
--------------
An SXL is a machine-readable specification that can references other SXLs as dependencies.
A site interface is a list of SXLs.

Before an SXL and site interface is published, dependencies must be resolved and reconciled.
If both steps succeed, a manifest is created that lists exact versions of all SXLs, including (transitive) dependencies.

This should be done using an appropriate SXL processing tool that reads SXL definitions,
resolves dependencies, creates manifests and checks for symbol clashes.

.. _sxl-dependency-resolution:

SXL Dependency Resolution
^^^^^^^^^^^^^^^^^^^^^^^^^
Dependency resolution must be performed before an SXL or site interface is published to establish a set of
exact versions that satisfy all version requirements.

Dependency resolution must be performed before an SXL or site interface is published to establish a set of exact
versions that satisfy all version requirements.
Dependency order is ignored: the resolver recursively collects all requirements (including transitive requirements)
and deterministically selects the highest SemVer-compatible version for each SXL.

If requirements are unsatisfiable or a cyclic dependency is detected, resolution fails.

All version requirements must be met together, and no conflicting requirements or cyclic dependencies are allowed.


.. _sxl-reconcilitation::

SXL Reconcilation
^^^^^^^^^^^^^^^^^
Once a set of exact SXL version have been established by dependency resolution, they must be reconsiled to
ensure that there are no symbol clashes.

Reconcilitation checks that two SXL do not define the same component type or alarm, status or command code.

Identical definitions across SXLs are not allowed.

.. _sxl-manifest:

SXL Manifest
^^^^^^^^^^^^
If both dependency resolution and reconcilitation succeeds a manifest is created.

A manifest represent a set of SXLs at exact version that satisfy all version requirements,
and is guaranteed not to have any symbol clashes.

SXLs are listed using their names and exact versions, and must be ordered by name according to natural sorting.

.. code-block:: yaml

  manifest:
    public_priority: 2.1.0
    traffic_light_controller: 1.3.0
    traffic_light_controller_advanced: 1.0.0

When publishing an SXL the manifest must be included.

For a site interface, the manifest is not published directly, but is reflected in the Version message sent by the site.
