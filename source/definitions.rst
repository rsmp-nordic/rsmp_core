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

       A component is identified using component id.

   Component id
       Identity of a :term:`component`

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
      National Traffic management system at the :term:`STA`.

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

       At the STA, the following formats can be used:

       - The site id from the STAs component id standard TDOK 2012:1171
         e.g. ”40100”

       - It is also possible to use the full component id (TDOK 2012:1171)
         of the grouped object in the site in case the site id part of
         the component id is insufficient in order to uniquely identify a
         site.

   STA
       Swedish Transport Administration

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

