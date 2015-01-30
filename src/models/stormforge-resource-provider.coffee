###*
 @module StormForge
 @submodule ResourceProvider
 @main ResourceProvider
###

DS = require '../stormforge'

###*
 Builds a relation between resource element with Resource Provider
 @class ResourceElement
 @extends DS.Model
###
class ResourceElement extends DS.Model
###*
 @attribute type
 @type {String} Type of the resource element
 @required
###
    type:      DS.attr 'string', required: true
    # must define the provider that has this resource element!
###*
 @attribute provider
 @type {ResourceProvider} mapping of the resource to the provider
 @required
###
    provider:  @belongsTo DS.Provider, required: true

###*
 @class ServiceCapacity
 @extends DS.Model
###
class ServiceCapacity extends DS.Model
    alias: 'serviceCapacity'


###*
 @class ProviderService
 @extends DS.Model
###
class ProviderService extends DS.Model
    alias: 'providerService'

    @Capacity = ServiceCapacity
    @Element  = ResourceElement

###*
 @attribute provider
 @type {ResourceProvider} mapping of the resource to the provider
 @required
###
    provider: @belongsTo DS.Provider, required: true
###*
 @attribute endpoint
 @type {String} Endpoint to reach the provider service
 @required
###
    endpoint: @attr 'string', required: true

    # the following properties must be sub-classed by specific service
###*
 @attribute quota
 @type {ServiceCapacity} quota capacity of the provider service
###
    quota:     @belongsTo @Capacity, embedded: true
###*
 @attribute usage
 @type {ServiceCapacity} usage capacity of the provider service
 @readonly
###
    usage:     @belongsTo @Capacity, embedded: true, readonly: true
###*
 @attribute reserved
 @type {ServiceCapacity} reserved capacity of the provider service
 @readonly
###
    reserved:  @belongsTo @Capacity, embedded: true, readonly: true
###*
 @attribute available
 @type {ServiceCapacity} available capacity of the provider service
 @readonly
###
    available: @belongsTo @Capacity, embedded: true, readonly: true
###*
 @attribute elements
 @type {ResourceElement} List of elements of the provider service
###

    elements: @hasMany @Element

###*
 @class ResourceProvider
 @extends DS.Model
###
class ResourceProvider extends DS.Model

    @Service = ProviderService
    @ComputeService  = require './stormforge-compute-service'
    @ImageService    = require './stormforge-image-service'
    @IdentityService = require './stormforge-identity-service'

###*
 @attribute name
 @type {String} name of the resource provider
 @required
###
    name:        DS.attr 'string', required: true
###*
 @attribute username
 @type {String} username for the resource provider
 @required
###
    username:    DS.attr 'string', required: true
###*
 @attribute password
 @type {String} password for the resource provider
 @required
###
    password:    DS.attr 'string', required: true
###*
 @attribute endpoint
 @type {String} Endpoint to reach resource provider
 @required
###

    endpoint:    DS.attr 'string', required: true
###*
 @attribute tenant
 @type {String} tenant in the resource provider
 @required
###
    tenant:      DS.attr 'string', required: true
###*
 @attribute regionName
 @type {String} region name of the resource provider
 @required
###
    regionName:  DS.attr 'string', required: true
###*
 @attribute identity
 @type {IdentityService} Identity details of resource provider
 @required
###

    identity: @belongsTo @IdentityService, required: true
###*
 @attribute image
 @type {ImageService} Image Service details of the resource provider
 @required
###
    image:    @belongsTo @ImageService, required: true
###*
 @attribute compute
 @type {ComputeService} Compute Service details of the resource provider
 @required
###
    compute:  @belongsTo @ComputeService, required: true

###*
 @attribute flavors
 @type {ResourceFlavor} flavors to use with this resource provider
 @required
###
    flavors: @hasMany @ResourceFlavor

    # storage: @belongsTo @StorageService
    # network: @belongsTo @NetworkService

    # auto-computed list of all Elements from provider's Services
###*
  @method elements
  @return {ResourceElement} List of resource elements in this resource provider
###
    elements: @computed (->
        Array::concat.apply (@get(service).get('elements') for service in ['identity', 'image', 'compute'])
    )

module.exports = ResourceProvider


