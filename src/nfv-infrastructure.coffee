#
# Author: Peter K. Lee (peter@corenova.com)
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#

require('yang-js').register()

uuid = require 'node-uuid'

module.exports = require('../schema/nfv-infrastructure.yang').bind {
  
  'complex-type:ResourceElement':
    id: -> uuid.v4()

}
