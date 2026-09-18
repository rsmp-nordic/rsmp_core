---
layout: page
title: Error Handling
permalink: /3.3.0/error-handling/
parent: Applicability
nav_order: 6
---

# Error handling {#error_handling}

The following sections defines how errors should be handled.

## Unknown component {#unknown-component}

If the component (`cId`) is not known, then the site must answer with CommandResponse/StatusResponse where the values are set according to the table below.

**ComponentId unknown**

| Message type | Element | Value |
| --- | --- | --- |
| StatusResponse | q | undefined |
| StatusResponse | s | `null` |
| CommandResponse | age | undefined |
| CommandResponse | v | `null` |

## SXL mismatch {#sxl-mismatch}

If there is a mismatch of the SXL when receiving a command, status or alarm request, which is not caught during communication handshake (See [RSMP/SXL Version]({{ '/3.3.0/basic-structure/#rsmpsxl-version' | relative_url }})), then this is considered a serious error resulting in MessageNotAck.

This includes:

- unknown alarm/status/command code id (`aCId`, `sCI`, `cCI`) for the corresponding component type
- unknown name (`n`) in arguments or return values

## Unimplemented statuses or commands {#unimplemented-statuses-or-commands}

If a status (`sCI`) or command (`cCI`) is recognized in relation to its SXL but not unimplemented, the site answers with CommandResponse/StatusResponse where the values are set according to the table below.

**Unimplemented**

| Message type | Element | Value |
| --- | --- | --- |
| StatusResponse | q | unknown |
| StatusResponse | s | `null` |
| CommandResponse | age | unknown |
| CommandResponse | v | `null` |

## Incomplete commands {#incomplete-commands}

If not all arguments are included in a CommandRequest, then this is considered a serious error resulting in MessageNotAck.

## More than one command {#more-than-one-command}

If more than one command (`cCI`) is included in a single CommandRequest or CommandResponse, then this is considered a serious error resulting in MessageNotAck.
