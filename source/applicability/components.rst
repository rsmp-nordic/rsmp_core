.. _components:

Components
==========
Components represent physical or logical parts of a site.
For example, a traffic light controller might have signal group and detector logic components.

A component has:

* a type
* an id
* a name
* internal data and state

.. _component-type:

Component Type
--------------
Component types are defined by SXLs.
For example, an SXL for traffic light controllers might define the component types ``sg`` for
signal groups and ``dl`` for detector logics.

Component types are used in SXLs when defining which alarms, commands and statuses apply to which components.

Component types must be unique within the SXL where they are defined, but does not have to be globally unique.
The SXLs that define the same component type therefore canont be used together on the same site.

Component type IDs use UTF-8 and must contain only letters, digits, hyphens, underscores and forward slashes.

.. _component-id:

Component ID
------------
Component IDs are used to identify components.
The can contain only letters, digits, hyphens, plus signs, equal signs, underscores and forward slashes.

Forward slashes ``/`` can be used to organise components into a hierarchy.
The :term:`site id` should not be included as part of the ID, but is allowed to easy migration from the previous format.

Examples::

  dl/bus/b2
  dl/north/a
  dl/radar/1
  dl/radar/2
  intersection/1/sg/6
  sensors/bus/A8
  sg/1
  tc

An component ID must not start or end with a slash.
Empty levels, e.g. ``sg//1``, are not allowed.


Even though it's often natural to organize components by type, for example by placing signal groups
of a traffic light controller under the path ``sg/``, there is no requirement to include the
component type in a component ID, or include it at a specific location in the ID.

Threrefore you cannot safely infer the component type from the component ID alone.
Instead you should rely on the ComponentList message, which will explicitly list the component
types of all components, e.g. ``sg`` for signal group component.

.. _classic-component-id:

Classic IDs
^^^^^^^^^^^
An earlier format which consists of a string with a specific encoding.
The ":term:`Site id`" is included as the first part of the string, and forward slashes are not allowed.

Structure::

  AA+BBCDD=EEEFFGGG

Where:

* ``AA+BBCDD`` is the :term:`site id`, typically the geographical location
* ``EEE`` identifies the site type, e.g. traffic lights
* ``FF`` identifies the type of component, e.g. signal group
* ``GGG`` is the component index

Classic IDs use UTF-8 and can contain only letters, digits, hyphens, plus signs and equal signs.

Examples::

  AB+84001=860DL001
  AB+84001=860SG002
  AB+84001=860TC001

Note that since a messages is send to a specific site, the site id in a classic component ID is redundant
and not used for message route.


Format compatibility
^^^^^^^^^^^^^^^^^^^^
IDs in the classic format are still valid under the current format and can be used without any
changes. However, it's recommended to migrate classic IDs to the current format,
and only use the currnt formaat for new installations.

Example Migration:

.. table:: Classic to path ID migration

   +-------------------+--------+
   | Classic           | Path   |
   +===================+========+
   | AB+84001=860DL001 | dl/1   |
   +-------------------+--------+
   | AB+84001=860SG002 | sg/2   |
   +-------------------+--------+
   | AB+84001=860TC001 | tc     |
   +-------------------+--------+

.. _addressing-components:

Addressing Components
^^^^^^^^^^^^^^^^^^^^^
A single component is addressed using its full ID, e.g. ``dl/radar/1`` or ``KK+AG0503=001SG001``.

If components are organised in a hierarchy using forward slashes, you can use partial paths ending with ``/``
to reference all component under that path. For example, given the componts example above,
the path ``dl/radar/`` would reference ``dl/radar/1`` and ``dl/radar/2``.

A single forward slash ``/`` indicate the root and references all components.

An empty string or null mean no component. Depending on context this can be used
to indicate the site as a whole, as opposed to any specific compponent or group of components.

.. _component-name:

Component Name
--------------
A component can have a human-readable name, e.g. "Radar detector, northbound".
A name is recommended, but not required.

Component names use UTF-8 and can contain any printable character.
Space is the only allowed whitespace character.

.. _component-data:

Component Data and State
------------------------
A component typically has internal data and state relevant to its function.

Such data can be read and modified using Alarms, Commands and Statuses defined
in a relevant SXL.

For example, a traffic light signal group might have an internal state
signifying whether it's currently green, yellow or red. An SXL for traffic light controllers
might define a status to read the current colour of a signal group component, and maybe
commands to request that a group turns green or red.

.. _component_ordering:

Component Ordering
------------------
As part of the connection sequence, the site sends a :ref:`component-list` message which lists
all components on the site.

The site must order the components in the component list using :ref:`natural-sorting` of their component IDs.
This ensures that the list is predictable and human-readable.

However, the supervisor must always use the order of the components as received in the :ref:`component-list` message,
even if the site has failed to sort them correctly.

The component list items are indexed starting from zero and have no gaps.
When working with compact data structures, placeholders for missing components will therefore never be used.

As an example, a site might have these classic component IDs:

  0: dl/north
  1: dl/south
  2: sg/1
  3: sg/2
  4: tc

Or these classic componet ids:

  0: KK+AG0503=001DL001
  1: KK+AG0503=001DL002
  2: KK+AG0503=001SG001
  3: KK+AG0503=001SG002
  4: KK+AG0503=001TC001


The ordering can be relied on to reference many components in a compact way, by using short integer indexes,
indicating the position in the ordered list.

For example, you can send a string where each character relates to a specific component.

You can also index subsets of components, by enumerating items in the subset starting from zero,
while using the ordering of the full list. For example the subset of signal groups at ``sg/`` would have the
following indexes:

  0: sg/1
  1: sg/2

If we assume a status update with the string "AB" is sent to indicate the
state of signal groups under the path ``sg/`` then:

* The character at index 0 in the string is ``A``, thus ``sg/1`` is in state ``A``.
* The character at index 1 in the string is ``B``, thus ``sg/2`` is in state ``B``.

The ordering defined by the :ref:`component-list` is stable. It does not change
unless a new :ref:`component-list` message is received (e.g. after a reconnection).
This means the mapping between list positions and component IDs remains constant,
while the values in status messages will change over time.

You cannot safely rely on integer parts of component IDs for indexing, because they:

* might not be unique across component types
* might not be sequential
* might not start from zero
* might not be present

Instead you must rely on the ordering provided by the :ref:`component-list` message.

Ordering of Classic IDs
^^^^^^^^^^^^^^^^^^^^^^^
For sites using :ref:`classic-component-id`, the component ID includes a numeric component index
(e.g. ``001`` in ``KK+AG0503=001SG001``).
Because the :ref:`component-list` uses :ref:`natural-sorting`, the components will be ordered
explicitly according to this index.
