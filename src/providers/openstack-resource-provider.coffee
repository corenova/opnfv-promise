schema =
  'module openstack-resource-provider':
    prefix: 'orp'

    'import yang-storm': prefix: 'ys'
    'import resource-provider': prefix: 'rp'

    'ys:model-type openstack-resource-provider':
      'ys:inherit': 'rp:resource-provider'
      'augment':
        'leaf tenant': type: 'string'
      'augment services':
        'ys:instance identity': type: 'os-identity-service'
        'ys:instance image': type: 'os-image-service'
        'ys:instance compute': type: 'os-compute-service'

    'ys:model-type os-identity-service':
      'ys:inherit': 'rp:identity-service'

    'ys:model-type os-image-service':
      'ys:inherit': 'rp:image-service'

    'ys:model-type os-compute-service'
      'ys:inherit': 'rp:compute-service'

      # unique element for openstack compute service
      'ys:instance-list hypervisors':
        type: 'hypervisor'
        config: false

      'rpc list-servers':   'ys:exec': -> null
      'rpc create-server':  'ys:exec': -> null
      'rpc destroy-server': 'ys:exec': -> null
      'rpc reboot-server':  'ys:exec': -> null

    'ys:model-type hypervisor':
      'leaf cpu': type: 'number', default: 0
      'leaf workload': type: 'number', default: 0
      'leaf hostname': type: 'string'
      'leaf type': type: 'string'
      'leaf ram': type: 'number', units: 'GB'
      'leaf ram-used': type: 'number', units: 'GB'
      'leaf ram-free': type: 'number', units: 'MB'
      'leaf disk': type: 'number', units: 'GB'
      'leaf disk-used': type: 'number', units: 'GB'
      'leaf disk-free': type: 'number', units: 'GB'
      'leaf instances': type: 'number'
      'leaf vcpus': type: 'number'
      'leaf vcpus-used': type: 'number'

nmodule.exports = (require 'yang-storm').generate schema
