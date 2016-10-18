#
# Author: Peter K. Lee (peter@corenova.com)
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#

require 'yang-js'

module.exports = require('../schema/opnfv-promise.yang').bind {

  '/{temporal-resource-collection}':
    start:  -> @content ?= (new Date).toJSON()
    active: ->
      now = new Date
      start = new Date (@get '../start')
      end = switch
        when (@get '../end')? then new Date (@get '../end')
        else now
      @content = (@get '../enabled') and (start <= now <= end)

  '/nfvi:controller/promise:capacity':
    total: ->
      combine = (a, b) ->
        for k, v of b.capacity when v?
          a[k] ?= 0
          a[k] += v
        return a
      @content = (@get 'pool[active = true]').reduce combine, {}
    reserved: ->
      combine = (a, b) ->
        for k, v of b.remaining when v?
          a[k] ?= 0
          a[k] += v
        return a
      @content = (@get 'reservation[active = true]').reduce combine, {}
    usage: ->
      combine = (a, b) ->
        for k, v of b.capacity when v?
          a[k] ?= 0
          a[k] += v
        return a
      (@get '/nfvi:controller/promise:allocation')
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
      @content = available
    elements: -> #todo
    
    increase:  require './action/capacity/increase'
    decrease:  require './action/capacity/decrease'
    reserve:   require './action/capacity/reserve'
    query:     require './action/capacity/query'
  
  '/nfvi:controller/promise:capacity/promise:reservation':
    end: ->
      end = (new Date @get 'start')
      max = @get '/nfvi:controller/nfvi:policy/promise:reservation/promise:max-duration'
      return unless max?
      end.setTime (end.getTime() + (max*60*60*1000))
      @content = end.toJSON()
    allocations: ->
      @content = @get "/nfvi:controller/nfvi:compute/nfvi:server[opnfv-promise:reservation-id = #{@get('../id')}]/id"
    remaining: ->
      total = @get '../capacity'
      records = @get "/nfvi:controller/nfvi:compute/nfvi:server[active = true]"
      for entry in records
        usage = entry.capacity
        for k, v of usage
          total[k] -= v
      @content = total
    validate: require './action/reservation/validate'
    update:   require './action/reservation/update'

  '/nfvi:controller/nfvi:compute/nfvi:server/promise:priority': ->
    @content = switch
      when not (@get '../reservation-id')? then 3
      when not (@get '../active') then 2
      else 1
    
}
