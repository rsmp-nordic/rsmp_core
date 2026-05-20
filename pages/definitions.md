---
layout: page
title: Definitions
permalink: /3.3.0/definitions/
nav_order: 5
---

# Definitions

<dl>

<dt id="alarm-code-id">Alarm code id</dt>
<dd>
Identity of an alarm.
The examples in this document are defined according to the following
format: <em>Ayyyy</em>, where <em>yyyy</em> is a unique number.
</dd>

<dt id="code-id">Code id</dt>
<dd>
A code id identifies alarms, commands and statuses. See
<a href="#alarm-code-id">Alarm code id</a>,
<a href="#command-code-id">Command code id</a> and
<a href="#status-code-id">Status code id</a>.
</dd>

<dt id="command-code-id">Command code id</dt>
<dd>
Identity of a command.
The examples in this document are defined according to the following
format: <em>Myyyy</em> where <em>yyyy</em> is a unique number.
</dd>

<dt id="external-alarm-code-id">External alarm code id</dt>
<dd>
Manufacturer specific alarm code and alarm description.
Includes manufacturer, model, internal alarm code och additional
alarm description.
</dd>

<dt id="external-nts-alarm-code-id">External NTS alarm code id</dt>
<dd>
Alarm code in order to identify alarm type during communication with NTS.
</dd>

<dt id="datex-ii">DATEX II</dt>
<dd>
European standard for message exchange between traffic systems
(www.datex2.eu).
</dd>

<dt id="functional-position">Functional position</dt>
<dd>
Provides command options for a site. For instance, "start" or "stop".
It is meant to be used for the entire site and not for an individual
component. It can be implemented using a command and can be read from
the site using the aggregated status message.
</dd>

<dt id="functional-state">Functional state</dt>
<dd>Not used.</dd>

<dt id="its-site">ITS site</dt>
<dd>Road side equipment. Covers both field level and local level.</dd>

<dt id="json">JSON</dt>
<dd>JavaScript Object Notation.</dd>

<dt id="local-road-side-equipment">Local road side equipment</dt>
<dd>See <a href="#its-site">ITS site</a>.</dd>

<dt id="maneuver">Maneuver</dt>
<dd>
Provides command options for one or many individual components.
For instance, "start" or "stop". It can be implemented using a
command and can be read from the site using a corresponding status
message.
Designed to be used with NTS.
</dd>

<dt id="nts">NTS</dt>
<dd>National Traffic management system at the Swedish Transport Administration.</dd>

<dt id="component">Component</dt>
<dd>
A <a href="{{ '/3.3.0/basic-structure/' | relative_url }}">component</a> represents physical or logical parts of a site,
e.g. a camera, a control flow algorithm or a group of signs.
<em>Please note that a component is not necessarily the same thing as an
NTS object.</em>
</dd>

<dt id="component-id">Component id</dt>
<dd>
A component id identifies a <a href="#component">component</a>.
</dd>

<dt id="parameter">Parameter</dt>
<dd>
Used for modification of technical or autonomous traffic parameters
of the equipment. Can be implemented using commands and statuses.
</dd>

<dt id="rsmp">RSMP</dt>
<dd>Road Side Message Protocol.</dd>

<dt id="rsmp-nordic">RSMP Nordic</dt>
<dd>
Organization for maintaining and develop the RSMP protocol.
Collaboration between a group of Nordic road authorities.
</dd>

<dt id="site">Site</dt>
<dd>See <a href="#its-site">ITS site</a>.</dd>

<dt id="site-id">Site id</dt>
<dd>
Site identity.
Used in order to refer to a "logical" identity of a site.
</dd>

<dt id="supervision-system">Supervision system</dt>
<dd>Control and supervision system for regional and/or national level.</dd>

<dt id="sxl">SXL</dt>
<dd>
Signal exchange list. Defines which messages types (signals)
which is possible to send to a specific equipment or component.
E.g. alarms, statuses and commands.
</dd>

<dt id="status-code-id">Status code id</dt>
<dd>
Identity for a status.
The examples in this document are defined according to the following
format: <em>Syyyy</em> where <em>yyyy</em> is a unique number.
</dd>

<dt id="tcpip">TCP/IP</dt>
<dd>Transfer Control Protocol/Internet Protocol.</dd>

<dt id="w3c">W3C</dt>
<dd>World Wide Web Consortium.</dd>

<dt id="xml">XML</dt>
<dd>eXtensible Markup Language.</dd>

</dl>
