
schema =
  'module stormforge-models':
    prefix: 'sfm'

    'import yang-storm': prefix: 'ys'

    'include resource-provider':
      'ys:source': -> (require './providers/resource-provider')

    'include openstack-resource-provider':
      'ys:source': -> (require './providers/openstack-resource-provider')

    'ys:model-type resource-pool':
      'ys:instance-list providers': type: 'resource-provider'

      'container services':
        'ys:instance compute':
          type: 'compute-service'
          'ys:computed': ->
            # aggregate all compute-service data models into a single entry

        'ys:instance storage':
          type: 'storage-service'
          'ys:computed': ->
            # aggregate all storage-service data models into a single entry

        'ys:instance network':
          description: """

            An aggregate representation of all 'network-service' data
            models available across 'providers'

          """
          type: 'network-service'
          'ys:computed': -> null

      'ys:instance-list elements':
        type: 'resource-element'
        'ys:computed': ->
          Array::concat.apply null, (provider.get('elements') for provider in @get('providers'))

    'ys:model-type resource-reservation':
      'ys:instance pool': type: 'resource-pool'
      'leaf start': type: 'date-and-time'
      'leaf end': type: 'date-and-time'
      'leaf priority': type: 'number', config: false

      #'leaf token': type: 'uuid', config: false, 'ys:private': true

      'container request':
        description: """

          The request should contain the capacities of various
          resource services being reserved along with any resource
          elements needed to be available at the time of
          allocation(s).

          Optionally, a list of allocations can be specified, which
          will take effect automatically at the time of reservation
          'start' date/time if the reservation request is accepted.

          """
        'container capacity':
          'container compute': uses: 'compute-capacity'
          'container storage': uses: 'storage-capacity'
          'container network': uses: 'network-capacity'
        'ys:instance-list elements': type: 'resource-element'
        'ys:instance-list allocations': type: 'resource-allocation'

      'container consumed':
        description: """

          Provides visibility into total consumed capacity for this
          reservation based on allocations that took effect utilizing
          this reservation ID as a reference.

          """
        'container capacity':
          'container compute': uses: 'compute-capacity', config: false
          'container storage': uses: 'storage-capacity', config: false
          'container network': uses: 'network-capacity', config: false
        'ys:instance-list allocations': type: 'resource-allocation', config: false

    'ys:model-type allocation-description':
      'leaf name': type: 'string', 'ys:required': true
      'ys:instance provider': type: 'resource-provider'
      'ys:instance flavor': type: 'resource-element', 'ys:validator': (value) ->
        (@get 'provider.elements').contains id: value
      'ys:instance image': type: 'resource-element', 'ys:validator': (value) ->
        (@get 'provider.elements').contains id: value
      'ys:instance-list networks': type: 'resource-element'

    'ys:model-type resource-allocation':
      'ys:instance reservation': type: 'resource-reservation'


module.exports = (require 'yang-storm').generate schema
