stormify = require 'stormify'

class StormForge extends stormify.DS
    name: 'stormforge'

    schema:
        resourceProviders: @hasMany require './models/stormforge-resource-provider'
        resourceElements:  @hasMany require './models/stormforge-resource-element'
        resources:         @hasMany require './models/stormforge-resource'
        assets:            @hasMany require './models/stormforge-asset'

module.exports = StormForge
