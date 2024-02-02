.. _definitions:

Definitions
===========

.. glossary::

   Aggregated object
       An aggregated object consists of one or many other objects.
       E.g. Component group (CG)

   Component
       A component is an object or NTS object.

       A component is identified using component-id.

   Component-ID
       A component-id identifies components.

       The format used for the STA’s sites is specified in the STA
       publication TDOK 2012:1171, e.g. AA+BBCDD=EEEFFGGG.

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

   Maximo
      STA’s support system for maintenance

   NTS
      National Traffic management system at the STA.

   NTS Object
       Used for objects in NTS

       All control and supervision related functions in NTS consist of
       NTS objects.

       An NTS object can represent one or many objects.

       An NTS objects is identified in the communication interface
       using “externalNtsId”. NTS can not use the format used in
       component-id.

       An object and NTS object and use the same component-id.

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

       An object is identified using the objects component id. *Please
       note that an object is not necessarily the same thing as an NTS
       object.*

   Object type
       An object type is a classification of objects that controls the
       properties of all the objects of the same object type. The
       object type determines how the object is presented in
       supervision system, how it is grouped and which functional
       positions, alarm codes, commands and statuses that exists that
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

   STA
       Swedish Transport Administration

   Supervision system
       Control and supervision system for regional and/or national
       level

   SXL
      Signal exchange list. Defines which messages types (signals)
      which is possible to send to a specific equipment or object.
      E.g. alarms, statuses and commands

   TCP/IP
       Transfer Control Protocol/Internet Protocol

   W3C
       World Wide Web Consortium

   XML
       eXtensible Markup Language

