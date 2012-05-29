_ = require 'underscore'
pkg = require '../../package'
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
      .version(pkg.version)
      .usage('new <app-name>')
      .option('-i, --id <id>', 'App ID (defaults to reverse publisher url (-url param) followed by dasherized version of <app-name>. eg: com.example.my-app)')
      .option('-d, --dir <dir>', 'Directory (defaults to ./<id>)')
      .option('-u, --puburl <puburl>', 'The publisher URL (defaults to http://www.example.com)')

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
      puburl: program.puburl
