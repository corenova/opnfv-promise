stormify = require 'stormify'

class StormForge extends stormify.DS
    alias: 'stormforge'

    @Provider = require './models/stormforge-resource-provider'
    @Pool = require './models/stormforge-resource-pool'
    @Reservation = require './models/stormforge-resource-reservation'

    @Resource = require './models/stormforge-resource'
    @Asset = require './models/stormforge-asset'

    resourceProviders: @hasMany @Provider
    providerServices:  @hasMany @Provider.Service
    resourceElements:  @hasMany @Provider.Service.Element
    resourcePools:     @hasMany @Pool
    reservations:      @hasMany @Reservation

    resources:         @hasMany @Resource
    assets:            @hasMany @Asset

module.exports = StormForge

