Forge = require 'yangforge'
module.exports = Forge.new module,
  after: ->
    @on 'add-provider', (input, output, next) ->
      controller = @create (input.get 'provider')
      controller.invoke 'add-provider', (input.get 'endpoint', 'region', 'username', 'password')
      .then (res) =>
        (@access 'promise.providers').push res
        next()
      
    @on 'list-reservations', (input, output, done, origin) ->
      console.warn "coming soon!"
