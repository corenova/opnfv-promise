#
# Author: Peter K. Lee (peter@corenova.com)
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#

require('yang-js').register()

module.exports = require('../schema/opnfv-promise-openstack.yang').bind {

  # Intent Processor bindings
  'rpc:create-instance':  require './rpc/create-instance'
  'rpc:destroy-instance': require './rpc/destroy-instance'
  'rpc:authenticate':     require './rpc/authenticate'
    
}
