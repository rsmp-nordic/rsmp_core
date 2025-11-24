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
You therefore refer to a component type using ``/<sxl>/<component type>``, for example ``/tlc/sg`` refers to
the signal group component type ``sg`` defined in the SXL ``tlc``.

Component type IDs use UTF-8 and must contain only letters, digits, hyphens, underscores and forward slashes.

.. _component-id:

Component ID
------------
Component IDs are used to identify components.

There are two formats for component IDs, described below.
All component IDs on a site must use the same format; a site cannot use both formats.

A component ID does not have to indicate the component type, although this is often useful.
You cannot safely infer the component type from a path ID.

.. _classic-component-id:

Classic IDs
^^^^^^^^^^^
This format consists of a string with a specific encoding.
The ":term:`Site id`" is included as the first part of the string.
Slashes are not allowed.
       
Structure::

  AA+BBCDD=EEEFFGGG

Where:

* ``AA+BBCDD`` is the :term:`site id`, typically the geographical location
* ``EEE`` identifies the site type, e.g. traffic lights
* ``FF`` identifies the type of component, e.g. signal group
* ``GGG`` is the component index

Classic IDs use UTF-8 and can contain only letters, digits, hyphens, plus signs and equal signs.

Examples::

  KK+AG0503=00DL001
  KK+AG0503=00DL002
  KK+AG0503=00SG001
  KK+AG0503=00SG002
  KK+AG0503=00TC001

.. _path-component-id:

Path IDs
^^^^^^^^
This is a newer format that uses slashes to organise components into a hierarchy.
The :term:`site id` is not included as part of the string.

Structure::

  /...

Examples::

  /
  /dl/bus/b2
  /dl/north/a
  /dl/radar/1
  /dl/radar/2
  /intersection/1/sg/6
  /sensors/bus/A8
  /sg/1
  /tc
  
A path ID must start with a forward slash ``/``. Additional slashes separate levels.
Empty levels, e.g. ``/sg//1``, are not allowed. An ID must not end with a slash.

Path IDs use UTF-8 and can contain only letters, digits, hyphens, plus signs,
equal signs and forward slashes.

.. _addressing-components:

Addressing Components
^^^^^^^^^^^^^^^^^^^^^
A specific component is addressed using its full id, whether it's a classic ID or a path ID.

If path IDs are used, you can address groups of components using paths ending with a slash.

For example, ``/dl/radar/`` can be used to address all components under that path (for example
``/dl/radar/1`` and ``/dl/radar/2``).

A single forward slash ``/`` is the root of the site and includes all components.

If path IDs are used, all paths used to address components must start with a slash.
Relative paths not starting with a slash are not allowed.

If Classic IDs are used, no hierarchy is defined and paths cannot be used to address groups
of components.

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

The site must order the components in the list using :ref:`natural-sorting` of their component IDs.
This ensures that the list is predictable and human-readable.

However, the supervisor must always use the order of the components as received in the :ref:`component-list` message,
even if the site has failed to sort them correctly.

For example, a site might have these legacy component IDs:

  KK+AG0503=001DL001
  KK+AG0503=001DL002
  KK+AG0503=001SG001
  KK+AG0503=001SG002
  KK+AG0503=001TC001

Or these path IDs:

  /dl/north
  /dl/south
  /sg/1
  /sg/2
  /tc

The ordering can be relied to reference many components in a compact way, by using short integer indexes,
indicating the position in the ordered list.

  0: /dl/north
  1: /dl/south
  2: /sg/1
  3: /sg/2
  4: /tc

For example, you can send a string where each character relates to a specific component.

You can also use the ordering for subsets of components, by enumerating the subset starting from zero,
using the same ordering as in the full component list. For example the subset of signal groups at
``/sg/`` would have the following indexes:

  0: /sg/1
  1: /sg/2

If we assume a status update with the string "AB" is sent to indicate the
state of signal groups under the path ``/sg/`` then:

* The character at index 0 in the string is ``A``, thus ``/sg/1`` is in state ``A``.
* The character at index 1 in the string is ``B``, thus ``/sg/2`` is in state ``B``.

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

The component list items are indexed starting from zero and have no gaps.
When working with compact data structures, placeholders for missing components will therefore never be used.
