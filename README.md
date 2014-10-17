stormforge
==========

Extensible VIM Services


StormForge provides various API-driven services for managing
a Virtualized Infrastructure.

Currently planned key services are:

* Resource Reservation Service
* Resource Capacity Management Service

Primary target Virtualized Infrastructure is OpenStack.

StormForge enables plugin-based services extension capability to model
each Virtualized Infrastructure Service and flexibly manage each of the
running services.

StormForge leverages [CloudIO](http://github.com/stormstack/cloudio)
workflow processing engine to sequence the necessary southbound API
interactions to the resource provider APIs across Compute, Storage,
and Network.

