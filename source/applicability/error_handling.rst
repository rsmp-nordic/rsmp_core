.. _error_handling:

Error handling
--------------

The following sections defines how errors should be handled.

.. _message-validation:

Message validation
^^^^^^^^^^^^^^^^^^

Messages must conform to :ref:`basic-structure` and the requirements of their
message type in the selected core version and SXLs in use. Validation failures
must be handled according to the first applicable rule below:

1. If a packet is not valid UTF-8 encoded JSON, or its JSON value is not an object,
   discard it without acknowledgement.
2. If ``type`` is ``"MessageAck"`` or ``"MessageNotAck"``, never send an
   acknowledgement in response, even if other fields are invalid. Discard an
   invalid acknowledgement; process a valid one according to
   :ref:`message-acknowledgement`.
3. If ``mId`` is missing or invalid according to :ref:`basic-structure`, discard
   the message without acknowledgement.
4. If ``mType`` is missing or is not ``"rSMsg"``, or ``type`` is missing, has an
   invalid value or identifies an unknown message type, reject the message with
   MessageNotAck.
5. If a recognized message has missing required fields or invalid field values,
   reject it with MessageNotAck, unless a message-specific rule defines another
   response, such as the rules for unknown components below.

When sending MessageNotAck, set ``oMId`` to the received ``mId`` and ``rea`` to
the cause of rejection. Rejected or discarded messages must not be processed
further. Valid messages are processed and acknowledged according to their
message-specific rules.

During communication establishment, the exceptions and validation order in
:ref:`initial-message-validation` apply.

After communication establishment, these validation failures must not themselves
cause the receiver to close the connection. The acknowledgement and Watchdog
timeout rules still apply (see :ref:`message-acknowledgement` and :ref:`watchdog`).


Unknown component
^^^^^^^^^^^^^^^^^

If the component (``cId``) is not known, then the site must answer with
CommandResponse/StatusResponse where the values are set according to the
table below.

.. table:: ComponentId unknown

   +-----------------+---------+-----------+
   | Message type    | Element | Value     |
   +=================+=========+===========+
   | StatusResponse  | q       | undefined |
   |                 +---------+-----------+
   |                 | s       | ``null``  |
   +-----------------+---------+-----------+
   | CommandResponse | age     | undefined |
   |                 +---------+-----------+
   |                 | v       | ``null``  |
   +-----------------+---------+-----------+

SXL mismatch
^^^^^^^^^^^^

If there is a mismatch of the SXL when receiving a command, status or alarm
request, which is not caught during communication handshake (See
:ref:`rsmpsxl-version`), then this is considered a serious error resulting in
MessageNotAck.

This includes:

* unknown alarm/status/command code id (``aCId``, ``sCI``, ``cCI``) for the
  corresponding component type

* unknown name (``n``) in arguments or return values

Unimplemented statuses or commands
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If a status (``sCI``) or command (``cCI``) is recognized in relation to its SXL
but not implemented, the site answers with CommandResponse/StatusResponse where
the values are set according to the table below.

.. table:: Unimplemented

   +-----------------+---------+-----------+
   | Message type    | Element | Value     |
   +=================+=========+===========+
   | StatusResponse  | q       | unknown   |
   |                 +---------+-----------+
   |                 | s       | ``null``  |
   +-----------------+---------+-----------+
   | CommandResponse | age     | unknown   |
   |                 +---------+-----------+
   |                 | v       | ``null``  |
   +-----------------+---------+-----------+

.. _incomplete-commands:

Incomplete commands
^^^^^^^^^^^^^^^^^^^

If not all required arguments are included in a CommandRequest, then this is
considered a serious error resulting in MessageNotAck.


.. _more-than-one-command:

More than one command
^^^^^^^^^^^^^^^^^^^^^

If more than one command (``cCI``) is included in a single CommandRequest or
CommandResponse, then this is considered a serious error resulting in
MessageNotAck.
