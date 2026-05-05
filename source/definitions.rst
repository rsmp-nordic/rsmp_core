.. _definitions:

Definitions
===========

.. glossary::

   Alarm code id
       Identity of an alarm

       The examples in this document are defined according to the following
       format: *Ayyyy*, where *yyyy* is a unique number.

   Code id
       A code id identifies alarms, commands and statuses. See :term:`Alarm code id`,
       :term:`Command code id` and :term:`Status code id`.

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
       National Traffic management system at the Swedish Transport Administration


   NTS
      National Traffic management system at the Swedish Transport Administration

   Component
       A :ref:`component <components>` represents physical or logical parts of a site,
       e.g. a camera, a control flow algorithm or a group of signs.
       
       *Please note that a component is not necessarily the same thing as an
       NTS object.*

   Component type
       A :ref:`component-type` is used to classify :ref:`components`.
       Component types are defined by SXLs.

   Component id
       A :ref:`component-id` identifies a :ref:`component <components>`.

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
      which is possible to send to a specific equipment or component.
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

