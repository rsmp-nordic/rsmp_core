.. _transport-of-data:

Transport of data
-----------------

The message flow is different between different types of messages.
Some messages are event driven and sent without a request (push),
while others are interaction driven, ie. they sent in response to a
request from a host system or other system ( client- server). To
ensure that messages reach their destinations a message acknowledgement
is sent for all messages. This gives the application a simple way to
follow up on the message exchange. To communicate between equipments
and supervisions systems a pure TCP connection is used (TCP/IP), and
the data sent is based on the JSON format, ie formatted text.

Communication establishment
^^^^^^^^^^^^^^^^^^^^^^^^^^^

When establishing communication, messages are sent in the following
order.

1. RSMP / SXL version (according to section :ref:`rsmpsxl-version`)

2. Watchdog (according to section :ref:`watchdog`)

3. Aggregated status (according to section :ref:`aggregated-status-message`)

4. All active and blocked alarm are sent (according to section
   :ref:`alarm-messages`). The alarms that are not sent will be interpreted
   as non-active and non-blocked by the supervision system.

5. Any remaining messages in the equipment's outgoing communication
   buffer are sent

6. Any previous subscriptions to status messages are re-established;
   because they automatically cease at communication disruption

Communication disruption
^^^^^^^^^^^^^^^^^^^^^^^^

In the event of a communications failure the outgoing messages are
stored in the equipment's communication buffer. Once communication is
restored all the messages in the communications buffer are sent.

Any subscriptions to status messages ceases if the communication
failure occurs.

In the event of communications failure or power outage outgoing
communication buffer of equipment not empty, this does not apply
watchdog messages.

The internal communication buffer of the device must at a minimum be
sized to be able to store 1000 messages. At full communication buffer
the FIFO principle applies.

Transport between site and supervision system
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Supervision system acts a socket server and waits for the site to
connect. If the communication were to fail it is the site’s
responsibility to reconnect.

Transport between sites
^^^^^^^^^^^^^^^^^^^^^^^

One site acts as socket server and waits for the other site to
connect. If the communication were to fail it is the connecting site’s
responsibility to reconnect.

