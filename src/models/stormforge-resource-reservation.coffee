###*
  Resource reservation data model
  @module StormForge
  @submodule ResourceReservation
  @main ResourceReservation
###
DS = require '../stormforge'

###*
  The reservation definition
  @class ResourceReservation
  @extends DS.Model
###
class ResourceReservation extends DS.Model

###*
  @attribute pool
  @type {ResourcePool} it belongs to.
###
    pool:  @belongsTo DS.ResourcePool

###*
  @attribute start
  @type {Date} Start date for this reservation
  @required
###
    start: @attr 'date', required: true
###*
  @attribute end
  @type {Date} End date for this reservation
  @required
###
    end:   @attr 'date', required: true

###*
  @attribute isActive
  @type {Boolean} Status of this reservation
  @default false
###
    isActive: @attr 'boolean', defaultValue: false

###*
  reservable element-based reservation (such as images, flavors, etc.)
  @attribute elsements
  @type {ResourceElement} List of resource Elements for this provider
###
    elements: @hasMany DS.Provider.Service.Element

###*
  capacity-based reservation
  @attribute compute
  @type {ComputeCapacity} Capacity of compute resources to use
###
    compute: @belongsTo DS.Provider.ComputeService.Capacity, embedded: true
###*
  capacity-based reservation
  @attribute storage
  @type {StorageCapacity} Capacity of Storage resources to use
###
    storage: @belongsTo DS.Provider.StorageService.Capacity, embedded: true
###*
  capacity-based reservation
  @attribute network
  @type {NetworkCapacity} Capacity of Network resources to use
###
    network: @belongsTo DS.Provider.NetworkService.Capacity, embedded: true

###*
  @attribute allocations
  @type {ResourceAllocation} Resources allocated for this reservation
  @readonly
###
    allocations: @hasMany DS.Allocation, readonly: true
###*
  @attribute usedCompute
  @type {ComputeCapacity} Compute capacity used for this reservation
  @readonly
###
    usedCompute: @belongsTo DS.Provider.ComputeService.Capacity, embedded: true, readonly: true
###*
  @attribute usedStorage
  @type {StorageCapacity} Storage capacity used for this reservation
  @readonly
###
    usedStorage: @belongsTo DS.Provider.StorageService.Capacity, embedded: true, readonly: true
###*
  @attribute usedNetwork
  @type {NetworkCapacity} Network capacity used for this reservation
  @readonly
###
    usedNetwork: @belongsTo DS.Provider.NetworkService.Capacity, embedded: true, readonly: true

module.exports = ResourceReservation
