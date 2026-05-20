---
layout: page
title: Error Handling
permalink: /3.3.0/error-handling/
parent: Applicability
nav_order: 5
---

# Error Handling

The following sections defines how errors should be handled.

## Unknown Component

If the component (`cId`) is not known, then the site must answer with
CommandResponse/StatusResponse where the values are set according to the
table below.

<table>
  <thead>
    <tr><th>Message type</th><th>Element</th><th>Value</th></tr>
  </thead>
  <tbody>
    <tr><td rowspan="2">StatusResponse</td><td>q</td><td>undefined</td></tr>
    <tr><td>s</td><td><code>null</code></td></tr>
    <tr><td rowspan="2">CommandResponse</td><td>age</td><td>undefined</td></tr>
    <tr><td>v</td><td><code>null</code></td></tr>
  </tbody>
</table>

## SXL Mismatch

If there is a mismatch of the SXL when receiving a command, status or alarm
request, which is not caught during communication handshake (see
[RSMP/SXL Version]({{ '/3.3.0/basic-structure/#rsmpsxl-version' | relative_url }})),
then this is considered a serious error resulting in MessageNotAck.

This includes:

- unknown alarm/status/command code id (`aCId`, `sCI`, `cCI`) for the
  corresponding object type
- unknown name (`n`) in arguments or return values

## Unimplemented Statuses or Commands

If a status (`sCI`) or command (`cCI`) is recognized in relation to its SXL
but not unimplemented, the site answers with CommandResponse/StatusResponse where
the values are set according to the table below.

<table>
  <thead>
    <tr><th>Message type</th><th>Element</th><th>Value</th></tr>
  </thead>
  <tbody>
    <tr><td rowspan="2">StatusResponse</td><td>q</td><td>unknown</td></tr>
    <tr><td>s</td><td><code>null</code></td></tr>
    <tr><td rowspan="2">CommandResponse</td><td>age</td><td>unknown</td></tr>
    <tr><td>v</td><td><code>null</code></td></tr>
  </tbody>
</table>

## Incomplete Commands
{: #incomplete-commands}

If not all arguments are included in a CommandRequest, then this is considered
a serious error resulting in MessageNotAck.
