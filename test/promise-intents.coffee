config = require 'config'

payload =
  endpoint: 'http://vhub4.intercloud.net:5000/v2.0/tokens'
  tenant: id: '62a2d90992114994977fd6707bac5758'

assert  = require 'assert'
forge   = require 'yangforge'
promise = forge.load '../opnfv-promise.yaml'

describe "promise - resource management", ->
  before ->

  describe "add-provider", ->
    it "should add a new provider without error", (done) ->
      promise.invoke 'add-provider'
      # TBD
      done()
