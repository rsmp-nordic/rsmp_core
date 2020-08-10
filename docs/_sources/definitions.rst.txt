.. _definitions:

Definitions
===========

.. glossary::

   SXL
      Signal exchange list. Defines which messages types (signals)
      which is possible to send to a specific equipment or object.
      E.g. alarms, statuses and commands

   NTS
      National Traffic management system. Replaces CTS

   Maximo
      STA’s support system for maintenance

   ITS site
      Road side equipment. Covers both field level and local level

   Site
       See ITS site

   Local road side equipment
       See ITS site

   Supervision system
       Control and supervision system for regional and/or national
       level

   Object
       An object is a abstract term which is used in control and
       supervision systems. An object can have on or more statuses
       that may change depending on changes of circumstance of the
       object or control of the object from external source.
       Communication with the object is made using exchange of
       signals, e.g. commands, status and alarms.

       An object can represent physical equipment or abstract concepts
       E.g. a camera, a control flow alorithm or a group of signs.

       An object is identified using the objects component id. *Please
       note that an object is not necessarily the same thing as an NTS
       object.*

   Aggregated object
       An aggregated object consists of one or many other objects.
       E.g. Component group (CG)

   Object type
       An object type is a classification of objects that controls the
       properties of all the objects of the same object type. The
       object type determines how the object is presented in
       supervision system, how it is grouped and which functional
       positions, alarm codes, commands and statuses that exists that
       object type.

   NTS Object
       Used for objects in NTS

       All control and supervision related functions in NTS consist of
       NTS objects.

       An NTS object can represent on or many objects.

       An NTS objects is identified in the communication interface
       using “externalNtsId”. NTS can not use the format used in
       component-id.

       An object and NTS object and use the same component-id.

   NTS-Object type
       A NTS object type is a classification of NTS objects.
       Determines among other things which functional positions that
       are possible for the NTS object.

   Component
       A component is a object or NTS object.

       A component is identified using component-id.

   Component-ID
       A component-id identifies components.

       The format used for the STA’s sites is specified in the STA
       publication TDOK 2012:1171, e.g. AA+BBCDD=EEEFFGGG.

   XML
       eXtensible Markup Language

   JSON
       JavaScript Object Notation

   TCP/IP
       Transfer Control Protocol/Internet Protocol

   W3C
       World Wide Web Consortium

   DATEX II
       European standard for message exchange between traffic systems
       (www.datex2.eu)

   RSMP
       Road Side Message Protocol

   STA
       Swedish Transport Administration

   RSMP Nordic
       Organization for maintaining and develop the RSMP protocol.
       Collaboration between the Swedish Transport Administration,
       Vejdirektoratet, Stockholms Stad and Københavns Kommune
