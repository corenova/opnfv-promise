#
# Author: Peter K. Lee (peter@corenova.com)
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
#

module.exports = (input, resolve, reject) ->
  # 1. we gather up all collections that match the specified window
  window = input.window
  metric = input.capacity

  collections = switch metric
    when 'total'     then [ 'ResourcePool' ]
    when 'reserved'  then [ 'ResourceReservation' ]
    when 'usage'     then [ 'ResourceAllocation' ]
    when 'available' then [ 'ResourcePool', 'ResourceReservation', 'ResourceAllocation' ]

  matches = collections.reduce ((a, name) =>
    res = @find name,
      start: (value) -> (not window.end?)   or (new Date value) <= (new Date window.end)
      end:   (value) -> (not window.start?) or (new Date value) >= (new Date window.start)
      enabled: true
    a.concat res...
  ), []

  if window.scope is 'exclusive'
    # yes, we CAN query filter in one shot above but this makes logic cleaner...
    matches = matches.where
      start: (value) -> (not window.start?) or (new Date value) >= (new Date window.start)
      end:   (value) -> (not window.end?) or (new Date value) <= (new Date window.end)

  # exclude any identifiers specified
  matches = matches.without id: (input.get 'without')

  if metric is 'available'
    # excludes allocations with reservation property set (to prevent double count)
    matches = matches.without reservation: (v) -> v?

  unless (input['show-utilization']) is true
    return resolve collections: matches

  # 2. we calculate the deltas based on start/end times of each match item
  deltas = matches.reduce ((a, entry) ->
    b = entry.get()
    b.end ?= 'infiniteT'
    [ skey, ekey ] = [ (b.start.split 'T')[0], (b.end.split 'T')[0] ]
    a[skey] ?= count: 0, capacity: {}
    a[ekey] ?= count: 0, capacity: {}
    a[skey].count += 1
    a[ekey].count -= 1

    for k, v of b.capacity when v?
      a[skey].capacity[k] ?= 0
      a[ekey].capacity[k] ?= 0
      if entry.name is 'ResourcePool'
        a[skey].capacity[k] += v
        a[ekey].capacity[k] -= v
      else
        a[skey].capacity[k] -= v
        a[ekey].capacity[k] += v
    return a
  ), {}

  # 3. we then sort the timestamps and aggregate the deltas
  last = count: 0, capacity: {}
  usages = for timestamp in Object.keys(deltas).sort() when timestamp isnt 'infinite'
    entry = deltas[timestamp]
    entry.timestamp = (new Date timestamp).toJSON()
    entry.count += last.count
    for k, v of entry.capacity
      entry.capacity[k] += (last.capacity[k] ? 0)
    last = entry
    entry

  resolve collections: matches, utilization: usages
