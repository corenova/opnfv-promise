DS = require '../stormforge'

class StormForgeAsset extends DS.Model

    name: 'asset'

    schema:
        # an asset MUST belong to a resource
        resource:  DS.belongsTo 'resource', required: true
        instance:  DS.attr 'uuid', required: true
        isActive:  DS.attr 'boolean', defaultValue: false
        ipAddress: DS.attr 'string'

        # will need to map this to stormlight-data-store once ready
        agent: DS.attr 'string', external:true

module.exports = StormForgeAsset
