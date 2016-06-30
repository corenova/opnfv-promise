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
