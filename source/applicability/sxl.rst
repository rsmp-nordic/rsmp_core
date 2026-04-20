.. _signal-exchange-list:

Signal Exchange List (SXL)
==========================
A signal exchange list (:term:`SXL`) specifies the interface for a type of equipment or area of functionality.

The interface consists of component types, and the alarm, command, and status messages
used to interact with these component types.

SXLs are machine-readable specifications, not executable artifacts.

.. _sxl-definition:

SXL Definition
--------------
An SXL is identified by its name, and is published with a version following Semantic Versioning (SemVer) rules.

It defines component types, which are logical or physical parts of a site,
and the alarm, command, and status messages used to interact with each of these component types.

It also details the meaning of aggregated status bits, functional positions and functional states.

.. _sxl-name:

SXL Name and Description
^^^^^^^^^^^^^^^^^^^^^^^^
An SXL is identified by a :term:`name`, e.g. "nordic/variable_message_sign",  "eu/traffic_light_controller"
or "nordic/traffic_light_controller/advanced".

Forward slashes can be used to organize names in a hierarchy.
Names can contain only lowercase letters, digits, hyphens, underscores and forward slashes.

To enhance visibility and interoperability, RSMP Nordic maintains a global registry of unique SXL names.
To register an SXL, the name must be unique and must include a top-level region in the form "<region>/...".

Unregistered SXLs can be used, but are not guaranteed to be unique and could therefore cause name clashes
if used together with other SXLs. We therefore recommend registering SXLs that are intended for public use.

An SXL also has a :term:`description`, which is a short human-readable text e.g. "Nordic Traffic Light Controller".


.. code-block:: yaml

  meta:
    name: nordic/tlc
    description: Nordic Traffic Light Controller Interface

.. _sxl-version:

SXL Version
^^^^^^^^^^^
An SXL has a version, e.g. "1.3.1", which must follow Semantic Versioning conventions.

Given a version number MAJOR.MINOR.PATCH, you must increment the:

MAJOR version when you make incompatible API changes
MINOR version when you add functionality in a backward compatible manner
PATCH version when you make backward compatible bug fixes


.. code-block:: yaml

  meta:
    version: 1.3.1

SXL versions are used to determine whether a site and the supervisor has compatible versions.

.. _sxl-prefix:

SXL Prefix
^^^^^^^^^^
An SXL can optionally define a prefix which will be prepended to all component types and message codes
in the SXL, e.g. "tlc/" for a traffic light controller SXL.

A prefix can contain lowercase letters, digits, hyphens and underscores, and must end with a forward slash.

If you intend to define everything under the same scope, e.g. "nordic/", it's recommended to use a prefix.
It guarantees that everything in SXL will be scoped under the same prefix and avoids having to repeat the same prefix
everywhere.

Using a prefix has no functional difference from manually including the same prefix in all component types and message codes definitions.
When using the SXL you must still refer to component types and message code ids using their full paths including the prefix.

For example, this SXL defines everything by manually using "tlc/" as a prefix everywhere:

.. code-block:: yaml

  types:
    tlc/plan:
      description: Signal Plan
  commands:
    tlc/plan/set:
      description: Set signal plan
  statuses:
    tlc/plan/current:
      description: Get the current signal plan
  alarms:
    tlc/deadlock:
      description: Signal plan causes deadlock

Using a prefix, the same SXL can be defined like this:

.. code-block:: yaml

  prefix: tlc/
  types:
    plan:
      description: Signal Plan
  commands:
    plan/set:
      description: Set signal plan
  statuses:
    plan/current:
      description: Get the current signal plan
  alarms:
    deadlock:
      description: Signal plan causes deadlock

The result is the same, you still need to use the full paths, e.g. "tlc/plan/set" when changing the signal plan,
or "tlc/deadlock" when sending a deadlock alarm.


A prefix does not have to mirror the SXL name and should be short.

For example, a traffic light controller SXL like "nordic/traffic_light_controller" could use the prefix "tlc/".

Two different SXLs can use the same prefix, as long as they are not intended to be used together on the same site.
This flexibility enables use cases like:

 - replacement: a new SXL that is compatible with an existing SXL, and can be used as a drop-in replacement.


.. _sxl-component-types:

SXL Component Types
^^^^^^^^^^^^^^^^^^^
An SXL defines the available :term:`component types<type>`. Components are the logical or physical part of a site.

Only lowercase letters, digits, hyphens, underscores and forward slashes are allowed in component types.
Component type must be unique within the SXL. 

Component types can be organized into a hierarchy using forward slashes.

.. code-block:: yaml

  types:
    tlc/sg:
      description: Signal group
    tlc/dl:
      description: Detector logic

Each type must have a short description.

.. _sxl-message-codes:

SXL Message Codes
^^^^^^^^^^^^^^^^^
An SXL can define alarms, commands and statuses, each identified by a :term:`message code`.

Only lowercase letters, digits, hyphens, underscores and forward slashes are allowed.
Codes must be unique within the SXL.

Message codes can be organized into a hierarchy using forward slashes.

.. code-block:: yaml

  commands:
    tlc/plan/set:
      description: Set signal plan
  statuses:
    tlc/plan/current:
      description: Get the current signal plan
  alarms:
    tlc/deadlock:
      description: Signal plan causes deadlock

Here we define the command code ``tlc/plan/set``, the status code ``tlc/plan/current`` and the alarm code ``tlc/deadlock``.

Note that real definitions of commands, statuses and alarms include additional elements, which are omitted here for clarity, see below.

.. _sxl-aggregated-status:

Aggregated Status
^^^^^^^^^^^^^^^^
The basic meaning of the eight aggregated status bits is defined in the core specification and cannot be redefined,
see :ref:`state-bits`.

But the SXL can detail the meaning of each bit as they relate to the specific type of equipment.
If you leave a bit out, the default core definition applies.

.. code-block:: yaml

  aggregated_status:
    local:
      description: Traffic controller is in local mode, overriding supervisor control.
    offline:
      description: Traffic controller has network connection, but communication with the supervisor was lost
    fault:
      description: High priority fault, traffic controller is in fail safe mode
    error:
      description: Medium priority fault, but traffic controller is not in fail safe mode
    warning:
      description: Low Priority Fault
    normal:
      description: Traffic controller is operating normally
    idle:
      description: Traffic controller is idle
    disconnected:
      title: Traffic controller has no network connection

The following bits can be detailed:

- ``local`` (bit 1)
- ``offline`` (bit 2)
- ``fault`` (bit 3)
- ``error`` (bit 4)
- ``warning`` (bit 5)
- ``normal`` (bit 6)
- ``idle`` (bit 7)
- ``disconnected`` (bit 8)

.. _sxl-functional-modes:

Functional Modes
^^^^^^^^^^^^^^^^
Defines the distinct functional modes that the site can be in. Only one of these can be active at the same time.

.. code-block:: yaml

  functional_modes:
    normal: Controller is operating normally
    dark: Controller is in dark mode
    yellow_flash: Controller is in yellow flash mode

.. _sxl-alarms:

Alarms
^^^^^^
Alarms are used to report errors and other events that require attention. They are identified by their :term:`alarm code id`, which is unique within the SXL.
Alarms can be associated with a component type, but this is not required. If no component type is associated, the alarm relates to the site as a whole.

.. code-block:: yaml

  alarms:
    A0201:
      description: Serious lamp error
      component: tlc/sg
      priority: 2
      category: D
      externalAlarmCodeId: LA000445/11 [R,Y]
      arguments:
        color:
          type: array
          enum: [red, yellow]
          description: Lamp colors affected

.. tabularcolumns:: |\Yl{0.30}|\Yl{0.15}|\Yl{0.55}|

.. table:: Alarm fields

   ===========================  =======  ====================================
   Field                        Type     Description
   ===========================  =======  ====================================
   ``description``              string   Alarm description
   ``category``                 string   Alarm category, can be either "T" for traffic alarm or "D" for technical alarm
   ``priority``                 integer  Alarm priority, can be ``1``, ``2`` or ``3``.
   ``externalAlarmCodeId``      string   :term:`External alarm code id`
   ``externalNtsAlarmCodeId``   string   :term:`External NTS alarm code id` (optional)
   ``arguments``                hash     Alarm return values (optional)
   ===========================  =======  ====================================

.. _alarm-category:

Alarm priority
^^^^^^^^^^^^^^

A **traffic alarm** indicates events in the traffic related functions or the
technical processes that affects traffic.

A couple of examples from a tunnel:

- Stopped vehicle
- Fire alarm
- Error which affects message to motorists
- High level of :math:`CO_{2}` in traffic room

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

.. _sxl-statuses:

Statuses
^^^^^^^^
Statuses are used to report the current state of a component or the site as a whole. They are identified by their :term:`status code id`, which is unique within the SXL.

A status can be associated with a component type, but this is not required. If no component type is associated, the status relates to the site as a whole.

.. code-block:: yaml

  statuses:
    tlc/glosa:
      description: Time-to-green prediction for signal group
      component: tlc/sg
      arguments:
        :
          type: string
          description: S0001 argument 1

Each status contains the following fields:

.. tabularcolumns:: |\Yl{0.20}|\Yl{0.15}|\Yl{0.65}|

.. table:: Status fields

   ===============  =======  ==========================================
   Field            Type     Description
   ===============  =======  ==========================================
   ``description``  string   Status description
   ``component``    string   Component type (optional)
   ``arguments``    hash     Value arguments
   ===============  =======  ==========================================

Each status argument contains the following fields:

.. tabularcolumns:: |\Yl{0.20}|\Yl{0.15}|\Yl{0.65}|

.. table:: Status argument fields

   ===============  =======  =======================================================
   Field            Type     Description
   ===============  =======  =======================================================
   ``description``  string   Argument description
   ``type``         string   :ref:`Data type<data_types>`
   ``min``          number   Minimum value (only for *number* or *integer* data types)
   ``max``          number   Maximum value (only for *number* or *integer* data types)
   ===============  =======  =======================================================


.. _sxl-commands:

Commands
^^^^^^^^
Commands are used to control the site and its components. They are identified by their :term:`command code id`, which is unique within the SXL.

A command can be associated with a component type, but this is not required. If no component type is associated, the command relates to the site as a whole.

.. code-block:: yaml

  commands:
    M0001:
      description: command description text
      command: setStatus
      arguments:
        <argument-1>:
          type: boolean
          description: M0001 argument 1

Each command contains the following fields:

.. tabularcolumns:: |\Yl{0.20}|\Yl{0.15}|\Yl{0.65}|

.. table:: Command fields

   ===============  =======  ==========================================
   Field            Type     Description
   ===============  =======  ==========================================
   ``description``  string   Command description
   ``command``      string   Optional RPC (Remote Procedure Call) name
   ``arguments``    hash     Command arguments
   ===============  =======  ==========================================

Each command argument contains the following fields:

.. tabularcolumns:: |\Yl{0.20}|\Yl{0.15}|\Yl{0.65}|

.. table:: Command argument fields

   ===============  =======  =======================================================
   Field            Type     Description
   ===============  =======  =======================================================
   ``description``  string   Argument description
   ``type``         string   :ref:`Data type<data_types>`
   ``min``          number   Minimum value (only for *number* or *integer* data types)
   ``max``          number   Maximum value (only for *number* or *integer* data types)
   ===============  =======  =======================================================

