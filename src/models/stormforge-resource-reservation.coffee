DS = require '../stormforge'

class ResourceReservation extends DS.Model

    pool:  @belongsTo DS.Pool

    start: @attr 'date', required: true
    end:   @attr 'date', required: true

    isActive: @attr 'boolean', defaultValue: false

    # reservable element-based reservation (such as images, flavors, etc.)
    elements: @hasMany DS.Provider.Service.Element

    # capacity-based reservation
    compute: @belongsTo DS.Provider.ComputeService.Capacity, embedded: true
    storage: @belongsTo DS.Provider.StorageService.Capacity, embedded: true
    network: @belongsTo DS.Provider.NetworkService.Capacity, embedded: true

    allocations: @hasMany DS.Allocation, readonly: true
    usedCompute: @belongsTo DS.Provider.ComputeService.Capacity, embedded: true, readonly: true
    usedStorage: @belongsTo DS.Provider.StorageService.Capacity, embedded: true, readonly: true
    usedNetwork: @belongsTo DS.Provider.NetworkService.Capacity, embedded: true, readonly: true

module.exports = ResourceReservation
