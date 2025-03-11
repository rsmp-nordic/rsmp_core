.. _definitions:

Definitions
===========

.. glossary::

   Alarm code id
       Identity of an alarm

       The examples in this document are defined according to the following
       format: *Ayyyy*, where *yyyy* is a unique number.

   Command code id
       Identity of a command

       The examples in this document are defined according to the following
       format: *Myyyy* where *yyyy* is a unique number.

   External alarm code id
       Manufacturer specific alarm code and alarm description.
       Includes manufacturer, model, internal alarm code och additional
       alarm description.

   External NTS alarm code id
       Alarm code in order to identify alarm type during communication with NTS

   Aggregated object
       An aggregated object consists of one or many other objects.
       E.g. Component group (CG)

   Component
       A component is an :term:`object` or :term:`NTS object`.
       A component is identified using a component id.

   Component id
       Used to identify a :term:`component`.
       A component id is a string in format A or B:.
       
   Component id, format A
       This is the original component format.
       It includes the site id as part of the component id
       
       Structure:
       AA+BBCDD=EEEFFGGG

       Examples:
       KK+AG0503=001DL001
       KK+AG0503=001SG005

       Details:
       AA+BBCDD is the site id.
       FF identifies the type of component.
       GGG is the component index.

   Component id, format B
       A newer component id format that can be used to organize components in a 
       hierachical structure.
       The site id is not included as part of the component id.

       Structure:
       /.../...

       Examples:
       /tc
       /sg/1
       /in/1/sg/6
       /dl/radar/1
       /dl/radar/2

       Details:
       The format starts with a forward slash "/", and consist of
       levels seperated by forward slashes. It cannot end end with a slash.

       The component id does not have to indicate the component type, although
       this is often useful.

       You can point to intermediate levels in the hierarchy to reference 
       groups of components.

       A single forward slash "/" refers to all components.
       An empty string "" or null refers to the main component (see below for details).

   Component indexes
       Each component must have an integer index that's unique on the site.

       For example, a device might have these format A component id, and indexes:

       0: KK+AG0503=001DL001
       1: KK+AG0503=001DL002
       2: KK+AG0503=001SG001
       3: KK+AG0503=001SG002

       Or using format B component ids:

       0: /dl/north 
       1: /dl/south
       2: /sg/1
       3: /sg/2

       Even though component ids might include integer parts
       (e.g. '001' in KK+AG0503=001DL001 or '/1' in sg/1) you cannot expect these
       to match the indexes, since components of different types might use the same
       integer parts, while indexes must be unqiue on the site across types.

       Component indexes provides a clear way to order subset of components
       and refer to each using a short index starting from 0.

       For example, consider a status message that provides the status of all signal
       groups:

       2: /sg/1
       3: /sg/2

       Because it's subset of components, indexes might not start from 0 and might contain
       gaps, but can easily be normalized by simply counting from 0:           

       0: /sg/1
       1: /sg/2

       Normalized indexes can be used to efficiently send data,
       by using a  structure where the first element refers to the component with
       normalized index 0, element 1 refers to the component with normalized index 1, etc.

       For example, let's assume the status string "AB" is sent to indicate the status
       of all signal groups.
       
       The character at index 0 in the string is A.
       The component with normalized index 0 is /sg/1, and thus has status A.
       
       The character at index 1 in the status string is B.
       The component with normalized index 1 is /sg/2, and thus has status B.

       The result is:

       /sg/1: A
       /sg/2: B

    Main components
       Each site must have exactly one designated main component.
       You can of course refer to the main component using it's component id.
       Or, as a short-hand, you can use an empty string "" or null to refer to the main component.

   DATEX II
       European standard for message exchange between traffic systems
       (www.datex2.eu)

   Functional position
       Provides command options for a site. For instance, "start" or "stop"
       It is meant to be used for the entire site and not for an individual
       component. It can be implemented using a command and can be read from
       the site using the aggregated status message.

   Functional state
       Not used

   ITS site
       Road side equipment. Covers both field level and local level

   JSON
       JavaScript Object Notation

   Local road side equipment
       See :term:`ITS site`

   Maneuver
       Provides command options for one or many individual components.
       For instance, "start" or "stop". It can be implemented using a
       command and can be read from the site using a corresponding status
       message.

       Designed to be used with NTS.

   NTS
      National Traffic management system in Sweden.

   NTS object
       Used for objects in :term:`NTS`

       All control and supervision related functions in NTS consist of
       NTS objects.

       An NTS object can represent one or many objects.

   External NTS id
       Identitiy for an :term:`NTS object` used in communication between NTS and other systems

       The format is 5 integers and is unique for the site.
       It is defined in cooperation with representatives from NTS.

   NTS-Object type
       A NTS object type is a classification of NTS objects.
       Determines among other things which functional positions that
       are possible for the NTS object.

   Object
       An object is a abstract term which is used in control and
       supervision systems. An object can have one or more statuses
       that may change depending on changes of circumstance of the
       object or control of the object from external source.
       Communication with the object is made using exchange of
       signals, e.g. commands, status and alarms.

       An object can represent physical equipment or abstract concepts
       E.g. a camera, a control flow algorithm or a group of signs.

       An object is identified using :term:`component id`.
       *Please note that an object is not necessarily the same thing as an
       NTS object.*

   Object type
       An object type is a classification of objects that controls the
       properties of all the objects of the same object type. The
       object type determines how the object is presented in
       supervision system, how it is grouped and which functional
       positions, alarm codes, commands and statuses that exists for that
       object type.

   Parameter
       Used for modification of technical or autonomous traffic parameters
       of the equipment. Can be implemented using commands and statuses.

   RSMP
       Road Side Message Protocol

   RSMP Nordic
       Organization for maintaining and develop the RSMP protocol.
       Collaboration between a group of Nordic road authorities.

   Site
       See :term:`ITS site`

   Site id
       Site identity.
       Used in order to refer to a “logical” identity of a site.

   Supervision system
       Control and supervision system for regional and/or national
       level

   SXL
      Signal exchange list. Defines which messages types (signals)
      which is possible to send to a specific equipment or object.
      E.g. alarms, statuses and commands

   Status code id
      Identitiy for a status

      The examples in this document are defined according to the following
      format: *Syyyy* where *yyyy* is a unique number.

   TCP/IP
       Transfer Control Protocol/Internet Protocol

   W3C
       World Wide Web Consortium

   XML
       eXtensible Markup Language

