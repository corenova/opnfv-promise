# stormforge

A YANG-STORM module for building and signing new YS modules with STORM
abstraction data models.

  [![NPM Version][npm-image]][npm-url]
  [![NPM Downloads][downloads-image]][downloads-url]

## Installation
```bash
$ npm install stormforge
```
## Documentation

* [stormforge schema](./stormforge.yang)
* [stormforge module](./stormforge.litcoffee)

## Built-in Common Schemas
* [storm-common-models](schemas/storm-common-models.yang)
  * [storm-management-models](schemas/storm-management-models.yang)
  * [storm-resource-models](schemas/storm-resource-models.yang)
    * [storm-resource-abstract-models](schemas/storm-resource-abstract-models.yang)
	* [storm-resource-identity-models](schemas/storm-resource-identity-models.yang)
	* [storm-resource-compute-models](schemas/storm-resource-compute-models.yang)
	* [storm-resource-network-models](schemas/storm-resource-network-models.yang)
  * [storm-service-models](schemas/storm-service-models.yang)

## Dependencies

This module has primary dependency on the `yang-storm` module which
provides `compile` routine that accepts a YANG schema as input and
generates STORM data model class hierarchy (based on `data-storm` module).

* [yang-storm](http://github.com/stormstack/yang-storm)
  * [data-storm](http://github.com/stormstack/data-storm)
    * [meta-class](http://github.com/stormstack/meta-class)
  * [yang-compiler](http://github.com/stormstack/yang-compiler)
    * [yang-parser](https://www.npmjs.com/package/yang-parser)

## Additional YS modules

Eventually these modules will be split into their own respective
project repositories but for the time being they will be hosted
together with the `stormforge` module.

module | description | status
--- | --- | ---
[opnfv-promise](ys_modules/opnfv-promise) | provide resource | reservation and capacity management | modeling complete
[openstack](ys_modules/openstack) | openstack specific VIM extension | modeling incomplete
[hp-helion](ys_modules/hp-helion) | hp-helion specific VIM extension | planned for future
[multi-vim](ys_modules/multi-vim) | multiple VIM abstraction layer | planned for future

## License
  [MIT](LICENSE)

[npm-image]: https://img.shields.io/npm/v/stormforge.svg
[npm-url]: https://npmjs.org/package/stormforge
[downloads-image]: https://img.shields.io/npm/dm/stormforge.svg
[downloads-url]: https://npmjs.org/package/stormforge
