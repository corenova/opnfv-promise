DS = require '../stormforge'

class ResourceElement extends DS.Model
    type:      DS.attr 'string', required: true
    # must define the provider that has this resource element!
    provider:  @belongsTo DS.Provider, required: true

class ServiceCapacity extends DS.Model
    alias: 'serviceCapacity'


class ProviderService extends DS.Model
    alias: 'providerService'

    @Capacity = ServiceCapacity
    @Element  = ResourceElement

    provider: @belongsTo DS.Provider, required: true
    endpoint: @attr 'string', required: true

    # the following properties must be sub-classed by specific service
    quota:     @belongsTo @Capacity, embedded: true
    usage:     @belongsTo @Capacity, embedded: true, readonly: true
    reserved:  @belongsTo @Capacity, embedded: true, readonly: true
    available: @belongsTo @Capacity, embedded: true, readonly: true

    elements: @hasMany @Element

class ResourceProvider extends DS.Model

    @Service = ProviderService
    @ComputeService  = require './stormforge-compute-service'
    @ImageService    = require './stormforge-image-service'
    @IdentityService = require './stormforge-identity-service'

    name:        DS.attr 'string', required: true
    username:    DS.attr 'string', required: true
    password:    DS.attr 'string', required: true

    endpoint:    DS.attr 'string', required: true
    tenant:      DS.attr 'string', required: true
    regionName:  DS.attr 'string', required: true

    identity: @belongsTo @IdentityService, required: true
    image:    @belongsTo @ImageService, required: true
    compute:  @belongsTo @ComputeService, required: true

    flavors: @hasMany @ResourceFlavor

    # storage: @belongsTo @StorageService
    # network: @belongsTo @NetworkService

    # auto-computed list of all Elements from provider's Services
    elements: @computed (->
        Array::concat.apply (@get(service).get('elements') for service in ['identity', 'image', 'compute'])
    )

module.exports = ResourceProvider


