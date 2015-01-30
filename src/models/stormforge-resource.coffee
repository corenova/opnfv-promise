###*
  StormForge Resoruce contains the details of what makes an asset and its status 
  @module StormForge
  @submodule StormForgeResource
  @main StormForgeResource
###
DS = require '../stormforge'

###*
  Resource Contains details to create an asset
  Note: Asset is the actual manifestation of this resource (it can CHANGE!)
  @class StormForgeResource
  @extends DS.Model
###
class StormForgeResource extends DS.Model

###*
  @attribute name
  @type {String} Name of the resource
  @required
###
    name: @attr 'string', required: true
###*
  @attribute provider
  @type {ResourceProvider} Provider where the asset is brought up
  @required
###
    provider: @belongsTo DS.ResourceProvider, required:true

    # using the following resource elements that exist in the above provider!
###*
  @attribute flavor
  @type {ResourceElement} flavor to use for the asset
  @required
###
    flavor: @belongsTo DS.ResourceElement
###*
  @attribute image
  @type {ResourceElement} Image to use for the asset
  @required
###
    image: @belongsTo DS.ResourceElement
###*
  @attribute networks
  @type {ResourceElement} Networks to use for the asset
  @required
###
    networks: @hasMany DS.ResourceElement
###*
  @attribute asset
  @type {StormForgeAsset} Asset associated with this resource 
###

    asset: @belongsTo DS.Asset

###*
  @method isActive
  @return {Boolean} status of the asset associated with this resource
###
    isActive: @computed (->
        try @get('asset').get('isActive') catch then false
    ), property: 'asset.isActive'

module.exports = StormForgeResource
