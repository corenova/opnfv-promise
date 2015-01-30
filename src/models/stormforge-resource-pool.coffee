###*
  A pool of resources from various Resource Providers
  @module StormForge
  @submodule StormForgeResource
###
DS = require '../stormforge'

###*
  @class ResourcePool
  @extends DS.Model
###
class ResourcePool extends DS.Model

###*
  @attribute providers
  @type {ResourceProvider} List of Resource Providers for this pool
  @required
###
    providers: @hasMany DS.Provider, required: true

###*
  @method compute
  @return {ComputeService} Aggregated  Compute resources in this pool
###
    compute: @computed (->
        DS.Provider.ComputeService.aggregate (provider.get('compute') for provider in @get('providers'))
    )
###*
  @method storage
  @return {StorageService} Aggregated  Storage resources in this pool
###
    storage: @computed (->
        DS.Provider.StorageService.aggregate (provider.get('storage') for provider in @get('providers'))
    )
###*
  @method network
  @return {NetworkService} Aggregated  Network resources in this pool
###
    netwok: @computed (->
        DS.Provider.NetworkService.aggregate (provider.get('network') for provider in @get('providers'))
    )
###*
  @method elements
  @return {ResourceElement} Aggregated  resources in this pool
###
    elements: @computed (->
        Array::concat.apply (provider.get('elements') for provider in @get('providers'))
    )

module.exports = ResourcePool
