_ = require 'underscore'
package = require '../../package'
generator = require '../generator'

examples = '''
  
    Examples:

      $ titanium-backbone new "My APP" -i my-app -d ~/tmp/my-app
      $ titanium-backbone new "My New APP" (Defaults: id=my-new-app, dir=./my-new-app)

'''

module.exports =

  run: (args) ->

    program = require 'commander'

    program
      .version(package.version)
      .usage('new <app-name>')
      .option('-i, --id <id>', 'App ID (defaults to dasherized version of <app-name>)')
      .option('-d, --dir <dir>', 'Directory (defaults to ./<id>)')

    program.on '--help', ->
      console.log examples

    program.parse args

    if _.isEmpty program.args
      console.log program.helpInformation(), examples
      process.exit()

    generator.app
      name: program.args[0]
      id: program.id
      dir: program.dir
