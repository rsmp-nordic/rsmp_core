.. _sxl-modules:

Modules
=======

This page describes a proposal for adding modular support to the SXL
(Signal Exchange List) concept. The goal is to let equipment expose and reuse
well-defined sets of object types and messages (modules) so that different
devices can implement only what is relevant for them. For example, a
traffic light may implement a traffic light controller module and optionally
a traffic sensor module, while a standalone traffic counter implements only
the traffic sensor module.

The text below is a draft and follows the existing writing style in this
repository. It is intended to be included in core 3.3.x as a first description
of the modules concept.

Overview
--------

- A module defines object/component types and the messages that target those
	types.
- A module can have submodules. A submodule extends a parent module and can
	target all component types defined in the parent module.
- A site can advertise which modules (and versions) it supports during the
	Version handshake and later via a component list request.
* Changes to modules should aim to preserve interoperability across releases.

Motivation
----------

Today there is often a single module (historically known as a signal exchange
list) for traffic lights that also contains messages used by other kinds of
equipment (for example simple traffic counters). That leads to duplicated
definitions across different modules or custom modifications. Modules let us
split functionality into reusable pieces such as "input/output",
"traffic sensor" or "variable message sign", reducing duplication and making
it easier to compose capabilities for devices.

Basic concepts
--------------

Module
^^^^^^

A module is a named collection of:

- component (object) types, for example `/tlc/tc`, `/tlc/sg` for the traffic
	light controller module
- message definitions and the allowed target component types for each
	message

Module names should be stable and include a short id, for example ``tlc`` for
traffic light controller or ``vms`` for variable message sign. Component types
defined in a module should include the module id as a prefix when used in
component type names (``/vms/lamp``, ``/tlc/lamp``) to avoid ambiguity when
multiple modules define similarly named types.

Submodules
^^^^^^^^^^

A submodule extends a parent module and can rely on types defined by the
parent. This is useful when splitting a large module into smaller topics while
targeting the same component types. For example::

	 /tlc            -> defines types tc, dl, sg
	 /tlc/mode
	 /tlc/schedule
	 /tlc/programs
	 /tlc/prediction

Dependencies and targeting
^^^^^^^^^^^^^^^^^^^^^^^^^^

If a module A depends on module B, messages in A may target component types
defined in B. A wildcard target (for example "any") may be useful for
generic modules that operate on arbitrary component types.

Handshake and version messages
------------------------------

During the RSMP Version handshake the site must list the modules it
implements along with versions. From core 3.3.0 the Version message must
include a ``modules`` array describing implemented modules and versions.
Because the RSMP core version is not negotiated before the Version message
is exchanged, the Version message must also include the ``SXL`` attribute to
indicate the site SXL revision.

Example: site that supports one module

.. code-block:: json
	 :name: json-version-modules

	 {
			 "mType": "rSMsg",
			 "type": "Version",
			 "mId": "6f968141-4de5-42ff-8032-45f8093762c5",
			 "RSMP": [ { "vers": "3.1.1" }, { "vers": "3.1.2" } ],
			 "siteId": [ { "sId": "O+14439=481WA001" } ],
			 "SXL": "1.3.0",
			 "modules": [ { "id": "tlc", "version": "1.3.0" } ]
	 }

JSON code: Example Version message including a modules list.

Note: the module id is typically already present in the module source (for
example in the module's sxl.yaml), but including the list in the Version
message makes the supported modules explicit at connection time.

Component list and component types
----------------------------------

The site still sends a ComponentList message listing the components in the
site. When modules are used the component types should indicate the module
and start with a leading slash. For example ``/tlc/tc`` or ``/vms/lamp``.

All component types must start with a leading slash when modules are used.
For example ``/tlc/tc`` and ``/vms/lamp``. The leading slash makes the module
id explicit and unambiguous.

The ComponentList can be requested later by the supervisor as well.

Single-module devices
---------------------

From core 3.3.0 single-module devices must include the ``modules`` array in
the Version message and use leading-slash component types. The recommended
format for the Version message is shown in the example above.

Format A and Format B component ids
----------------------------------

When older component id formats are used (format A) the ComponentList may
contain ids using the older style, for example "KK+AG0503=001TC000". Format
A does not support addressing groups by path, while format B can reference
paths (e.g. "/sg/north/") and subpaths. Modules should support both id
formats as appropriate and define how messages target components for each
format.

Mixing modules and formats
--------------------------

Modules and format B can be used independently. A site can use neither, one
of them or both. However, when mixing modules, it should be clear which
module defines a given aggregated status bit, or which module is responsible
for sending a particular aggregated status. The SXL should document which
module(s) define aggregated status bits for the site.

Metadata and module identification
----------------------------------

Modules should provide metadata such as a stable id and a version. Component
types should be unambiguous by including the module where they are defined.
This makes it easy for supervisors to determine what each component type
means without relying on implicit conventions.

Compatibility note
------------------

This document describes the behaviour required for core 3.3.0: the Version
message must include the ``modules`` array and component types must use the
leading-slash form. Implementations targeting older core versions should be
considered separately; this document does not provide legacy compatibility
rules.

Open questions and next steps (draft)
------------------------------------

- Decide exact schema for the Version message modules list and component list
	extensions (if any).
- Define how module dependencies are expressed in the SXL source files.
- Decide rules for aggregated status ownership across modules (one per site,
	or component-based, or module-based).

References
----------

- Issue: support for SXL modules (#62) on the project repository.

.. note::
	 This is a draft. Use it as a starting point for a formal proposal and SXL
	 schema changes.

