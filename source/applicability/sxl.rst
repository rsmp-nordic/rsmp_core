.. _signal-exchange-list:

Signal Exchange List (SXL)
==========================
A signal exchange list (:term:`SXL`) specifies the interface for a type of equipment or area of functionality.

An SXL is identified by its name, and is published with a version following Semantic Versioning (SemVer) rules.

An SXL is defined using YAML format.

An SXL defines component types, and the alarm, command, and status messages used to interact with these component types.

An SXL can depend on other SXLs, and can then rely on component types and message codes from these SXLs.

A site implements one or more SXLs.

.. _sxl-overview:

Overview
--------

.. _sxl-name:

Name and Description
^^^^^^^^^^^^^^^^^^^^
An SXL is identified by a ``name``, e.g. ``nordic/traffic_light_controller`` or ``nordic/traffic_light_controller/advanced``.

Forward slashes can be used to organize names in a hierarchy.
Names can contain only lowercase letters, digits, hyphens, underscores and forward slashes.

A site cannot use two SXLs with the same name. SXL names should therefore be globally unique.

To enhance visibility and interoperability, RSMP Nordic maintains a global registry of unique SXL names.
To register an SXL, the name must be unique. If it relates to a specific country or region it
must include a top-level part in the form ``<country_code>/...`` or ``<region>/...``,
e.g. ``se/...`` or ``eu/...``.

Unregistered SXLs can be used, but are not guaranteed to be unique and could therefore cause name clashes
if used together with other SXLs. We therefore recommend registering all SXLs that are intended for public use.

Some legacy SXL use names without slashes, e.g. ``tlc`` for the Nordic Traffic Light Controller SXL.

An SXL also has a ``description``, which is a short human-readable text e.g. ``Traffic Light Controller``.

.. code-block:: yaml

  meta:
    name: nordic/traffic_light_controller/advanced
    description: Nordic Traffic Light Controller Advanced Functionality

.. _sxl-version:

Version
^^^^^^^
An SXL has a version, e.g. ``1.3.1``, which must follow Semantic Versioning conventions.

Given a version number MAJOR.MINOR.PATCH, you must increment the:

- MAJOR version when you make incompatible changes
- MINOR version when you add functionality in a backward compatible manner
- PATCH version when you make backward compatible bug fixes

Preview and build info cannot be used as part of version strings.

SXL versions are used to determine whether a site and the supervisor have compatible versions,
and when resolving dependencies between SXLs.


.. code-block:: yaml

  meta:
    version: 1.3.1

SXL versions are used to determine which SXLs can be used on the connection.
How this is done is explained in :ref:`version-negotiation`.

.. _sxl-scope:

Scope
^^^^^
The top-level ``scope`` sets the scope for component types and message codes throughout an SXL document.
The scope is an absolute path, e.g. ``/nordic/tlc``. Each path segment consists of one or more
letters (A-Z, a-z), digits, hyphens or underscores. A single slash separates segments.
Only the root scope (``/``) ends with a slash. If ``scope`` is omitted, the scope is the root.

A name without a leading slash resolves from the document scope. For example, in scope
``/nordic/tlc``, the command ``plan/set`` resolves to ``nordic/tlc/plan/set``.
A reference beginning with a slash resolves from the root. For example, ``/other/dl`` refers
to the component type ``other/dl`` supplied by a dependency. A message defined for that component
type still takes its scope from the document.

The following SXL does not define a scope and therefore default to root scope:

.. code-block:: yaml

  components:
    nordic/tlc/tc:
      alarms:
        nordic/tlc/deadlock:
          description: Signal plan causes deadlock
      statuses:
        nordic/tlc/plan/current:
          description: Get the current signal plan
      commands:
        nordic/tlc/plan/set:
          description: Set signal plan

The same definitions can be written relative to a scope:

.. code-block:: yaml

  scope: /nordic/tlc
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

RSMP messages must use fully qualified component types and message codes without a leading slash.
For either example, a command request uses ``nordic/tlc/plan/set`` and a deadlock alarm uses ``nordic/tlc/deadlock``.

An SXL's name and scope are independent. For example, ``nordic/traffic_light_controller`` and
``nordic/traffic_light_controller/advanced`` can both use the scope ``/nordic/tlc``.
SXLs used together must define distinct fully qualified component types and message codes.
Sharing a scope allows an SXL to be split into modules, extended, or replaced while preserving existing identifiers.

.. _sxl-component-types:

Component Types
^^^^^^^^^^^^^^^
An SXL defines the available :term:`component` types. Components are the logical or physical part of a site.

.. code-block:: yaml

  components:
    nordic/tlc/sg:
      description: Signal group
    nordic/tlc/dl:
      description: Detector logic

Each type must have a short description.

.. _sxl-messages:

Messages
--------

The content of **Alarm**, **Status** and **Command** messages is defined in the SXL.
The :ref:`aggregated-status-message` and its :ref:`state-bits` are defined solely
by the core specification.

The following example defines messages in the root scope:

.. code-block:: yaml

  components:
    <component-type>:
      alarms:
        A0001:
          description: alarm description text
          priority: 1
          category: D
          externalAlarmCodeId: manufacturer specific alarm text
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

At least one argument is required for commands and statuses, but they are
optional in alarms.

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
technical processes that affect traffic.

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

.. tabularcolumns:: |\Yl{0.20}|\Yl{0.40}|

.. table:: Functional differences

   =================  =========================================
   Message type       Sent when
   =================  =========================================
   Alarm              On change *or* request
   Aggregated status  On establishment, change *or* request
   Status             On request *or* according to subscription
   Command            On request
   =================  =========================================

Arguments and return values
^^^^^^^^^^^^^^^^^^^^^^^^^^^
Argument and return values make it possible to send extra information in
messages. It is possible to send binary data (base64), such as bitmap
pictures or other data, both to a site and to a supervision system. The
signal exchange list must clarify exactly which data type is used
in each case. There is no limitation of the number of arguments and
return values which can be defined for a given message. Argument and return
values are defined as extra columns for each row in the signal exchange
list.

- Arguments can be sent with command messages
- Return values can be sent with response on status requests or as extra
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

Composition
-----------

.. _sxl-dependencies:

Dependencies
^^^^^^^^^^^^
An SXL can declare dependency on other SXLs. It can then rely on the definitions of component types,
message codes or behaviour from those SXLs.

For example, a basic SXL ``nordic/traffic_light_controller`` might define the component type ``nordic/tlc/dl`` for detector logics,
and some messages to interact with this component type.

Another SXL ``nordic/traffic_light_controller/advanced`` might depend on ``nordic/traffic_light_controller``.
It can then define a command like ``nordic/tlc/adaptive`` which operates on the component type ``nordic/tlc/dl`` already
defined in ``nordic/traffic_light_controller``

Dependencies are listed using SXL names and a version requirement string.
The order of dependencies is not significant.

.. code-block:: yaml

  dependencies:
    nordic/traffic_light_controller: "~4.3"

Version requirement strings support exact version, comparison operators ``>``, ``>=``, ``<``, ``<=`` and the compatibility operator ``~``.

.. list-table:: Version requirement operators
   :header-rows: 1

   * - Requirement
     - Translation
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
   :header-rows: 1

   * - Requirement
     - Translation
   * - ">=1.3.0 and <2.0.0"
     - any version from 1.3.0 (inclusive) to 2.0.0 (exclusive)

To ensure that dependency resolution works as intended, you must update
the SXL version correctly when making changes to an SXL, according to Semantic
Versioning (SemVer) rules, please see the section on :ref:`sxl-version`.

Before an SXL is published or updated, dependencies must be resolved to
ensure that dependencies can be met and no component types or message codes clash.

If resolution succeeds, a manifest is produced which lists the exact version of all SXLs in the dependency tree,
including the SXL itself. The manifest must be published together with the SXL.


.. _sxl-list:

SXL List
^^^^^^^^
A site can support one or more SXL. The supported SXLs are listed as part of the Version message sent by
the site as part of the connection handshake.

For each SXL, the site must send its name, exact version and :ref:`scope <sxl-scope>`. Order is not significant.

If an SXL is listed, the site must implement the full SXL, including all components, messages and behavior defined
in the SXL.

Dependency SXLs will not be exposed unless explicitly listed by the site.
For example, if a site lists ``nordic/traffic_light_controller/advanced`` but not ``nordic/traffic_light_controller``,
the supervisor will not be able to use any of the messages defined in ``nordic/traffic_light_controller``,
even if ``nordic/traffic_light_controller/advanced`` depends on ``nordic/traffic_light_controller``.
