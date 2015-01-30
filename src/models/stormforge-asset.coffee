###*
  StormForge Asset describes the actual instance properties such as the status, IP Address to reach etc.,
  @module StormForge
  @submodule StormForgeAsset
  @main StormForgeAsset
###

DS = require '../stormforge'

###*
  Asset Contains actual instance details
  @class StormForgeAsset
  @extends DS.Model
###
class StormForgeAsset extends DS.Model

    name: 'asset'

    schema:
        # an asset MUST belong to a resource
###*
  @attribute resource
  @type {StormForgeResource} it belongs to.
  @required
###
        resource:  DS.belongsTo 'resource', required: true
###*
  @attribute instance
  @type {String} UUID of the instance 
  @required
###
        instance:  DS.attr 'uuid', required: true
###*
  @attribute isActive
  @type {Boolean} Active status of the asset
  @default false
###
        isActive:  DS.attr 'boolean', defaultValue: false
###*
  @attribute ipAddress
  @type {String} IP Address of the instance
###
        ipAddress: DS.attr 'string'
###*
  @attribute agent
  @type {String} UUID of the agent this instance belongs to
  @optional
###

        # will need to map this to stormlight-data-store once ready
        agent: DS.attr 'string', external:true

module.exports = StormForgeAsset
