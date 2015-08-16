Forge = require 'yangforge'
module.exports = Forge.new module,
  after: ->
    @on 'add-provider', (input, output, done, origin) ->
      endpoint = input.get 'endpoint'
      console.warn "coming soon!"
      
    @on 'list-reservations', (input, output, done, origin) ->
      console.warn "coming soon!"
