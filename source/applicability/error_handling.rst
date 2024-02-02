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

SXL mismatch
^^^^^^^^^^^^

If there is a mismatch of the SXL when receiving a command, status or alarm
request, which is not caught during communication handshake (See
:ref:`rsmpsxl-version`), then this is considered a serious error resulting in
MessageNotAck.

This includes:

* unknown alarm code id (``aCId``)
* unknown status code id (``sCI``)
* unknown command code id (``cCI``)
* unknown name (``n``) in arguments or return values

Unimplemented statuses or commands
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If a status (``sCI``) or command (``cCI``) is recognized in relation to its SXL
but not unimplemented, the site answers with CommandResponse/StatusResponse where
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

If not all arguments are included in a CommandRequest, then this is considered
a serious error resulting in MessageNotAck.
