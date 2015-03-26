# stormforge module

The `stormforge` module is a Yang schema derived module that is
compiled by the [yang-storm](http://github.com/stormstack/yang-storm)
compiler to produce STORM data model driven complex-types and
instances.

This module presents collection of Virtualized Infrastructure Manager
resource entity data models as defined under guidance of [OPNFV
Promise](http://wiki.opnfv.org/promise) project. You can refer to the
[stormforge YANG schema](../schemas/stormforge.yang) for additional
details about this module.

* [OPNFV Promise Models](../schemas/opnfv-promise-models.yang)

## Compiling the new stormforge module

    path = require 'path'
    schemas = (path.resolve __dirname, '../schemas')

    compiler = require 'yang-compiler'
    compiler.merge (require 'yang-storm')
      
    schema = (require 'fs').readFileSync (path.join schemas, 'stormforge.yang'), 'utf-8'
    output = compiler.compile schema, sourcedir: schemas

    module.exports = output
