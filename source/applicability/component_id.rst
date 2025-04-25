.. _component-id:

Component ID
============
Component ID's are used to identify a :term:`component`. There are two
formats that can be used, either format A or format B.

Format A
--------
This is the original component format.
It includes the :term:`site id` as part of the component id.
       
Structure::

  AA+BBCDD=EEEFFGGG

Where:

* ``AA+BBCDD`` is the :term:`site id`, typically the geographical location
* ``EEE`` identifies the site type, e.g. traffic lights
* ``FF`` identifies the type of component, e.g. signal group
* ``GGG`` is the component index.

Examples::

  KK+AG0503=001DL001
  KK+AG0503=001SG005

Format B
--------
This is a newer component id format that can be used to organize components
in a hierachical structure. The :term:`site id` is not included as part of
the component id.

Structure::

  /.../...

Examples::

  /tc
  /sg/1
  /in/1/sg/6
  /dl/radar/1
  /dl/radar/2

The format starts with a forward slash ``/``, and consist of levels separated
by forward slashes.
       
A component id cannot end with a slash. However, you can point to
intermediate levels in the hierarchy to reference groups of components,
by using a component string ending with a slash, e.g. ``/sg/`` to refer to
all signal groups.

The component id does not have to indicate the component type, although this
is often useful.

A single forward slash ``/`` refers to all components.
       
An empty string ``""`` or ``null`` refers to the `main component`_.

The concrete layout of component types and paths is defined in the SXL.

Component indexes
-----------------

Each component must have an integer index that's unique on the site.

For example, a device might have these format A component id, and indexes::

  0: KK+AG0503=001DL001
  1: KK+AG0503=001DL002
  2: KK+AG0503=001SG001
  3: KK+AG0503=001SG002

Or using format B component ids::

  0: /dl/north
  1: /dl/south
  2: /sg/1
  3: /sg/2

Even though component ids might include integer parts
(e.g. ``001`` in ``KK+AG0503=001DL001`` or ``/1`` in ``sg/1``) you cannot
expect these to match the indexes, since components of different types might
use the same integer parts, while indexes must be unique on the site across
types.

Component indexes provides a clear way to order subset of components and
refer to each using a short index starting from 0.

For example, consider a status message that provides the status of all signal
groups::

  2: /sg/1
  3: /sg/2

Because it's subset of components, indexes might not start from 0 and might contain
gaps, but can easily be normalized by simply counting from 0::

  0: /sg/1
  1: /sg/2

Normalized indexes can be used to efficiently send data,
by using a compact structure where the first element refers to the component
with normalized index 0, the second element refers to the component with
normalized index 1, etc.

For example, let's assume the status string "AB" is sent to indicate the status
of all signal groups.

The character at index 0 in the string is A.
The component with normalized index 0 is ``/sg/1``, and thus has status A.

The character at index 1 in the status string is B.
The component with normalized index 1 is ``/sg/2``, and thus has status B.

The result is::

  /sg/1: A
  /sg/2: B
 

Main component
^^^^^^^^^^^^^^

Each site must have exactly one designated main component.
You can of course refer to the main component using it's component id.
Or, as a short-hand, you can use an empty string ``""`` or ``null`` to refer
to the main component.

