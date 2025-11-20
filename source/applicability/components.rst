.. _components:

Components
==========
Physical or logical parts of a site are called **components**.
For example, a traffic light controller might have signal group and detector logic components.

A component has:

* a type
* an id
* a name
* internal data and state

.. _component-type:

Component Type
--------------
Component types are defined by SXLs and identified by an ID.
For example, an SXL for traffic light controllers might define ``sg`` for signal groups and ``dl`` for detector logic.

Component type IDs use UTF-8 and must only contain letters, digits, hyphens, underscores and forward slashes.

Component type IDs do not have to be globally unique; they must be unique within the SXL where they are defined.
When referring to a component type, the type should be qualified with the SXL id, e.g. ``/tlc/sg``.

.. _component-id:

Component ID
------------
Component IDs are used to identify components.

There are two formats. All component IDs on a site must use the same format; a site cannot use both formats.

A component ID does not have to indicate the component type, although this is often useful.
This means that you cannot safely infer the component type from a path ID.

.. _legacy-component-id:

Legacy IDs
^^^^^^^^^^
This is a legacy format consisting of a string with a specific encoding.
The ":term:`Site id`" is included as the first part of the string.
Slashes are not allowed.
       
Structure::

  AA+BBCDD=EEEFFGGG

Where:

* ``AA+BBCDD`` is the :term:`site id`, typically the geographical location
* ``EEE`` identifies the site type, e.g. traffic lights
* ``FF`` identifies the type of component, e.g. signal group
* ``GGG`` is the component index

Legacy IDs use UTF-8 and can contain only letters, digits, hyphens, plus signs and equal signs.

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
  
Path IDs use UTF-8 and can contain only letters, digits, hyphens, plus signs,
equal signs and forward slashes.

A path ID must start with a forward slash ``/``. Additional slashes separate levels.
Empty levels, e.g. ``/sg//1``, are not allowed. An ID must not end with a slash.

.. _addressing-components:

Addressing Components
^^^^^^^^^^^^^^^^^^^^^
A specific component is addressed using its full id, whether it's a legacy ID or a path ID.

If path IDs are used, you can address groups of components using paths ending with a slash.

For example, ``/dl/radar/`` can be used to address all components under that path (for example
``/dl/radar/1`` and ``/dl/radar/2``).

A single forward slash ``/`` is the root of the site and includes all components.

If path IDs are used, all paths used to address components must start with a slash.
Relative paths not starting with a slash are not allowed.

If legacy IDs are used, no hierarchy is defined and paths cannot be used to address groups
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
