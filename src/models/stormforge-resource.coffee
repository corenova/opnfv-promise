DS = require '../stormforge'

class StormForgeResource extends DS.Model

    name: 'resource'

    schema:
        name:        DS.attr 'string', required: true

        # 1. allocated on 'provider'
        provider:    DS.belongsTo 'resourceProvider', required:true

        # using the following resource elements that exist in the above provider!
        flavor:      DS.belongsTo 'resourceElement'
        image:       DS.belongsTo 'resourceElement'
        networks:    DS.hasMany   'resourceElement'

        # the asset is the actual manifestation of this resource (it can CHANGE!)
        isActive: DS.computed (->
            try @get('asset').get('isActive') catch then false
        ), property: 'asset.isActive'

        asset: DS.belongsTo 'asset'

module.exports = StormForgeResource
