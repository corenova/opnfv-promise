stormforge
==========

A DataStorm to manage instantiation of virtual resources across
providers 

StormForge provides various API-driven services for managing
a Virtualized Infrastructure.

Currently planned key services are:

* Resource Reservation Service
* Resource Capacity Management Service

Primary target Virtualized Infrastructure is OpenStack.

StormForge is created using the
[stormify](http://github.com/stormstack/stormify) data modeling
framework in order to model each Virtualized Infrastructure Service
and flexibly manage each of the running services.

StormForge is used in conjunction with
[StormIO](http://github.com/stormstack/stormio) workflow processing
engine to sequence the necessary southbound API interactions to the
resource provider APIs across Compute, Storage, and Network.

StormForge DataStorm is invoked by using
[stormrunner](http://github.com/stormstack/stormrunner).
