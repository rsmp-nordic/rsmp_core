.. _error_handling:

Error handling
--------------

The following sections defines how errors should be handled.

Unknown component
^^^^^^^^^^^^^^^^^

If the component (``cId``) is not known, then the site must answer with
CommandResponse/StatusResponse where ``q`` or ``age`` is set according to the
table below. ``v`` should be set to ``null``.

.. table:: ComponentId unknown

   =============== =================
   Message type    Content
   =============== =================
   StatusResponse  q=undefined
   CommandResponse age=undefined
   =============== =================

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

If a status (``sCI``) or command (``cCI``) is unimplemented, the site answers
with CommandResponse/Response where ``q`` or ``age`` is set according to the
table below. ``v`` should be set to ``null``.

.. table:: Unimplemented

   =============== =================
   Message type    Content
   =============== =================
   StatusResponse  q=unknown
   CommandResponse age=unknown
   =============== =================


Incomplete commands
^^^^^^^^^^^^^^^^^^^

If not all arguments are included in a CommandRequest, then this is considered
a serious error resulting in MessageNotAck.
