.. _site-configuration:

Site configuration
==================
A site configuration defines the individual components that exists
in a specific site. It also defines the relationship between those components.

The site configuration is defined using YAML format.

Components
----------
A site consists of components, identified by unique component ids (``cId``).

Each component is defined like this:

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

