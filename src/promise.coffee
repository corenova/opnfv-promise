Forge = require 'yangforge'
module.exports = Forge.new module,
  after: ->
    @on 'add-provider', (input, output, next) ->
      provider = @create (input.get 'provider'), (input.get 'endpoint', 'region')
      provider.invoke 'auth', (input.get 'username', 'password')
      .then (res) =>
        (@access 'promise.providers').push res
        next()
      
    @on 'list-reservations', (input, output, done, origin) ->
      console.warn "coming soon!"
