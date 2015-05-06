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
          #port: 8080
      prod:
        options:
          script: 'server.coffee'
          opts: ['/usr/local/bin/coffee']
          background: yes
          #port: 8080


  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-express-server'
  grunt.loadNpmTasks 'grunt-keepalive'
  grunt.registerTask 'default', ['stylus', 'express:dev', 'watch']
  grunt.registerTask 'production', ['stylus', 'express:prod', 'keepalive']
