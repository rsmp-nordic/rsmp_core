.. _site-configuration:

Site configuration
==================

A site configuration defines the individual objects (or components) that exists
in a specific site. It also defines the relationship between those objects.

The site configuration can either be defined as a separate YAML file or be
combined with the YAML file of the SXL when needed. The Excel file always
combines the SXL and the site configuration.

Meta data
---------
The site configuration may define a set of meta data of a specific site.
It is defined in the first sheet named "Version" in in the Excel version and at
the very top of the YAML version.

It contains:

.. table:: meta data

   ================= ================
   Excel             YAML
   ================= ================
   Plant id          ``id``
   Plant name        ``description``
   Constructor       ``constructor``
   Reviewed          *(not used)*
   Approved          *(not used)*
   Created date      ``created-date``
   SXL revision [#]_ ``version``
   RSMP version      ``rsmp-version``
   ================= ================

.. rubric:: Footnotes

.. [#] Revision number and Revision date


Objects
-------

A site consists of objects, identified by unique component ids (``cId``).

Using the Excel format; objects are defined in it's own sheet - one for each
site.
Using the YAML format, each object is defined lite this:

.. code-block:: yaml

  sites:
    [site-id]:
      description: [site description]
      objects:
        [object type]:
          [object-1]:
            componentId: AA+BBCCC=DDDEEFFF
            ntsObjectId: AA+BBCCC=DDDEEFFF
            externalNtsId: 00000

Where:

* ``[site-id]`` is the site id. This is needed during initial handshake
* ``[site description]``. Site description
* ``[object-type]`` defines which object type the object belongs to
* ``[object-1]`` is the name of the object. For instance "signal group 1"

An object can either be categorized as a **single object** or **grouped
object**. There must be at least one grouped object which is typically also
the main component. Grouped objects are defined by **componentId** and
**ntsObjectId** are being set equal. Single objects have a unique
**componentId** but uses the **ntsObjectId** of their main component.

**externalNtsId** is optional and only used if the object is intended to
be sent to :term:`NTS`.

