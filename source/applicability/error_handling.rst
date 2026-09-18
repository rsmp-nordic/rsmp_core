.. _error_handling:

Error handling
--------------

The following sections defines how errors should be handled.

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

SXL errors and version differences
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If a command, status or alarm uses an SXL which was not accepted during the
Version exchange, the receiver must respond with MessageNotAck.

A known attribute with an invalid value or data type also results in
MessageNotAck. Handling of unknown code ids and attributes when compatible SXL
versions differ is defined in :ref:`sxl-version-error-handling`.

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
