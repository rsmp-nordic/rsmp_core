---
layout: page
title: Persistence
permalink: /3.3.0/persistence/
parent: Applicability
nav_order: 12
---

# Command Persistence {#command_persistence}

Handling a command often cause changes to the state of the site. For example, a command might be used to select a running program or adjust a setting.

## Default Behavior {#sxl_persistence_default}

By default, changes caused by commands persist until changed again by another command, even after a restart of the site.

## Reset Events {#sxl_persistence_reset_events}

For some commands, certain event should reset changes.

For each command defined in the SXL, it must be specified what events cause changes to reset, if any. If no reset events are specified for a command, the default behavior applies.

When possible, an SXL should refer to the following standard reset events when defining persistence behavior:

Restart  
The change reset when the site restarts.

Disconnect  
The change is reset if the connection to the supervisor system is lost. This can be either immediately or after some defined duration of time.

Timer  
The change is reset after a certain time has passed. The SXL must specify the duration, which could either be fixed, configurable or controlled by command attributes.

Process  
The change can be reset or overwritten by a process on the site. For example, a command might initiate a process which resets the change when it completes.

Volatile  
An immediate action that does not change any exposed state. Any meaningful action by definition causes a change somewhere, but the change might be internal or in external systems. that are not exposed to the supervisor system.

## Custom Persistence {#custom-persistence}

An SXL can define custom persistence behavior for particular commands.

An SXL can also define a different default persistence. For example, if the type of equipment is expected to only have volatile memory, it might make sense to define the default persistence to be until a restart.

When an SXL need to define custom persistence behavior, it should refer to the standard reset events when possible. However, an SXL can define custom reset events or behavior if needed.
