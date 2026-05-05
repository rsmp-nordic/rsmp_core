.. _site-configuration:

Site configuration
==================
A site configuration defines the individual components that exists
in a specific site. It also defines the relationship between those components.

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

In each SXL it must defined which version of RSMP it conforms to.

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


Components
----------
A site consists of components, identified by unique component ids (``cId``).

Using the Excel format; components are defined in it's own sheet - one for each
site.
Using the YAML format, each component is defined like this:

.. code-block:: yaml

  sites:
    <site-id>:
      description: site description
      components:
        <component-type>:
          <component-1>:
            componentId: AA+BBCCC=DDDEEFFF

Where:

* ``<site-id>`` is the site id. This is needed during initial handshake
* ``description``. Site description
* ``<component-type>`` defines which component type the component belongs to
* ``<component-1>`` is the name of the component. For instance "signal group 1"
* ``componentId`` is the :ref:`Component-id`

The site must have exactly one main component.

