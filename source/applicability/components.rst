.. _components:
Components
==========
A site consists of components, which are physical or logical parts of the site.
For example, a traffic light controller might have signal group and detector logic components.

A component has:

* a type, defined in an SXL.
* an id, which must be unique on the site
* a name, which should be human-readable and unique on the site
* internal data, which can be accessed using alarm, command and status messages


.. _component-type:
Component Types
---------------
Component types are defined by SXLs and identified by an ID, see :ref:`component-types`.
For example, an SXL for Traffic Light Controllers might define ``sg`` for signal groups and ``dl`` for detector logics.

Component type IDs do not have to be globally unique, only unique within the SXL where they are defined.
When referring to a component type, the type must therefore be qualified with the SXL id, e.g. ``/tlc/sg``.

SXLs can be organized in a hierarchy. For example, the SXL ``/tlc/cits`` might define cooperative ITS functionality
for traffic light controllers and might define the component type ``map``. You would refer to this component type
as ``/tlc/cits/map``.


.. _component-id:
Component IDs
-------------
Component IDs are used to identify components. There are two formats that can be used: flat IDs and path IDs.
All component IDs on a site must use the same format.

.. _flat-component-id:
Flat IDs
^^^^^^^^
This is the original format and does not use slashes.
It includes the :term:`site id` as part of the id.
       
Structure::

  AA+BBCDD=EEEFFGGG

Where:

* ``AA+BBCDD`` is the :term:`site id`, typically the geographical location
* ``EEE`` identifies the site type, e.g. traffic lights
* ``FF`` identifies the type of component, e.g. signal group
* ``GGG`` is the component index.

Examples::

  KK+AG0503=00DL001
  KK+AG0503=00DL002
  KK+AG0503=00SG001
  KK+AG0503=00SG002
  KK+AG0503=00TC001


.. _path-component-id:
Path IDs
^^^^^^^^
This is a newer format that uses slashes to organize components into a hierarchy.
The :term:`site id` is not included as part of the id.

Structure::

  /...

Examples::

  /dl/bus/b2
  /dl/north/a
  /dl/radar/1
  /dl/radar/2
  /in/1/sg/6
  /sg/1
  /tc

A path ID must start with a forward slash ``/``. Additional slashes separate levels.

Empty levels, e.g. ``/sg//1``, are not allowed. The id must not end with a slash.

The ID does not have to indicate the component type, although this is often useful.
This means that you cannot safely infer the component type from a path ID.
Instead you should rely on the types sent in ComponentList messages.


.. _main_component:
Main component
--------------
A site must have exactly one component designated as the *main component*.
The main component is typically used for functionality that represents the site as a whole.

As a short-hand, this component can be addressed using an empty string ``""``.
You can also address it using its full component ID.


.. _addressing-components:
Addressing Components
---------------------
A component is addressed using its full id, whether it's a flat ID or a path ID.

As a short-hand, an empty string ``""`` can be used to refer to the :ref:`main component`.

If path ids are used, you can address groups of components using paths ending with a slash.

For example ``/dl/radar/`` can be used to address all components under that path.
For the example above, this would include ``/dl/radar/1`` and ``/dl/radar/2``.

A single forward slash ``/`` addresses all components.
       
If flat IDs are used, no hierarchy is defined and groups of components cannot be
addressed by path.

Because some messages can relate to multiple components, it's best to think of messages
being sent to or from the site, with arguments indicating which component(s) the
message relates to.

For example, a Traffic Sensor might have components relating to detection zones. You might
be able to request the status of a single zone using e.g. ``/zones/1``, or
all zones using ``/zones/``. In either case the status request is sent to the site.


.. _component_ordering:
Component Ordering
------------------
As part of the connection sequence, the site sends a :ref:`component-list` message which lists
all components on the site, ordered by their component IDs.

For example, a site might have these flat component IDs:

  KK+AG0503=001DL001
  KK+AG0503=001DL002
  KK+AG0503=001SG001
  KK+AG0503=001SG002
  KK+AG0503=001TC001

Or these path ids:

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

You cannot safely rely on integer parts of component IDs for indexing, because they:
* might not be unique across component types
* might not be sequential
* might not start from zero
* might not be present

Instead you must rely on the ordering provided by the :ref:`component-list` message.

