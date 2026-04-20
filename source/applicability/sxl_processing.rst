.. _sxl_processing:

SXL Processing
--------------
Before an SXL or site SXL list is published or updated, dependencies must be resolved.

If successful, a manifest is created which lists all SXLs with exact versions, including dependencies.

SXL processing should be done using appropriate tool which reads SXL definitions,
resolves dependencies, checks for symbol clashes and creates manifests.

.. _sxl-dependency-resolution:

SXL Dependency Resolution
^^^^^^^^^^^^^^^^^^^^^^^^^
Dependency resolution establishes a set of exact SXL versions that satisfy all version requirements.

Dependency resolution can be performed either on a single SXL, or on a site SXL list.

Dependency order is ignored. All requirements (including transitive requirements) are collected recursively.
The highest SemVer-compatible version for each SXL is then selected deterministically.

If any version requirement is unsatisfiable or a cyclic dependency is detected, resolution fails.

.. _sxl-clash-check:

SXL Conflicts
^^^^^^^^^^^^^
Once a set of exact SXL version have been established by dependency resolution, a check must be performed
to validate that there are no clashing component types or message codes between the SXLs in the set.

.. _sxl-manifest:

SXL Manifest
^^^^^^^^^^^^
If dependency resolution and conflict check succeeds, a manifest is created.

A manifest lists the set of SXLs at exact versions that satisfy all version requirements,
and is guaranteed not to have any conflicting component types or message codes.

SXLs are listed using their names and exact versions, and must be ordered by name according to natural sorting.

.. code-block:: yaml

  meta:
    created_at: 2025-01-05T12:00:00Z
    created_by: sxl-tool v1.0.0
    format: 3.3.0
  sxls:
    public_priority: 2.1.0
    traffic_light_controller: 1.3.0
    traffic_light_controller_advanced: 1.0.0

The ``meta`` section contains metadata about the manifest itself, including:
- ``created_at`` is the timestamp when the manifest was created
- ``created_by`` is the tool and version used to create the manifest
- ``format`` is the RSMP core version that the manifest conforms to

The ``sxls`` section lists the SXLs with their names and exact versions, ordered by name according to natural sorting.
When publishing an SXL, a valid manifest must be included.

For an SXL, the manifest must be published together with the SXL.

For a site, the manifest is not published directly. 
Instead the SXL list reflecting the manifest is included as part of the Version message sent during the connection handshake.
