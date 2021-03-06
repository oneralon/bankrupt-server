exec = require('child_process').execSync

module.exports = (grunt) ->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'
    # coffee:
    #   compile:
    #     expand: true
    #     flatten: true
    #     # cwd: '.'
    #     src: ['**/*.coffee']
    #     dest: 'public/dist'
    #     ext: '.js'
    stylus:
      compile:
        options:
          paths: ['./assets/styles']
        files:
          'public/styles/main.css': './assets/styles/*.styl'
    watch:
      # coffee:
      #   files: ['**/*.coffee']
      #   tasks: ['coffee']
      express:
        files: ['**/*.coffee', 'server.coffee']
        tasks: ['express:dev']
        options:
          spawn: no
    express:
      dev:
        options:
          script: 'server.coffee'
          opts: ['/usr/local/bin/coffee']
          node_env: 'development'
          nodeArgs: ['--nodejs', '--debug']
          #port: 8080
      prod:
        options:
          script: 'server-multithread.coffee'
          opts: ['/usr/local/bin/coffee']
          background: yes
          node_env: 'production'
          #port: 8080
    nodemon:
      dev:
        script: './server.coffee'
        options:
          nodeArgs: ['--nodejs', '--debug']
          ignore: [
            'node_modules/**'
            'public/**'
          ]
          ext: 'js,coffee'
          watch: ['**/*.coffee', 'server.coffee']
      prod:
        script: './server-multithread.coffee'
        timeout: 100
        options:
          nodeArgs: []
          callback: (nodemon) ->
            nodemon.on 'crash', -> setTimeout ->
              exec 'pkill -9 -f \'node /usr/local/bin/coffee server-multithread.coffee\''
              exec 'pkill -9 -f \'sh -c coffee ./server-multithread.coffee\''
              require('fs').writeFileSync('.rebooted', 'rebooted')
            , 100
          opts: ['/usr/local/bin/coffee']
          env: PORT: 4000
          ignore: [
            'node_modules/**'
            'public/**'
          ]
          ext: 'js,coffee'
          watch: ['**/*.coffee', 'server.coffee', '.rebooted']



  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-express-server'
  grunt.loadNpmTasks 'grunt-nodemon'
  grunt.loadNpmTasks 'grunt-keepalive'
  grunt.registerTask 'default', ['stylus', 'nodemon:dev', 'watch']
  grunt.registerTask 'production', ['stylus', 'nodemon:prod', 'keepalive']
