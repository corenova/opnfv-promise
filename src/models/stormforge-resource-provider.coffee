DS = require '../stormforge'

class StormForgeResourceProvider extends DS.Model

    name: 'resourceProvider'

    schema:
        name:        DS.attr 'string', required: true
        username:    DS.attr 'string', required: true
        password:    DS.attr 'string', required: true

        endpoint:    DS.attr 'string', required: true
        tenant:      DS.attr 'string', required: true
        regionName:  DS.attr 'string', required: true
        image:       DS.attr 'string', required: true
        compute:     DS.attr 'string', required: true
        identity:    DS.attr 'string', required: true

        elements:    DS.hasMany 'resourceElement'

module.exports = StormForgeResourceProvider
