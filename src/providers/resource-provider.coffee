###*
# @module stormforge
# @submodule resource-provider
# @main resource-provider
###
schema =
  'module resource-provider':
    prefix: 'rp'

    'import yang-storm': prefix: 'ys'

    'ys:model-type resource-provider':

      'leaf name': type: 'string', 'ys:required': true
      'leaf endpoint': type: 'uri'
      'leaf tenant': type: 'string'
      'leaf region': type: 'string'

      'container credentials':
        'ys:required': true
        'ys:private': true
        'leaf username': type: 'string'
        'leaf password': type: 'string'

      'container services':
        description: 'Conceptual container that will be extended by explicit provider'

      'ys:instance-list flavors': type: 'resource-flavor'
      'ys:instance-list elements':
        type: 'resource-element'
        'ys:computed': ->
          Array::concat.apply null, (service.get "elements") for name, service of (@get 'services')

    'ys:model-type provider-service':
      'ys:instance provider': type: 'resource-provider'
      'leaf endpoint': type: 'uri', 'ys:required': true
      'container capacity':
        'container quota': description: 'Conceptual container that should be extended', config: false
        'container usage': description: 'Conceptual container that should be extended', config: false
        'container reserved': description: 'Conceptual container that should be extended', config: false
        'container available': description: 'Conceptual container that should be extended', config: false
      'ys:instance-list elements': type: 'resource-element'

    'ys:model-type compute-service':
      'ys:inherit': 'provider-service'
      'augment capacity':
        'augment quota': uses: 'compute-capacity'
        'augment usage': uses: 'compute-capacity'
        'augment reserved': uses: 'compute-capacity'
        'augment available':
          uses: 'compute-capacity',
          'ys:computed': ->
            #available = quota - usage - reserved
      'ys:instance-list instances':
        type: 'compute-instance', config: false
        'ys:crud': true
        'ys:computed': -> @invoke 'list-servers'

    'ys:model-type compute-instance':
      'leaf created-on': type: 'date-and-time'
      'leaf instance-id': type: 'uuid'
      'leaf ip-address': type: 'ip'

    'ys:model-type service-capacity':
      'leaf timestamp': type: 'date-and-time'

    'ys:model-type compute-capacity':
      'ys:inherit': 'service-capacity'
      'leaf cores': type: 'number', default: 0
      'leaf ram': type: 'number', default: 0
      'leaf instances': type: 'number', default: 0

    'ys:model-type resource-element':
      'ys:instance provider': type: 'resource-provider'
      'leaf type': type: 'string', 'ys:required': true

module.exports = (require 'yang-storm').generate schema
