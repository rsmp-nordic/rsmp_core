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
       
   Component id format A
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

   Component id format B
       A newer component id format that can be used to organize componets in a 
       hierachical structure, akin to a file path.
       It does not include the site id as part of the component id.

       Structure:
       /.../type/.../id

       Examples:
       /tc
       /sg/1
       /in/1/sg/6


       Details:
       The format starts with a forward slagh "/", and consist of
       levels seperated by slashes.
       The full component id points to a single component.
       But you can point to intermediate levels in the hierachy, for example 
       to reference all components of a specific type. This is akin
       to a folder path.
       You can use "/" to refer to all components

       The type of component is identified by some level before c. 
       The last part is an identifier that's unique for the type of component.

       In simple cases, a component id can consists of just the type and an id:

       /sg/1
       /dl/1
       /dl/2 
       /dl/3 
       /dl/4 

       For more complex setups, you can use intermediate levels to organize
       components, in which the type and the id might be separated 
       by intermediate levels.
       For example, detector logics can be organized into radars and video
       detectors:

       /dl/radar/1
       /dl/radar/2
       /dl/video/1
       /dl/video/2

       Components of the same type must have unique indexes. If you organize
       into subtypes and reuse ids between the subtypes, ids will not match
       indexes. This is ok, but something to keep in mind:

       /dl/radar/1 (index 1)
       /dl/radar/2 (index 2)
       /dl/video/1 (index 3)
       /dl/video/2 (index 4)

       Indexes are used to send data for all components of a specific type 
       in a compact format, which is why they must be unique per type.

       The id at the end does not have to be an integer, e.g:

       /dl/north (index 1)
       /dl/east  (index 2)
       /dl/south (index 3)
       /dl/west  (index 3)
       /sg/a1_bike (index 1)
       /sg/a1_car  (index 2)
       /sg/b1_bike (index 3)
       /sg/b2_car  (index 4)

       Regardless of ids, componenets will always have indexes.

   Component index
       Index of a :term:`component` of a specific type.
        A component index is an positive integer.
        Component indexes must be unique per site and component type.
        In other words, on a site, two components of the same type cannot have the same
        index, while components of different types can.

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

