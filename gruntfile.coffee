###
Licensed under the MIT license
For full copyright and license information, please see the LICENSE file

@author     Bryan Conrad <bkconrad@gmail.com>
@copyright  2015 Bryan Conrad
@link       https://github.com/kaen/node-nested-object-mask
@license    http://choosealicense.com/licenses/MIT  MIT License
###

module.exports = ( grunt ) ->

  ### ALIASES ###

  jsonFile =                      grunt.file.readJSON           # Read a json file
  define =                        grunt.registerTask            # Register a local task
  log =                           grunt.log.writeln             # Write a single line to STDOUT


  ### GRUNT CONFIGURATION ###

  config =

    # Define aliases for known fs locations
    srcDir:                       'src/'              # CoffeeScript or other source files to be compiled or processed
    libDir:                       'lib/'              # JavaScript or other compiled files to be included in the package
    tstDir:                       'test/'             # Project's tests
    resDir:                       'res/'              # Static resources - images, text files, external deps etc.
    docDir:                       'docs/'             # Automatically-generated or compiled documentation
    srcFiles:                     ['<%= srcDir %>**/*.coffee', 'index.coffee']
    tstFiles:                     '<%= tstDir %>**/*.test.coffee'
    pkg:                          jsonFile 'package.json'


    ### TASKS DEFINITION ###

    # grunt-contrib-watch: Run tasks on filesystem changes
    watch:
      options:
        # Define default tasks here, then point targets' "tasks" attribute here: '<%= watch.options.tasks %>'
        tasks:                    ['lint', 'cov']    # Run these tasks when a change is detected
        interrupt:                true                # Restarts any running tasks on next event
        atBegin:                  true                # Runs all defined watch tasks on startup
        dateFormat:               ( time ) -> log "Done in #{time}ms"

      # Targets

      gruntfile:                  # Watch the gruntfile for changes ( also dynamically reloads grunt-watch config )
        files:                    'gruntfile.coffee'
        tasks:                    '<%= watch.options.tasks %>'

      project:                    # Watch the project's source files for changes
        files:                    ['<%= srcFiles %>', '<%= tstFiles %>']
        tasks:                    '<%= watch.options.tasks %>'


    # grunt-coffeelint: Lint CoffeeScript files
    coffeelint:
      options:                    jsonFile 'coffeelint.json'

      # Targets

      gruntfile:                  'gruntfile.coffee'                          # Lint this file
      project:                    ['<%= srcFiles %>', '<%= tstFiles %>']      # Lint application's project files


    # grunt-mocha-cli: Run tests with Mocha framework
    mochacli:
      options:
        reporter:                 'spec'                                      # This report is nice and human-readable
        compilers:                ['coffee:coffee-script/register']
        excludes:                 './gruntfile.coffee'

      # Targets

      project:                    # Run the project's tests
        src:                      ['<%= tstFiles %>']

    # grunt-mocha-istanbul: Run tests with coverage report
    mocha_istanbul:
      coverage:
        src: 'test'
        options:
          mochaOptions: ['--compilers', 'coffee:coffee-script/register']

      options:
        root: 'src'
        require:                  ['coffee-coverage/register-istanbul']

    # grunt-codo: CoffeeScript API documentation generator
    codo:
      options:
        title:                    'nested-object-mask'
        debug:                    false
        inputs:                   ['<%= srcDir %>']
        output:                   '<%= docDir %>'


    # grunt-contrib-coffee: Compile CoffeeScript into native JavaScript
    coffee:

      # Targets

      build:                      # Compile CoffeeScript into target build directory
        expand:                   true
        ext:                      '.js'
        src:                      '<%= srcFiles %>'
        dest:                     '<%= libDir %>'


    # grunt-contrib-uglify: Compress and mangle JavaScript files
    uglify:

      # Targets

      build:
        files: [
          expand:                 true
          src:                    '<%= srcDir %>**/*.js'
        ]


    # grunt-contrib-clean: Clean the target files & folders, deleting anything inside
    clean:

      # Targets

      build:                      ['<%= srcDir %>**/*.js', 'index.js']        # Clean the build products
      docs:                       ['<%= docDir %>']

    # grunt-gh-pages: Build GH pages
    'gh-pages':
      options:
        base: '.'

      src: ['docs/**', 'coverage/**']


  ###############################################################################

  ### CUSTOM FUNCTIONS ###


  ### GRUNT MODULES ###

  # Loads all grunt tasks from devDependencies starting with "grunt-"
  require( 'load-grunt-tasks' )( grunt )

  ### GRUNT TASKS ###

  define 'lint',                  ['coffeelint']
  define 'test',                  ['mochacli']
  define 'cov',                   ['mocha_istanbul']
  define 'docs',                  ['codo']
  define 'build:dev',             ['clean:build', 'lint', 'test', 'coffee:build']
  define 'build',                 ['build:dev', 'uglify:build']
  define 'pages',                 ['gh-pages']
  define 'default',               ['build']

  ###############################################################################
  grunt.initConfig config
