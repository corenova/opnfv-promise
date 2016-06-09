(require 'yang-js').register()

request = require 'superagent'

module.exports = (require '../schema/opnfv-promise.yang').eval

  'opnfv-promise':
    promise:
      capacity:
        total: (->
          combine = (a, b) ->
            for k, v of b.capacity when v?
              a[k] ?= 0
              a[k] += v
            return a
          (@get '../../pools')
          .filter (entry) -> entry.active is true
          .reduce combine, {}
        )
        reserved: (->
          combine = (a, b) ->
            for k, v of b.remaining when v?
              a[k] ?= 0
              a[k] += v
            return a
          (@parent.get 'reservations')
          .filter (entry) -> entry.active is true
          .reduce combine, {}
        )
        usage: (->
          combine = (a, b) ->
            for k, v of b.capacity when v?
              a[k] ?= 0
              a[k] += v
            return a
          (@parent.get 'allocations')
          .filter (entry) -> entry.active is true
          .reduce combine, {}
        )
        available: (->
          total = @get 'total'
          reserved = @get 'reserved'
          usage = @get 'usage'
          for k, v of total when v?
            total[k] -= reserved[k] if reserved[k]?
            total[k] -= usage[k] if usage[k]?
          total
        )

    # RPC Intent Processors
    'create-reservation':
      (input, resolve, reject) ->
        # 1. create the reservation record (empty)
        reservation = @create 'ResourceReservation'
        reservations = @access 'promise.reservations'

        # 2. update the record with requested input
        reservation.update input
        .then (res) ->
          # 3. save the record and add to list
          res.save()
          .then ->
            reservations.push res
            resolve
              result: 'ok'
              message: 'reservation request accepted'
              'reservation-id': res.id
          .catch (err) ->
            resolve result: 'error', message: err
        .catch (err) ->
          resolve result: 'conflict', message: err

    'query-reservation':
      (input, resolve, reject) ->
        input.capacity = 'reserved'
        @['query-capacity'] input
        .then (res) -> resolve res
        .catch (e)  -> reject e

    'update-reservation':
      (input, resolve, reject) ->
        # TODO: we shouldn't need this... need to check why leaf mandatory: true not being enforced
        unless input['reservation-id']?
          return resolve result: 'error', message: "must provide 'reservation-id' parameter"

        # 1. find the reservation
        reservation = @find 'ResourceReservation', input['reservation-id']
        unless reservation?
          return resolve result: 'error', message: 'no reservation found for specified identifier'

        # 2. update the record with requested input
        reservation.update input
        .then (res) ->
          # 3. save the updated record
          res.save()
          .then ->
            resolve result: 'ok', message: 'reservation update successful'
          .catch (err) ->
            resolve result: 'error', message: err
        .catch (err) ->
          resolve result: 'conflict', message: err

    'cancel-reservation':
      (input, resolve, reject) ->
        # 1. find the reservation
        reservation = @find 'ResourceReservation', input['reservation-id']
        unless reservation?
          return resolve result: 'error', message: 'no reservation found for specified identifier'

        # 2. destroy all traces of this reservation
        reservation.destroy()
        .then =>
          (@access 'promise.reservations').remove reservation.id
          resolve result: 'ok', message: 'reservation canceled'
        .catch (e) -> resolve result: 'error', message: e

    'query-capacity':
      (input, resolve, reject) ->
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

    'increase-capacity':
      (input, resolve, reject) ->
        pool = @create 'ResourcePool', input
        pool.save()
        .then (res) =>
          (@access 'promise.pools').push res
          resolve
            result: 'ok'
            message: 'capacity increase successful'
            'pool-id', res.id
        .catch (e) -> resolve result: 'error', message: e

    'decrease-capacity':
      (input, resolve, reject) ->
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

    # TEMPORARY (should go into VIM-specific module)
    'create-instance':
      (input, resolve, reject) ->
        pid = input['provider-id']
        if pid?
          provider = @find 'ResourceProvider', pid
          unless provider?
            return resolve
              result: 'error', message: "no matching provider found for specified identifier: #{pid}"
        else
          provider = (@find 'ResourceProvider')[0]
          unless provider?
            return resolve
              result: 'error', message: "no available provider found for create-instance"

        # calculate required capacity based on 'flavor' and other params
        flavor = provider.access "services.compute.flavors.#{input.get 'flavor'}"
        unless flavor?
          return resolve
            result: 'error', message: "no such flavor found for specified identifier: #{pid}"

        required =
          instances: 1
          cores:     flavor.vcpus
          ram:       flavor.ram
          gigabytes: flavor.disk

        rid = input['reservation-id']
        if rid?
          reservation = @find 'ResourceReservation', rid
          unless reservation?
            return resolve
              result: 'error', message: 'no valid reservation found for specified identifier'
          unless (reservation.get 'active') is true
            return resolve
              result: 'error', message: "reservation is currently not active"
          available = reservation.remaining
        else
          available = @get 'promise/capacity/available'

        # TODO: need to verify whether 'provider' associated with this 'reservation'

        for k, v of required when v? and !!v
          unless available[k] >= v
            return resolve
              result: 'conflict', message: "required #{k}=#{v} exceeds available #{available[k]}"

        @create 'ResourceAllocation',
          reservation: rid
          capacity: required
        .save()
        .then (instance) =>
          url = provider.services.compute.endpoint
          payload =
            server:
              name: input.name
              imageRef: input.image
              flavorRef: input.flavor
          networks = input.networks.filter (x) -> x? and !!x
          if networks.length > 0
            payload.server.networks = networks.map (x) -> uuid: x

          request
            .post "#{url}/servers"
            .send payload
            .set 'X-Auth-Token', provider.token
            .set 'Accept', 'application/json'
            .end (err, res) =>
              if err? or !res.ok
                instance.destroy()
                #console.error err
                return reject res.error
              #console.log JSON.stringify res.body, null, 2
              instance.set 'instance-ref',
                provider: provider
                server: res.body.server.id
              (@access 'promise.allocations').push instance
              resolve
                result: 'ok'
                message: 'create-instance request accepted'
                'instance-id', instance.id
           return instance
        .catch (err) -> resolve result: 'error', mesage: err

    'destroy-instance':
      (input, resolve, reject) ->
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

    # TEMPORARY (should go into VIM-specific module)
    'add-provider':
      (input, resolve, reject) ->
        payload = switch input['provider-type']
          when 'openstack'
            auth:
              tenantId: input.tenant.id
              tenantName: input.tenant.name
              passwordCredentials:
                username: input.username
                password: input.password

        unless payload?
          return reject 'Sorry, only openstack supported at this time'

        url = input.endpoint
        switch input.strategy
          when 'keystone', 'oauth'
            url += '/tokens' unless /\/tokens$/.test url

        providers = @access 'promise.providers'
        request
          .post url
          .send payload
          .set 'Accept', 'application/json'
          .end (err, res) =>
            if err? or !res.ok then return reject res.error
            #console.log JSON.stringify res.body, null, 2
            access = res.body.access
            provider = @create 'ResourceProvider',
              token: access?.token?.id
              name: access?.token?.tenant?.name
            provider.update access.serviceCatalog
            .then (res) ->
              res.save()
              .then ->
                providers.push res
                resolve
                  result: 'ok'
                  'provider-id', res.id
              .catch (err) -> resolve error: message: err
            .catch (err) -> resolve error: message: err

        # @using 'mano', ->
        #   @invoke 'add-provider', (input.get 'endpoint', 'region', 'username', 'password')
        #   .then (res) =>
        #     (@access 'promise.providers').push res
        #     output.set 'result', 'ok'
        #     output.set 'provider-id', res.id
        #     done()

