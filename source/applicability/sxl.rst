.. _signal-exchange-list:

Signal Exchange List (SXL)
==========================
A signal exchange list (:term:`SXL`) defines the interface for a specific
type of equipment or area of functionality.

A site can support one or more SXLs.

.. _sxl-definition:

SXL Definition
--------------
An SXL defines component types, which are logical or physical parts of a site,
and the alarm, command, and status messages used to interact with them.

It also details the meaning of aggregated status bits, functional positions
and functional states.

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

.. _sxl-message-types:
.. _sxl-dependencies:

SXL Dependencies
^^^^^^^^^^^^^^^^
An SXL can list other SXLs as dependencies.

When an SXL depend on another SXL, it can rely on the definitions of component types and alarm,
status and command codes the dependency.

For example, let's assume that the ``traffic_light_controller`` SXL defines a ``tlc/sg`` component type.
If the ``traffic_light_controller_advanced`` SXL depends
on ``traffic_light_controller``, then it can define a command that operates on the ``tlc/sg`` type of component.

Dependencies are listed using the SXL names and a version requirement. The order
of dependencies is not significant.

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

.. _sxl-processing:

SXL Processing
--------------

.. _sxl-dependency_resolution:

SXL Dependency Resolution
^^^^^^^^^^^^^^^^^^^^^^^^^
Before SXLs can be loaded, dependencies must be resolved. 

Dependency resolution must be performed whenever the set of SXLs used by a site changes.
For a site with a static set of SXLs, this can be part of a compilation or configuration step.

For sites that allow run-time changes to the set of SXLs, dependency resolution must be performed
whenever SXLs are added, removed or updated.

SXLs are resolved recursively using depth-first, in the order they are listed.
Cyclic dependencies are not allowed and will cause dependency resolution to fail for the involved SXLs

All SXLs that can be fully resolved are included in the resulting manifest.

.. _sxl-manifest:

SXL Manifest
^^^^^^^^^^^^
Dependency resolution results in an SXL manifest, which lists SXLs and their dependencies, and their exact versions.

.. code-block:: yaml

  manifest:
    traffic_light_controller: 1.3.0
    traffic_light_controller_advanced: 1.0.0
    public_priority: 2.1.0

A manifest must represent a valid set of SXLs, where all dependencies are met.

.. _sxl-loading:

SXL Loading
^^^^^^^^^^^
Before the SXLs in a manifest can be used they must be loaded.

The SXLs listed in the manifest is loaded one by one, in the order they are listed, at the exact version
specified.

If the SXL is not available at the specified version, or cannot be fetched, loading of that SXL fails.

Loading an SXL involves reading athe list of component types and alarms, status and command codes it defines, and adding it to a combined symbol table.

Loading an SXL fails if a symbol with the same id has already been defined by a previously loaded SXL in the manifest, in which case
none of the symbols from the SXL is added to the symbol table.

After loading all SXLs in the manifest, the combined symbol table contains all component types and alarm,
status and command codes available for use.
