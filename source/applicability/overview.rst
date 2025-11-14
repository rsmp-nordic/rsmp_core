.. concepts:

Overview
========
RSMP is a protocol for communication between roadside equipment (sites) and central systems (supervisors).

RSMP consists of the Core specification and Signal Exchange Lists (SXLs).

Core Specification
------------------
The core specfication (this document) defines basic message structure and behavior, common to all types of
sites and supervisor.

Signal Exchange Lists (SXLs)
----------------------------
An SXL defines component types, as well as the alarms, statuses and commands for each type.
A site can support one or more SXLs.

Components
----------
A site consists of one or more components, which are physical or logical parts of the site.
For example, a traffic light controller might have signal groups and detector logic.
