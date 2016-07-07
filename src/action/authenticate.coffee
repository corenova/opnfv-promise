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

