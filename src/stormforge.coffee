###*
 Provides the VIM Extensibe services
 @module StormForge
 @main StormForge

###
stormify = require 'stormify'

###*
 @class StormForge
 @constructor



###
class StormForge extends stormify.DS
    alias: 'stormforge'

    @Provider = require './models/stormforge-resource-provider'
    @Pool = require './models/stormforge-resource-pool'
    @Reservation = require './models/stormforge-resource-reservation'

    @Resource = require './models/stormforge-resource'
    @Asset = require './models/stormforge-asset'

###*
    Contains APIs for Resource Providers
    @attribute resourceProviders
    @type ResourceProvider
    @default none
    @example
        POST /stormforge/resourceProviders
###
    resourceProviders: @hasMany @Provider
###*
    Contains APIs for Resource Provider Services
    @attribute providerServices
    @type ProviderService
    @default none
###
    providerServices:  @hasMany @Provider.Service
###*
    Contains APIs for Resource Elements
    @attribute resourceElements
    @type ResourceElement 
    @default none
###
    resourceElements:  @hasMany @Provider.Service.Element
###*
    Contains APIs for  Resource Pools
    @attribute resourcePools
    @type ResourcePool
    @default none
###
    resourcePools:     @hasMany @Pool
###*
    Contains APIs for reservations
    @attribute reservations
    @type ResourceReservation
    @default none
###
    reservations:      @hasMany @Reservation
###*
    Contains APIs foro Resources
    @attribute resources
    @type StormForgeResource
    @default none
###

    resources:         @hasMany @Resource
###*
    Contains APIs for Assets
    @attribute assets
    @type StormForgeAsset
    @default none
###
    assets:            @hasMany @Asset

module.exports = StormForge

