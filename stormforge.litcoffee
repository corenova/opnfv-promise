# stormforge module

The `stormforge` module is a Yang schema derived module that is
compiled by the
[yang-compiler](http://github.com/stormstack/yang-compiler) using the
[yang-storm](http://github.com/stormstack/yang-storm) extension to
produce STORM data model driven complex-types and instances.

## Compiling the new stormforge module

    compiler = (require 'yang-compiler').configure ->
      @use (require 'yang-storm')
      @set 'schemadir', (require 'path').resolve __dirname, './schemas'
      
    output = compiler.compile (compiler.readSchema 'stormforge.yang')

    forge = output.configure ->
      @use compiler

      @on '/build', (e) ->
        
        
    module.exports = forge
        
### Running the stormforge module as a standalone application

    forge.run process if require.main is module
    

    if require.main is module
