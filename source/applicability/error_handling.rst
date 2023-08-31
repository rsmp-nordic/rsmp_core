.. _error_handling:

Error handling
--------------

The following sections defines how errors should be handled.

SXL mismatch
^^^^^^^^^^^^

If there is a mismatch of the SXL when receiving a CommandRequest or
StatusRequest, which is not caught during communication handshake (See
:ref:`rsmpsxl-version`), then this is considered a serious error resulting in
MessageNotAck.

This include mismatch of:

* status code id (``sCI``)
* command code id (``cId``)
* name (``n``)

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

Unimplemented statuses or commands
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

If a status (``sCI``) or command (``cId``) is unimplemented, the site answers
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
