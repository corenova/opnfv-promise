config = require 'config'
assert = require 'assert'
forge  = require 'yangforge'
app = forge.load '!yaml ../promise.yaml', async: false, pkgdir: __dirname

describe "promise", ->
  ctx =
    provider: id: undefined
    pool: id: undefined

  describe "register openstack into resource pool", ->
    before ->
      try
        config.get 'openstack.auth.credentials.password'
      catch e
        throw new Error "missing OpenStack environmental variables, particularly OS_PASSWORD"
      app.set config

    describe "add-provider", ->
      it "should add a new OpenStack provider without error", (done) ->
        @timeout 5000

        os = config.get 'openstack'
        payload =
          'provider-type': 'openstack'
          endpoint: "#{os.auth.url}/tokens"
          tenant: id: os.auth.tenant.id, name: os.auth.tenant.name
          username: os.auth.credentials.username
          password: os.auth.credentials.password
        app.access('opnfv-promise').invoke 'add-provider', payload
        .then (res) ->
          res.get('result').should.equal 'ok'
          ctx.provider.id = res.get('provider-id')
          done()
        .catch (err) -> done err

      it "should update promise.providers with a new entry", ->
        app.get('opnfv-promise.promise.providers').should.have.length(1)

        it "should contain a new ResourceProvider record in the store", ->
        ctx.provider = app.access('opnfv-promise').find('ResourceProvider', ctx.provider.id)
        assert ctx.provider?

    describe "increase-capacity", ->
      it "should add more capacity to the reservation service without error", (done) ->
        app.access('opnfv-promise').invoke 'increase-capacity',
          source: ctx.provider
          capacity:
            cores: 20
            ram: 51200
            instances: 10
            addresses: 10
        .then (res) ->
          res.get('result').should.equal 'ok'
          ctx.pool.id = res.get('pool-id')
          done()
        .catch (err) -> done err

      it "should update promise.pools with a new entry", ->
        app.get('opnfv-promise.promise.pools').should.have.length(1)

      it "should contain a ResourcePool record in the store", ->
        ctx.pool = app.access('opnfv-promise').find('ResourcePool', ctx.pool.id)
        assert ctx.pool?

    describe "query-capacity", ->
      it "should report available collections and utilizations", (done) ->
        app.access('opnfv-promise').invoke 'query-capacity', capacity: 'total'
        .then (res) ->
          res.get('collections').should.be.Array
          res.get('collections').length.should.be.above(0)
          res.get('utilization').should.be.Array
          res.get('utilization').length.should.be.above(0)
          done()
        .catch (err) -> done err

      it "should contain newly added capacity pool", (done) ->
        app.access('opnfv-promise').invoke 'query-capacity', capacity: 'total'
        .then (res) ->
          assert ("ResourcePool:#{ctx.pool.id}" in res.get('collections'))
          done()
        .catch (err) -> done err

  describe "allocation without reservation", ->
    before (done) ->
      # XXX - need to determine image and flavor to use in the given provider for this test

    describe "create-instance", ->
      it "should create a new server in target provider without error", (done) ->
        app.access('opnfv-promise').invoke 'create-instance',
          'provider-id': ctx.provider.id
          name: 'promise-test-no-reservation'
          image: 'xxx'
          flavor: 'yyy'
        .then (res) ->
          # do something
          done()
        .catch (err) -> done err

  describe "allocation using reservation for immediate use", ->
    reservation = undefined

    describe "create-reservation", ->
      res_id = undefined

      it "should create reservation record (no start/end) without error", (done) ->
        app.access('opnfv-promise').invoke 'create-reservation',
          capacity:
            cores: 5
            ram: 25600
            addresses: 3
            instances: 3
        .then (res) ->
          # do something
          done()
        .catch (err) -> done err

    describe "create-instance", ->
      it "should create a new server in target provider (with reservation) without error", (done) ->
        app.access('opnfv-promise').invoke 'create-instance',
          'provider-id': ctx.provider.id
          name: 'promise-test-no-reservation'
          image: 'xxx'
          flavor: 'yyy'
          'reservation-id': ctx.reservation.id
        .then (res) ->
          # do something
          done()
        .catch (err) -> done err

  describe "cleanup test allocations", ->
    describe "destroy-instance", ->
