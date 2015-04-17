# stormforge module

The `stormforge` module is a Yang schema derived module that is
compiled by the
[yang-compiler](http://github.com/stormstack/yang-compiler) using the
[yang-storm](http://github.com/stormstack/yang-storm) extension to
produce STORM data model driven complex-types and instances.

This module presents collection of Virtualized Infrastructure Manager
resource entity data models as defined under guidance of [OPNFV
Promise](http://wiki.opnfv.org/promise) project. You can refer to the
[stormforge YANG schema](../schemas/stormforge.yang) for additional
details about this module.

* [OPNFV Promise Models](../schemas/opnfv-promise-models.yang)

## Compiling the new stormforge module

    compiler = (require 'yang-compiler').configure ->
      @use (require 'yang-storm')
      @set 'schemadir', (require 'path').resolve __dirname, '../schemas'
      
    output = compiler.compile (compiler.readSchema 'stormforge.yang')

    module.exports = output
