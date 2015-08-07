Forge = require 'yangforge'
module.exports = Forge.new module,
  after: ->
    @on 'opnfv-promise-vim:list-servers', (input, output, done, origin) ->
      provider = input.get 'provider'
      unless destination?
        console.error "cannot issue ping without destination address"
        output.set 'echo-result', 2
        return done()
      child = sys.exec "ping -c 1 #{destination}", timeout: 2500
      child.on 'error', (err)  -> output.set 'echo-result', 2; done()
      child.on 'close', (code) -> output.set 'echo-result', code ? 1; done()
