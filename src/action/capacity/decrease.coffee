#
# Author: Peter K. Lee (peter@corenova.com)
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#

module.exports = (input, resolve, reject) ->
  for k, v of input.capacity
    input.capacity[k] = -v
  pool = @create 'ResourcePool', input
  pool.save()
  .then (res) =>
    (@access 'promise.pools').push res
    resolve 
      result: 'ok'
      message: 'capacity decrease successful'
      'pool-id', res.id
  .catch (e) -> resolve result: 'error', message: e
