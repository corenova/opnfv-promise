#
# Author: Peter K. Lee (peter@corenova.com)
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#

request = require 'superagent'

module.exports = (input, resolve, reject) ->
  # 1. find the instance
  instance = @find 'ResourceAllocation', input['instance-id']
  unless instance?
    return resolve
      result: 'error', message: 'no allocation found for specified identifier'

  # 2. destroy all traces of this instance
  instance.destroy()
  .then =>
    # always remove internally
    (@access 'promise.allocations').remove instance.id
    ref = instance['instance-ref']
    provider = (@access "promise.providers.#{ref.provider}")
    url = provider.services.compute.endpoint
    request
      .delete "#{url}/servers/#{ref.server}"
      .set 'X-Auth-Token', provider.token
      .set 'Accept', 'application/json'
      .end (err, res) =>
        if err? or !res.ok
          console.error err
          return reject res.error
        resolve
          result: 'ok'
          message: 'instance destroyed and resource released back to pool'
    return instance
  .catch (e) -> resolve result: 'error', message: e
