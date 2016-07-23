#
# Author: Peter K. Lee (peter@corenova.com)
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#

require('yang-js').register()

module.exports = require('../schema/openstack-core.yang').bind {

  # Intent Processor bindings
  '/create-instance':  require './rpc/create-instance'
  '/destroy-instance': require './rpc/destroy-instance'
  '/authenticate':     require './rpc/authenticate'
    
}
