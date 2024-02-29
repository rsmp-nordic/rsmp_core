.. _object-model:

Object model
------------

This protocol uses the Datex II (datex2.eu) meta-model for its
object model. Meta model consists of a set of rules that describe how
classes and objects are defined. The reason why the Datex II meta-
model has been adopted is that it will eventually provide the
possibility for this protocol to become an international standard that
can later be included with the object model for Datex II. The object
model is technology independent, ie can be implemented in various ways
such as using **ASN.1**, **JSON** or **XML**.

In section :ref:`basic-structure` all examples is provided in XML format
for clarity. But the communication between the facility and supervision
systems / other facility uses JSON format. In section :ref:`usage-of-json`
all message types in both XML and JSON are provided side by side.

Objects used for message exchange is **Alarm** with subclasses **Issue**,
**Acknowledge** and **Suspend**. For other objects there are classes
**AggregatedStatus**, **StatusRequest**, **StatusResponse**,
**CommandRequest**, **CommandResponse**, **Watchdog**, **MessageAck**,
**MessageNotAck**. For detailed information about how these classes are
used, see section :ref:`basic-structure`.
