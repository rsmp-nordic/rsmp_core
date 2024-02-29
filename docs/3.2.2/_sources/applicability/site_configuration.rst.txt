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
In order to uniquely identify an SXL and site configuration for a
supervision system the site id and the version needs to be known.
See :ref:`rsmpsxl-version`. The SXL defines the site id, but meta data is
needed to provide the SXL version.

The site configuration may define a set of meta data of a specific site.
It is defined in the first sheet named "Version" in in the Excel version and at
the very top of the YAML version.

In each SXL there must defined which version of RSMP which it is conforms to.

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
    site-id:
      description: site description
      objects:
        object-type:
          object-1:
            componentId: AA+BBCCC=DDDEEFFF
            ntsObjectId: AA+BBCCC=DDDEEFFF
            externalNtsId: 00000

Where:

* ``site-id`` is the site id. This is needed during initial handshake
* ``site description``. Site description
* ``object-type`` defines which object type the object belongs to
* ``object-1`` is the name of the object. For instance "signal group 1"

An object can either be categorized as a **single object** or **grouped
object**, also known as the main component(s).

The main component(s) is defined by **componentId** and **ntsObjectId** are
being set equal. This means that the object is visible from NTS.

Single objects have a unique **componentId** but uses the **ntsObjectId** of
their main component.

**externalNtsId** and **ntsObjectId** are optional and only used if the
object is intended to be sent to :term:`NTS`.

.. note::
   :term:`NTS` is used at the :term:`STA`. Other road authorities typically
   leaves the `xNid` and `ntsOid` as empty strings.

