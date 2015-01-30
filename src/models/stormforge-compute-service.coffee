###*
 @module StormForge
 @submodule ResourceProvider
###
DS = require '../stormforge'

###*
 Capacity of the compute in cores, ram and instances
 @class ComputeCapacity
###
class ComputeCapacity extends DS.Provider.Service.Capacity
    alias: 'computeCapacity'
###*
 @attribute cores
 @type {Number} cores in the compute
###
    cores:     @attr 'number'
###*
 @attribute ram
 @type {Number} Total RAM in the compute
###
    ram:       @attr 'number'
###*
 @attribute instances
 @type {Number} instances running in the compute
###
    instances: @attr 'number'

###*
 Contains Hypervisor details
 @class Hypervisor
###
class Hypervisor extends DS.Model
    alias: 'hypervisor'

###*
 @attribute cpu
 @type {Number} Total number of CPU cores 
###
    cpu:       @attr 'number'
###*
 @attribute workload
 @type {Number} current workload of the hypervisor
###
    workload:  @attr 'number'
###*
 @attribute hostname
 @type {String} hostname of the hypervisor
###
    hostname:  @attr 'string'
###*
 @attribute type
 @type {String} type of the hypervisor
###
    type:      @attr 'string'
###*
 @attribute ram
 @type {Number} Total RAM in GB
###
    ram:       @attr 'number', unit: 'GB'
###*
 @attribute ramUsed
 @type {Number} Total RAM in GB used
###
    ramUsed:   @attr 'number', unit: 'GB'
###*
 @attribute ramFree
 @type {Number} Total RAM in GB free
###
    ramFree:   @attr 'number', unit: 'MB'
###*
 @attribute disk
 @type {Number} Total disk in GB
###
    disk:      @attr 'number', unit: 'GB'
###*
 @attribute diskUsed
 @type {Number} Total disk in GB used
###
    diskUsed:  @attr 'number', unit: 'GB'
###*
 @attribute diskFree
 @type {Number} Total disk iin GB free
###
    diskFree:  @attr 'number', unit: 'GB'
###*
 @attribute instances
 @type {Number} Total number of instances running
###
    instances: @attr 'number'
###*
 @attribute vcpus
 @type {Number} Total number of VCPUs 
###
    vcpus:     @attr 'number'
###*
 @attribute vcpusUsed
 @type {Number} Total number of VCPUs used
###
    vcpusUsed: @attr 'number'

###*
 Describes Compute Service
 @class ComputeService
 @extends ProviderService
###
class ComputeService extends DS.Provider.Service
    alias: 'computeService'

    @aggregate = (computes) ->
        console.log 'hello'

    @Capacity = ComputeCapacity
    @Hypervisor = Hypervisor

###*
 @attribute quota
 @type {ComputeCapacity} Compute Quota 
###
    quota:    @belongsTo @Capacity, embedded: true
###*
 @attribute usage
 @type {ComputeCapacity} Compute Usage
###
    usage:    @belongsTo @Capacity, embedded: true, readonly: true
###*
 @attribute reserved
 @type {ComputeCapacity} Compute Reserved
###
    reserved: @belongsTo @Capacity, embedded: true, readonly: true
###*
 @method available
 @return {ComputeCapacity} Available compute capacity
###
    # available = quota - usage - reserved
    available: @computed (-> )
###*
 @attribute hypervisors
 @type {Hypervisor} list of hypervisors
###

    hypervisors: @hasMany @Hypervisor, readonly: true
###*
 @attribute instances
 @type {StormForgeAsset} list of instances
###
    instances:   @hasMany DS.Asset

module.exports = ComputeService
