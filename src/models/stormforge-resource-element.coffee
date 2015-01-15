DS = require '../stormforge'

class StormForgeResourceElement extends DS.Model

    name: 'resourceElement'

    schema:
        type:      DS.attr 'string', required: true
        # must define the provider that has this resource element!
        provider:  DS.belongsTo 'resourceProvider', required: true

module.exports = StormForgeResourceElement
