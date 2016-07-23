#
# Author: Peter K. Lee (peter@corenova.com)
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#

require('yang-js').register()

module.exports = require('../schema/opnfv-promise.yang').bind {

  '/{temporal-resource-collection}':
    start:  -> (new Date).toJSON()
    active: ->
      now = new Date
      start = new Date (@get '../start')
      end = switch
        when (@get '../end')? then new Date (@get '../end')
        else now
      (@get '../enabled') and (start <= now <= end)

  '/nfvi:stack/prom:capacity':
    total: ->
      combine = (a, b) ->
        for k, v of b.capacity when v?
          a[k] ?= 0
          a[k] += v
        return a
      (@get '/nfvi:stack/prom:pool')
      .filter (entry) -> entry.active is true
      .reduce combine, {}
    reserved: ->
      combine = (a, b) ->
        for k, v of b.remaining when v?
          a[k] ?= 0
          a[k] += v
        return a
      (@get '/nfvi:stack/prom:reservation')
      .filter (entry) -> entry.active is true
      .reduce combine, {}
    usage: ->
      combine = (a, b) ->
        for k, v of b.capacity when v?
          a[k] ?= 0
          a[k] += v
        return a
      (@get '/nfvi:stack/prom:allocation')
      .filter (entry) -> entry.active is true
      .reduce combine, {}
    available: ->
      total    = @get '../total'
      reserved = @get '../reserved'
      usage    = @get '../usage'
      available = {}
      for k, v of total when v?
        available[k] = v
        available[k] -= reserved[k] if reserved[k]?
        available[k] -= usage[k]    if usage[k]?
      available
    elements: -> #todo
    '[action:query]':     require './action/query-capacity'
    '[action:increase]':  require './action/increase-capacity'
    '[action:decrease]':  require './action/decrease-capacity'
  
  '/nfvi:stack/prom:reservation':
    end: ->
      end = (new Date @get 'start')
      max = @get '/nfvi:stack/nfvi:policy/prom:reservation/prom:max-duration'
      return unless max?
      end.setTime (end.getTime() + (max*60*60*1000))
      end.toJSON()
    allocations: ->
      @get "/nfvi:stack/nfvi:compute/nfvi:server[prom:reservation-id = #{@get('../id')}]/id"
    remaining: ->
      total = @get '../capacity'
      records = @get "/nfvi:stack/nfvi:compute/nfvi:server[active = true]"
      #store.find 'ResourceAllocation', id: (@get 'allocations'), active: true
      for entry in records
        usage = entry.capacity
        for k, v of usage
          total[k] -= v
      total
    '[action:validate]': require './action/validate-reservation'
    '[action:create]':   require './action/create-reservation'
    '[action:query]':    require './action/query-reservation'
    '[action:update]':   require './action/update-reservation'
    '[action:cancel]':   require './action/cancel-reservation'

  '/nfvi:stack/nfvi:compute/nfvi:server/prom:priority': ->
    switch
      when not (@get '../reservation-id')? then 3
      when not (@get '../active') then 2
      else 1

    
}
