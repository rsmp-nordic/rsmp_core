---
layout: page
title: Definitions
permalink: /3.3.0/definitions/
nav_order: 5
---

# Definitions {#definitions}

## Alarm code id {#alarm-code-id}

Identity of an alarm

The examples in this document are defined according to the following format: *Ayyyy*, where *yyyy* is a unique number.

## Code id {#code-id}

A code id identifies alarms, commands and statuses. See [Alarm code id]({{ '/3.3.0/definitions/#alarm-code-id' | relative_url }}), [Command code id]({{ '/3.3.0/definitions/#command-code-id' | relative_url }}) and [Status code id]({{ '/3.3.0/definitions/#status-code-id' | relative_url }}).

## Command code id {#command-code-id}

Identity of a command

The examples in this document are defined according to the following format: *Myyyy* where *yyyy* is a unique number.

## External alarm code id {#external-alarm-code-id}

Manufacturer specific alarm code and alarm description. Includes manufacturer, model, internal alarm code och additional alarm description.

## External NTS alarm code id {#external-nts-alarm-code-id}

Alarm code in order to identify alarm type during communication with NTS

## Functional position {#functional-position}

Provides command options for a site. For instance, "start" or "stop" It is meant to be used for the entire site and not for an individual component. It can be implemented using a command and can be read from the site using the aggregated status message.

## Functional state {#functional-state}

Not used

## ITS site {#its-site}

Road side equipment. Covers both field level and local level

## JSON {#json}

JavaScript Object Notation

## Local road side equipment {#local-road-side-equipment}

See [ITS site]({{ '/3.3.0/definitions/#its-site' | relative_url }})

## Maneuver {#maneuver}

Provides command options for one or many individual components. For instance, "start" or "stop". It can be implemented using a command and can be read from the site using a corresponding status message.

Designed to be used with NTS.

## NTS {#nts}

> National Traffic management system at the Swedish Transport Administration

## Component {#component}

A [component]({{ '/3.3.0/components/#components' | relative_url }}) represents physical or logical parts of a site, e.g. a camera, a control flow algorithm or a group of signs.

*Please note that a component is not necessarily the same thing as an NTS object.*

## Component id {#component-id}

A [Component ID]({{ '/3.3.0/components/#component-id' | relative_url }}) identifies a [component]({{ '/3.3.0/components/#components' | relative_url }}).

## Parameter {#parameter}

Used for modification of technical or autonomous traffic parameters of the equipment. Can be implemented using commands and statuses.

## RSMP {#rsmp}

Road Side Message Protocol

## RSMP Nordic {#rsmp-nordic}

Organization for maintaining and develop the RSMP protocol. Collaboration between a group of Nordic road authorities.

## Site {#site}

See [ITS site]({{ '/3.3.0/definitions/#its-site' | relative_url }})

## Site id {#site-id}

Site identity. Used in order to refer to a “logical” identity of a site.

## Supervision system {#supervision-system}

Control and supervision system for regional and/or national level

## SXL {#sxl}

> Signal exchange list. Defines which messages types (signals) which is possible to send to a specific equipment or component. E.g. alarms, statuses and commands

## Status code id {#status-code-id}

> Identitiy for a status
>
> The examples in this document are defined according to the following format: *Syyyy* where *yyyy* is a unique number.

## TCP/IP {#tcpip}

Transfer Control Protocol/Internet Protocol

## W3C {#w3c}

World Wide Web Consortium

## XML {#xml}

eXtensible Markup Language
