DS = require '../stormforge'

class ResourcePool extends DS.Model

    providers: @hasMany DS.Provider, required: true

    compute: @computed (->
        DS.Provider.ComputeService.aggregate (provider.get('compute') for provider in @get('providers'))
    )
    storage: @computed (->
        DS.Provider.StorageService.aggregate (provider.get('storage') for provider in @get('providers'))
    )
    netwok: @computed (->
        DS.Provider.NetworkService.aggregate (provider.get('network') for provider in @get('providers'))
    )
    elements: @computed (->
        Array::concat.apply (provider.get('elements') for provider in @get('providers'))
    )

module.exports = ResourcePool
