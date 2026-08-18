.. _security-considerations:

Security considerations
-----------------------

Security scope
^^^^^^^^^^^^^^

RSMP Core defines an application protocol for exchanging messages between
sites and supervision systems. RSMP Core does not require protected
communication and does not add cryptographic protection to RSMP messages.

When RSMP is used over an unprotected TCP connection, an attacker with access
to the network can read RSMP data and can attempt to modify, inject, or replay
messages. Message acknowledgements and message identifiers are protocol
features, not cryptographic protection. They do not provide
confidentiality, peer authentication, or protection against a network attacker.

External communication protection
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

As described in :ref:`transport-security`, a deployment can use TLS, a VPN, or
another external mechanism to protect the communication carrying RSMP. These
mechanisms do not change RSMP messages or protocol behaviour and are not part
of RSMP Core conformance.

TLS can protect the TCP connection between the endpoints that terminate TLS. A
VPN can protect network traffic between the endpoints of the VPN tunnel. Both
can provide confidentiality, integrity, and peer authentication within their
respective trust boundaries when configured and validated correctly.

Selection of a protection mechanism and its versions, identities, trust
configuration, credentials, and operation are deployment responsibilities.
RSMP Core does not define a TLS or VPN security profile.

Trust boundary and intermediaries
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Communication protection applies only between the endpoints that terminate
it. TLS endpoints are commonly application processes or devices. VPN endpoints
may instead be hosts or network gateways. Traffic outside those endpoints is
not protected by that mechanism.

An intermediary that terminates protection may be able to read or modify RSMP
messages unless additional end-to-end protection is used. Separate protected
connections are needed on both sides of such an intermediary when protection
is required across the complete path.

Limitations
^^^^^^^^^^^

External communication protection does not protect against:

* compromise of a site, supervision system, or trusted intermediary
* disclosure or unauthorized use of endpoint credentials or private keys
* denial of service or traffic analysis
* insecure device firmware, operating systems, administrative interfaces, or
  software updates
* disclosure of RSMP data in application logs, databases, backups, or other
  storage outside the protected connection
* unsafe application behaviour or incorrect authorization of commands

The system owner and suppliers are responsible for the security and safety of
the complete deployment, including devices, networks, credentials, operations,
monitoring, incident response, and compliance. The division of responsibilities
between RSMP Nordic and deployers is described on the
`RSMP Nordic website <https://rsmp-nordic.org/>`_.
