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

  AB+84001=860DL001
  AB+84001=860DL002
  AB+84001=860SG001
  AB+84001=860SG002
  AB+84001=860TC001

.. _path-component-id:

Path IDs
^^^^^^^^
This is a newer format that uses slashes to organise components into a hierarchy.
The :term:`site id` is not included as part of the string.

Structure::

  /...

Examples::

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
A single component is addressed using its full ID, whether classic or path IDs are used.

If path IDs are used, you can use paths to address groups of components.
Paths end with a forward slash ``/`` and covers components below it in the
ID hierarchy.

For example, the path ``/dl/radar/`` might cover ``/dl/radar/1`` and ``/dl/radar/2``.

A single forward slash ``/`` indicates the root and covers all components.

If classic IDs are used, no hierarchy is defined and paths cannot be used, not even ``/``.

An empty string or null means no component and can be used as way to address
site as a whole. This is allowed for both classic and path IDs.

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
