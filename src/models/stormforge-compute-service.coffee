DS = require '../stormforge'

class ComputeCapacity extends DS.Provider.Service.Capacity
    alias: 'computeCapacity'

    cores:     @attr 'number'
    ram:       @attr 'number'
    instances: @attr 'number'

class Hypervisor extends DS.Model
    alias: 'hypervisor'

    cpu:       @attr 'string'
    workload:  @attr 'number'
    hostname:  @attr 'string'
    type:      @attr 'string'
    ram:       @attr 'number', unit: 'GB'
    ramUsed:   @attr 'number', unit: 'GB'
    ramFree:   @attr 'number', unit: 'MB'
    disk:      @attr 'number', unit: 'GB'
    diskUsed:  @attr 'number', unit: 'GB'
    diskFree:  @attr 'number', unit: 'GB'
    instances: @attr 'number'
    vcpus:     @attr 'number'
    vcpusUsed: @attr 'number'

class ComputeService extends DS.Provider.Service
    alias: 'computeService'

    @aggregate = (computes) ->
        console.log 'hello'

    @Capacity = ComputeCapacity
    @Hypervisor = Hypervisor

    quota:    @belongsTo @Capacity, embedded: true
    usage:    @belongsTo @Capacity, embedded: true, readonly: true
    reserved: @belongsTo @Capacity, embedded: true, readonly: true
    # available = quota - usage - reserved
    available: @computed (-> )

    hypervisors: @hasMany @Hypervisor, readonly: true
    instances:   @hasMany DS.Asset

module.exports = ComputeService
