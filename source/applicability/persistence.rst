.. _command_persistence:

Command Persistence
===================
Handling a CommandRequest often cause changes to the state of the site.
For example, a command might be used to select a program or adjust a setting.

.. _persistence_levels:

Persistence Levels
------------------
The persistence level control whether a change will be kept forever, or will revert back
to a default or previous settings at some point.

The following standard persistence levels are defined:

Permanent:
The change is kept permanently, even after a restart of the site.
This implies that it must be stored on disk or other non-volatile storage.

Restart:
The change is kept until the next restart of the site. This implies that it can be stored in memory.

Disconnect:
The change is kept until the connection to the supervisor system has been lost for a configurable timeout. After that, the previous value is restored.
This implies that it can be stored in memory.

Volatile:
The change is short lived and is expected to be changed again soon, e.g. by some automatic process

No persistence:
An immediate action that does not change any exposed state.
Any meaningful action by defintion causes a change somewhere, but the change might be in internal parts
that are not exposed through RSMP, or in external systems.

.. _sxl_persistence_default:

Defalt Persistence
------------------
The default persistence level for commands is Permanent.

This  mean that by default, a site must keep changes caused by commands permanently, even after a restart of the site.
I.e. the change persists until it's changed again by another command or some well-defined automatic behaviour.

.. _sxl_persistence_specialization:

SXL Persistence Specialization
------------------------------
An SXL can override the default persistence behavior for particular commands.

An SXL can also define a different efault persistence. For example, if the type of equipmemnt is expected to
only have volatile memory, it would make sense to define the default persistence to be until a restart.

When an SXL need to define custom persistence behaviour, the standard persistence levels should be used
if possible. However, an SXL can define custom persistence levels or behaviour if needed.
