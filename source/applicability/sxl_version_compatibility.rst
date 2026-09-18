.. _sxl-version-compatibility:

SXL Version Compatibility
=========================

Intention
---------

SXL version compatibility allows a site and a supervisor to upgrade
independently while continuing to use the functionality shared by their SXL
versions. It avoids requiring simultaneous upgrades for every backward
compatible SXL change.

Compatibility does not make functionality added in a newer version available
to a party using an older version. If all functionality is required, the
parties must use versions which provide that functionality.

The rules in this section apply equally to communication between sites. In
that case, *site* means the follower site and *supervisor* means the leader
site.

Overview
--------

Compatibility relies on two requirements: SXL releases must preserve both
structure and behavior according to Semantic Versioning, and communicating
parties must use the exact peer versions exchanged during negotiation when
deciding which functionality can be used. Additional informational data can
sometimes be ignored. Requests and actions should only use functionality the
receiver supports; otherwise, the receiver rejects them as specified below.

An SXL version follows `Semantic Versioning 2.0.0 <https://semver.org/spec/v2.0.0.html>`_
and consists of
``MAJOR.MINOR.PATCH``. SXL versions with the same non-zero major version are
compatible. Their minor and patch versions do not need to match. Versions with
different major versions are incompatible.

Prerelease and build information are not allowed in SXL version strings.

Semantic Versioning does not guarantee compatibility for major version zero.
For RSMP SXL negotiation, ``0.y.z`` versions are therefore considered
compatible only when all three version numbers match.

.. list-table:: SXL version compatibility examples
   :header-rows: 1

   * - Site version
     - Supervisor version
     - Compatible
   * - 1.3.0
     - 1.3.4
     - Yes; only the patch versions differ.
   * - 1.3.0
     - 1.4.0
     - Yes; only the minor versions differ.
   * - 1.3.0
     - 2.0.0
     - No; the major versions differ.
   * - 0.3.0
     - 0.3.1
     - No; major version zero requires an exact match.

For a compatible pair, the *lower version* and *higher version* are determined
using Semantic Versioning precedence. The *shared API* is the API of the lower
minor version. Patch releases have the same API.

SXL public API
--------------

Semantic Versioning applies to the complete public API of an SXL, including
both message structure and behavior.

Structural API
^^^^^^^^^^^^^^

The structural API includes:

* the SXL name and prefix
* component types
* alarm, status and command code ids and the component types to which they
  apply
* argument and return value names and the code id to which each belongs
* data types, units, allowed values and constraints
* whether an argument is required or optional
* command operation identifiers and the command to which each belongs
* alarm categories and priorities
* functional positions, functional states and aggregated status definitions
* dependencies on other SXLs

Behavioral API
^^^^^^^^^^^^^^

The behavioral API is every externally observable requirement defined by the
SXL. This includes:

* when and why a status value changes
* when status updates are triggered
* when an alarm becomes active or inactive
* the conditions for acknowledging, suspending and resuming an alarm
* the preconditions, effects and side effects of a command
* command completion, failure and return value semantics
* default behavior when an optional argument is omitted
* state transitions, ordering and timing requirements
* how alarms and equipment state affect aggregated status
* error behavior defined by the SXL

Descriptions which define these behaviors are normative parts of the API. SXL
authors must define behavior precisely enough to determine whether a later
change is backward compatible.

Versioning requirements
-----------------------

Patch versions
^^^^^^^^^^^^^^

A patch release must not change the structural or behavioral API. It can fix
spelling, examples, metadata or non-normative documentation without changing
the behavior required by the published SXL. An implementation can also be
fixed to conform to the behavior already required by the SXL.

If correcting an SXL changes a normative requirement or externally observable
behavior, the change is not a patch change. It requires a minor or major
version according to its compatibility impact.

Minor versions
^^^^^^^^^^^^^^

A minor release can add functionality, but must preserve the complete shared
API. For the same inputs and relevant state, use of the shared API must have
the same externally observable behavior in both versions.

A minor release can:

* add a component type
* add an alarm, status or command code id
* add an alarm, status or command return value
* add an optional argument to an existing command
* deprecate an existing API element without removing or changing it
* add behavior which is only observable through a new API element

The SXL must identify the version in which each new API element is introduced.
This includes an argument or return value added to an existing alarm, status
or command code id, and applying an existing code id to an additional
component type. An implementation must retain enough of this version
information to determine the shared API for every lower minor version with
which it communicates.

An argument added to an existing command must be optional. Omitting it must
produce the behavior defined before the argument was added. The new argument
must not be required to preserve existing safety or operational behavior.

A minor release must not:

* remove, rename or repurpose an existing API element
* change a data type, unit, allowed value set or constraint
* make an optional argument required or change an existing default
* change the meaning or update behavior of an existing status
* change the trigger, clearing condition, category or priority of an existing
  alarm
* change the preconditions, effects, side effects, completion or failure
  behavior of an existing command
* change an existing functional position, functional state or aggregated
  status meaning
* make existing behavior depend on a newly added component, message or
  attribute

Any change prohibited in a minor release requires a new major version.

Major versions
^^^^^^^^^^^^^^

A major version is required for any backward incompatible structural or
behavioral change. Different major versions cannot be accepted as compatible
during Version negotiation. Migration therefore requires the parties to be
configured to advertise compatible major versions or to be upgraded together.

Dependencies
^^^^^^^^^^^^

Changes to SXL dependencies follow the same rules. A dependency can be added
or updated in a minor release only if the resulting structural and behavioral
API remains backward compatible. Dependency changes which alter the existing
API or its behavior require a new major version.

Compatibility is negotiated separately for every SXL listed in the Version
messages. Accepting one SXL does not implicitly accept another SXL on which it
depends. See :ref:`sxl-dependency-resolution` and :ref:`sxl-list`.

Version negotiation
-------------------

For each SXL, the Version request identifies the latest exact version supported
by the site in each compatibility series. Each non-zero major version is one
series. Because major-version-zero versions require an exact match, each
supported ``0.y.z`` version is a separate series. The same SXL name can
therefore occur more than once, but at most once in each series.

The Version response contains exactly one result for each distinct SXL name in
the request. If the SXL is accepted, the response identifies the exact version
supported by the supervisor. The response version selects the compatible
series but does not select a common exact version and does not need to match
the site version.

If more than one site candidate is compatible, the supervisor must select the
candidate with the highest Semantic Versioning precedence. For a selected
non-zero major version, the supervisor must return the latest version it
supports in that major version. A major-version-zero candidate must match
exactly. Both parties must retain the selected site candidate and the
supervisor version for as long as the connection remains established.

For example, if a site advertises versions 1.5.0 and 2.1.0 of an SXL and the
supervisor supports versions 1.4.0 and 2.0.0, the supervisor selects the 2.x
series and returns 2.0.0. The site version used for compatibility decisions is
2.1.0 and the supervisor version is 2.0.0.

An SXL for which no compatible version exists is rejected in the Version
response. This does not prevent the connection from being established and
does not affect other accepted SXLs. The RSMP Core version must still match
exactly as described in :ref:`rsmpsxl-version`.

.. _sxl-version-error-handling:

Communication using compatible versions
----------------------------------------

General rules
^^^^^^^^^^^^^

Handling is determined by the exact SXL versions exchanged during Version
negotiation, the message type and the direction of the message. A receiver
must not decide whether to ignore an unknown element by interpreting whether
the element appears informational or operational.

The rules below apply to SXL-defined code ids, argument and return value names
(``n``), and command operation identifiers (``cO``). A code id is evaluated
for the addressed component type, a name is evaluated for its code id, and an
operation is evaluated for its command. The rules do not apply to
unknown RSMP Core JSON fields, which are validated according to the negotiated
RSMP Core version.

An SXL element is outside the shared API when it is not defined by the lower
of the two minor versions. This is true even if the receiver recognizes the
element from its own higher version.

An SXL element missing from either the receiver's or the sender's advertised
SXL version results in MessageNotAck, except in the cases listed below. When
MessageNotAck is required, the receiver must not process any part of the
message.

Exceptions exist only when the site uses the higher minor version. No
exceptions apply when the supervisor uses the higher minor version.

The equal-minor-version case needs no compatibility exception. Patch releases
have the same API, so an element outside that API results in MessageNotAck when
the minor versions are equal, even if the patch versions differ.

Major-version-zero pairs must match exactly, so the higher-minor exception
does not apply to them.

An alarm, status or command code id must be defined by both parties'
advertised SXL versions. Otherwise it always results in MessageNotAck,
regardless of the version relationship or message direction, unless the
complete informational message is ignored because it concerns an unsupported
newer component type as specified below. A code id must also be defined for the
addressed component type by both versions, subject to the same exception. A
known element with an invalid data type or value also always results in
MessageNotAck unless the complete message is ignored under that exception.

A party sending a request or action should use the receiver's advertised SXL
version to determine the allowed code ids, names and operations. If it sends
an SXL element outside the shared API, the receiver must handle the message as
specified below, and the sender must be prepared for MessageNotAck. The
unsupported request or action does not invalidate the negotiated SXL
compatibility or the connection.

When the rules below permit a return value outside the shared API to be
ignored, the receiver ignores the complete array entry containing that ``n``.
It processes the remaining entries and sends MessageAck if the rest of the
message is valid. A lower-version receiver does not need to implement or
inspect the higher SXL version to make this decision.

The decision to ignore is based only on the version relationship, message type
and direction. In an allowed position, the lower-version receiver therefore
treats every unrecognized ``n`` as an additive extension. The sender remains
responsible for sending only names defined by its own SXL version.

Status compatibility
^^^^^^^^^^^^^^^^^^^^

A supervisor using a lower minor version must ignore any ``sS`` entry in a
StatusResponse or StatusUpdate whose ``n`` is not defined for its ``sCI`` by
the supervisor's SXL version and process the rest of the message.

A supervisor should only use return value names defined in the site's
advertised version. A supervisor using a higher version should therefore not
request or subscribe to return values added after the site's version. If it
does, the site sends MessageNotAck and processes no part of the request.

A site using a higher version must continue to support requests and
subscriptions defined by the lower version. It must return the same meaning,
data type, units and value constraints, and must preserve the defined update
and ``sendOnChange`` behavior.

StatusResponse and StatusUpdate should contain only requested or subscribed
return values. If a site using the higher minor version includes a return
value added in that version, the lower-version supervisor handles it as
specified above.

Adding a status code or return value in a minor release is therefore
compatible: an older supervisor does not request it, and a newer supervisor
should not request it from a site whose advertised version predates it.

Alarm compatibility
^^^^^^^^^^^^^^^^^^^

A supervisor using a lower minor version must ignore any ``rvs`` entry in an
alarm message whose ``n`` is not defined for the message's ``aCId`` by the
supervisor's SXL version and process the rest of the message.

For an alarm code present in the shared API, a site using a higher version must
preserve the alarm trigger, clearing condition, category, priority, state
transitions and acknowledgment and suspension behavior of the lower version.

An Alarm sent by a site using the higher minor version can contain return
values added in that version. A supervisor using the lower version handles
them as specified above.

A site must not send alarm codes added after the supervisor's advertised
version. If the complete alarm set is operationally required, compatible but
different minor versions must not be used.

Alarm requests, acknowledgments, suspensions and resumptions ask the site to
act on a specific alarm. The supervisor should only use alarm code ids present
in the site's version.

Command compatibility
^^^^^^^^^^^^^^^^^^^^^

A supervisor using a lower minor version must ignore any ``rvs`` entry in a
CommandResponse whose ``n`` is not defined for its ``cCI`` by the supervisor's
SXL version and process the rest of the message.

A command can change equipment state, so unknown command inputs must never be
silently ignored. A supervisor should use arguments and operations defined in
the site's version. If an argument or operation is outside the shared API, the
site must send MessageNotAck and must not execute any part of the command.

An argument added to an existing command in a minor release must be optional,
and omission must preserve the behavior of the lower version. A supervisor
using the higher version should omit that argument when communicating with a
site using the lower version.

A site using the higher version must execute a shared command with the same
preconditions, effects, side effects, completion and failure behavior as the
lower version when the new optional argument is omitted.

A CommandResponse sent by a site using the higher minor version can contain
return values added in that version. A supervisor using the lower version
handles them as specified above.

Aggregated status compatibility
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

AggregatedStatus represents the site as a whole and is not sent separately for
each component. AggregatedStatusRequest requests that site-wide status. The
component-type compatibility rules below therefore do not apply to either
message. A minor or patch release must preserve the existing functional
position, functional state and state-bit meanings.

Component types
^^^^^^^^^^^^^^^

A minor release can add component types. A ComponentList from a site using the
higher version can therefore contain a component type unknown to a supervisor
using the lower version. The supervisor must not reject the complete
ComponentList solely because of that component type, but must treat the
component as unsupported.

A lower-version supervisor must ignore an alarm message, StatusResponse,
StatusUpdate or CommandResponse concerning an unsupported newer component
type. It must send MessageAck if the message is valid according to RSMP Core.
Because the complete message is ignored, its SXL-defined code id and content do
not need to be recognized by the supervisor.

A lower-version supervisor must not send a StatusRequest, StatusSubscribe,
StatusUnsubscribe, alarm request, acknowledgment, suspension or resumption, or
CommandRequest directed at an unsupported component type. If the site
nevertheless receives such a message, it must send MessageNotAck and must not
process any part of the message.

A component type not defined by the sender's advertised SXL version always
results in MessageNotAck. In any other version relationship, a component type
not defined by both advertised SXL versions also results in MessageNotAck.

A minor release must not change the meaning of existing functional positions,
functional states or aggregated status values. New alarms or components can
affect aggregated status only according to the existing RSMP Core and SXL
rules.

Examples
--------

Assume a site uses version 1.4.0 and a supervisor uses version 1.3.0:

* Version 1.4.0 adds an Alarm return value named ``colors``. The supervisor
  processes the known alarm and ignores ``colors``.
* Version 1.4.0 adds a status return value. The supervisor does not know the
  value and therefore does not request or subscribe to it. If the site
  includes it in a StatusResponse or StatusUpdate, the supervisor ignores that
  ``sS`` entry.
* Version 1.4.0 adds an optional command argument. The supervisor does not send
  it. The site performs the command with the behavior defined by version
  1.3.0.
* Version 1.4.0 adds a CommandResponse return value. The supervisor ignores the
  corresponding ``rvs`` entry and processes the remaining response.

If the supervisor uses version 1.4.0 and the site uses version 1.3.0, the
supervisor should omit a command argument added in version 1.4.0. If it sends
the argument nevertheless, the site sends MessageNotAck and does not execute
any part of the command. The connection remains established.

When the sender uses version 1.3.0 and the receiver uses version 1.4.0, an SXL
element not defined by the sender's advertised version results in
MessageNotAck, even if the receiver recognizes it from version 1.4.0. An
unknown SXL element between versions 1.3.0 and 1.3.1 also results in
MessageNotAck because patch releases have the same API.

Compatibility verification
--------------------------

Before publishing a minor or patch release, the complete structural and
behavioral API must be compared with the previous release. A minor release
should document every added API element and the behavior used when it is not
available to an older peer.

Implementations should test communication in both directions between the new
version and supported lower minor and patch versions. Tests must cover status
requests and subscriptions, alarm state handling, commands and their side
effects, error handling and aggregated status.
