DS = require '../stormforge'

class StormForgeResource extends DS.Model

    name: @attr 'string', required: true
    provider: @belongsTo DS.ResourceProvider, required:true

    # using the following resource elements that exist in the above provider!
    flavor: @belongsTo DS.ResourceElement
    image: @belongsTo DS.ResourceElement
    networks: @hasMany DS.ResourceElement

    asset: @belongsTo DS.Asset

    # the asset is the actual manifestation of this resource (it can CHANGE!)
    isActive: @computed (->
        try @get('asset').get('isActive') catch then false
    ), property: 'asset.isActive'

module.exports = StormForgeResource
