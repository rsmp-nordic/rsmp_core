# RSMP Core Specification Repository Guide

This repository contains the RSMP (Road Side equipment Monitoring Protocol) core specificion. RSMP is an open, modern, and flexible communication protocol for road side equipment and supervision systems.

## Key Concepts
### Transport Layer
RSMP is based on bidrectional TCP sockets.
Equipment (sites) connect to a central system (supervisor).
Connection between equipment (sites) is possible, but not widely used.

### Core Message Types
- **Version** - Request/response, used to establishing connection
- **Alarm** - Event-driven, sent when alarm state changes
- **Aggregated Status** - Event-driven, overview of equipment state
- **Status** - Request/response or subscription-based, detailed information
- **Command** - Request/response, control instructions
- **Version** - Handshake message for version negotiation
- **Watchdog** - Heartbeat message for connection monitoring
- **MessageAck/MessageNotAck** - Acknowledgement of message receipt

### Communication Patterns
- **Push (Event-driven)**: Alarms, Aggregated Status, Status Updates sent without request
- **Pull (Request/Response)**: Status Requests, Commands, Aggregated Status Requests
- **Subscribe/Unsubscribe**: Status subscription for continuous updates
- **Handshake**: Version and Watchdog messages during connection establishment

### Component Identification
- **Format A**: Site-based (AA+BBCDD=EEEFFGGG)
- **Format B**: Hierarchical (/.../...)
- **Main Component**: Special designated component, referenced as "" or null

### Configuration Files
- **SXL (Signal Exchange List)**: Defines what messages are possible (YAML or Excel) for a specific equipment type
- **Site Configuration**: Defines which components exist in a specific site (YAML or Excel)

## Directory Structure

```
rsmp_core/
├── README.md                    # Project overview and build instructions
├── LICENSE                      # License information
├── Makefile                     # Build automation for documentation
├── make.bat                     # Windows build script
├── .github/                     # GitHub workflows and configuration
├── docs/                        # Generated documentation output
└── source/                      # Documentation source files (reStructuredText)
    ├── index.rst                # Main table of contents
    ├── introduction.rst         # General protocol introduction
    ├── purpose.rst              # Protocol purpose and identified requirements
    ├── definitions.rst          # Glossary of terms and definitions
    ├── changelog.rst            # Version history and changes
    ├── conf.py                  # Sphinx configuration
    ├── applicability.rst        # Main applicability section (references subsections)
    ├── applicability/           # Detailed specification sections
    ├── img/                     # Diagrams and images
    └── style/                   # LaTeX styling
```

---


### Root-Level Documentation Files

#### `source/index.rst`
Master document and table of contents

#### `source/introduction.rst`
General introduction to the protocol

#### `source/purpose.rst`
Detailed explanation of protocol purpose and requirements

#### `source/applicability/transport_of_data.rst`
Define message flow and communication transport mechanisms
**Sections**:
- **Transport of data** - Overview of message types
- **Multiple supervisors** - Handling multiple supervision system connections
- **Security** - Encryption and TLS requirements
- **Communication establishment between sites and supervision system** (10 numbered steps)
  - **Communication establishment between sites** - Direct site-to-site connections
#### `source/applicability/basic_structure.rst`
Define the fundamental message structure and format
**Sections**:
- **Basic structure** - Unicode, UTF-8, case sensitivity, parsing rules
- **Alarm messages** - Overview of alarm message behavior
    - **Structure of an alarm message** - JSON example and message format
    - **Alarm status** - Status values (Active/inActive, Acknowledged/notAcknowledged, Suspended/notSuspended)
      - Alarm transitions diagram
    - **Return values** - Format for alarm return data
    - **Structure for an alarm request message** - Format for requesting alarm state
    - **Structure for an alarm acknowledgement message** - Format for acknowledging alarms
    - **Structure for an alarm suspend message** - Format for suspending alarms
- **Aggregated status message** - Equipment status overview
    - **State bits** - Predefined status indicators
- **Aggregated status request message** - Requesting status overview
- **Status Messages** - Detailed status information
    - **Structure of a status request** - Format for requesting specific status
    - **Structure for a status response message** - Responding with status data
    - **Return values (returnvalue)** - Status response data format
    - **Structure for a status subscription request message** - Subscribing to status updates
    - **Attribute updates** - How status changes are detected
    - **Structure for a status update message** - Format for pushing status updates
    - **Structure for a status unsubscription message** - Ending status subscriptions
- **Command messages** - Control instructions
    - **Structure of a command request** - Format for sending commands
    - **Structure of a command response message** - Command execution responses
- **Message acknowledgement** - Confirmation of message receipt
    - **Message structure – Message acknowledgement** - MessageAck format
    - **Message structure – Message not acknowledged** - MessageNotAck format with error reasons
    - **Message exchange between site and supervision system/other equipment** - Two-way acknowledgement flows
- **RSMP/SXL Version** - Initial handshake message for connection establishment
    - **Message structure** - Version message format with RSMP versions, SXL version, site IDs
    - Version negotiation and receiveAlarms attribute
- **Watchdog** - Heartbeat message for connection monitoring
    - **Message structure** - Watchdog message format with timestamp
    - **Message exchange** - Watchdog flows from both site and supervision system

#### `source/applicability/error_handling.rst`
Define error scenarios and how to handle them
**Sections**:
- **Error handling** - Introduction
- **Unknown component** - ComponentId not found responses
    - StatusResponse with q=undefined, s=null
    - CommandResponse with age=undefined, v=null
- **SXL mismatch** - Mismatched signal exchange list errors
    - Unknown alarm/status/command code ids
    - Unknown argument/return value names
    - Results in MessageNotAck
- **Unimplemented statuses or commands** - Recognized but not implemented
    - StatusResponse with q=unknown, s=null
    - CommandResponse with age=unknown, v=null
- **Incomplete commands** - Missing command arguments
    - Results in MessageNotAck
- **More than one command** - Multiple commands in single request
    - Results in MessageNotAck

#### `source/applicability/data_types.rst`
Define all data types used in messages and SXLs
**Sections**:
- **Data types** - Introduction
- **JSON types** - Native JSON types
- **Specialized types** - RSMP-specific type definitions
    - **integer** - Whole numbers (e.g., 12, 0, -5), ECMA standard
    - **timestamp** - W3C XML dateTime with 3 decimal places (e.g., 2019-09-26T12:54:54.066Z), always UTC
    - **base64** - Binary data as base64 string per RFC-4648
- **Legacy types** - For backward compatibility
    - **number_as_string** - Number as quoted string (e.g., "12", "0.5")
    - **integer_as_string** - Integer as quoted string (e.g., "12", "-7")
    - **boolean_as_string** - Boolean as quoted string ("true" or "false")
    - **string_list_as_string** - Comma-separated strings (e.g., "high,medium,low")
    - **number_list_as_string** - Comma-separated numbers (e.g., "1.0,2")
    - **integer_list_as_string** - Comma-separated integers (e.g., "2,-4,0")
    - **boolean_list_as_string** - Comma-separated booleans (e.g., "true,false")

#### `source/applicability/component_id.rst`
Define how components are identified in RSMP messages
**Sections**:
- **Component ID** - Overview and two format options
- **Format A** - Original component ID format
    - Structure: AA+BBCDD=EEEFFGGG
    - Components: site id, site type, component type, component index
    - Examples: KK+AG0503=001DL001, KK+AG0503=001SG005
- **Format B** - Hierarchical component ID format
    - Structure: /.../...
    - Examples: /tc, /sg/1, /in/1/sg/6, /dl/radar/1
    - Supports intermediate references (e.g., /sg/ for all signal groups)
    - Special values: / (all components), "" or null (main component)
- **Component indexes** - Unique integer identifiers per component
    - Must be unique on site across all component types
    - Used in normalized subsets (0-indexed without gaps)
    - Support efficient compact data representation
    - Examples and use cases for status strings
- **Main component** - Special designated component
    - Each site must have exactly one
    - Can be referenced by component ID or shorthand ("" or null)

#### `source/applicability/sxl.rst`
Define Signal Exchange Lists (SXLs) - the core dynamic message definition mechanism
**Sections**:
- **Signal Exchange List** - Overview and importance
- **Component types** - Defining types of components in a site
    - YAML and Excel format examples
    - Component-type definition structure
- **Message types** - Defining Alarm, Aggregated status, Status, and Command messages
    - YAML structure examples
    - Aggregated status states
    - Functional position examples
    - Alarm definition with priority, category, external IDs
    - Status definitions
    - Command definitions
- **Alarm description** - Text describing alarm purpose
- **Alarm category** - Categories for alarm classification
- **Alarm priority** - Priority levels for alarms
- **Functional differences between message types** - How Alarm/Status/Command types differ
- **Arguments and return values** - How to define command/status arguments

#### `source/applicability/site_configuration.rst`
Define individual site configurations - which components exist in a specific site
**Sections**:
- **Site configuration** - Overview
- **Meta data** - Site identification and versioning
    - Plant id, name, constructor
    - Created date, SXL revision, RSMP version
    - Mapping between Excel and YAML terminology
- **Components** - Definition of individual components in a site
    - Component types and single components vs. grouped (main) components
    - Main component definition (componentId == ntsObjectId)
    - Single components (unique componentId, shared ntsObjectId)
    - External NTS integration fields (externalNtsId, ntsObjectId)
    - YAML structure examples
    - NTS-specific note (Swedish Transport Administration)

## Image and Diagram Folders
- Message Sequence Charts `source/img/msc/`
- State Diagrams `source/img/dot/`
- Color Reference Files `source/img/svg/`
- RSMP Logo `rsmp_logo.png`

## Build and Generation
The documentation is built using Sphinx, see README.md for details.

### Quick Navigation
- **For message format/structure**: See `applicability/basic_structure.rst`
- **For error scenarios**: See `applicability/error_handling.rst`
- **For component identification**: See `applicability/component_id.rst`
- **For data types**: See `applicability/data_types.rst`
- **For SXL definition format**: See `applicability/sxl.rst`
- **For site configuration**: See `applicability/site_configuration.rst`
- **For communication flows**: See `applicability/transport_of_data.rst` and diagram files in `img/msc/`
- **For term definitions**: Use `definitions.rst` with cross-references via `:term:` role

### Search Patterns
- **Message types**: Search for "Alarm", "Status", "Command", "Version", "Watchdog" in `basic_structure.rst`
- **Message elements**: Search table sections in files for element descriptions
- **State transitions**: See `img/dot/alarm_transitions.dot` for visual representation
- **Communication sequences**: See corresponding `.msc` files in `img/msc/`

### Cross-Reference System
- Definitions use Sphinx `.. glossary::` directive
- Cross-references use `:term:` role for terms and `:ref:` for sections
- External references use custom `:issue:` and `:compare:` links to GitHub
- Numbered figures/tables use `:numref:` for references

## Workflow
Follow existing style and patterns, including:
- writing style
- level of details
- naming and structure of files and folders
- favour succinct description
- documentation focus on the current version, when editing, don't explain why things are changed  

The documentation must be coherent. When editing files, make sure that:
- other files are updated when relevant
- cross-references, indexes, etc. are updated
