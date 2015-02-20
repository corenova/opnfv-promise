###*
#  Provides the VIM Extensibe services
#  @module stormforge
#  @main stormforge
###
schema =
  'module stormforge':
    prefix: 'sf'

    'import yang-storm': prefix: 'ys'
    'import stormforge-models':
      prefix: 'sfm'
      'ys:source': -> (require './stormforge-models')

    'ys:instance-list resource-providers': type: 'sfm:resource-provider'
    'ys:instance-list provider-services': type: 'sfm:provider-service'
    'ys:instance-list resource-pools': type: 'sfm:resource-pool'
    'ys:instance-list resource-reservations': type: 'sfm:resource-reservation'

module.exports = (require 'yang-storm').generate schema
