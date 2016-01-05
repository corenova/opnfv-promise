module 'opnfv-promise', ->

  rebind 'promise.capacity.total', (prev) ->
    @computed (->
      combine = (a, b) ->
        for k, v of b.capacity when v?
          a[k] ?= 0
          a[k] += v
        return a
      (@parent.get 'pools')
      .filter (entry) -> entry.active is true
      .reduce combine, {}
    ), type: prev
    
  rebind 'promise.capacity.reserved', (prev) ->
    @computed (->
      combine = (a, b) ->
        for k, v of b.capacity when v?
          a[k] ?= 0
          a[k] += v
        return a
      (@parent.get 'reservations')
      .filter (entry) -> entry.active is true
      .reduce combine, {}
    ), type: prev
    
    # rebind to be a computed property
    promise.capacity.usage: (prev) ->
      @computed (->
        combine = (a, b) ->
          for k, v of b.capacity when v?
            a[k] ?= 0
            a[k] += v
          return a
        (@parent.get 'allocations')
        .filter (entry) -> entry.active is true
        .reduce combine, {}
      ), type: prev
    # rebind to be a computed property
    promise.capacity.available: (prev) ->
      @computed (-> 
        total = @get 'total'
        reserved = @get 'reserved'
        usage = @get 'usage'
        for k, v of total when v?
          total[k] -= reserved[k] if reserved[k]?
          total[k] -= usage[k] if usage[k]?
        total
      ), type: prev

  bind 'create-reservation', ->
    (input, output, done) ->
      # 1. create the reservation record (empty)
      reservation = @create 'ResourceReservation'
      reservations = @access 'promise.reservations'

      # 2. update the record with requested input
      reservation.invoke 'update', input.get()
      .then (res) ->
        # 3. save the record and add to list
        res.save()
        .then ->
          reservations.push res
          output.set result: 'ok', message: 'reservation request accepted'
          output.set 'reservation-id', res.id
          done()
        .catch (err) ->
          output.set result: 'error', message: err
          done()
      .catch (err) -> 
        output.set result: 'conflict', message: err
        done()
