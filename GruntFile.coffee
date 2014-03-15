module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    coffee:
      dist:
        options:
          join: true
        files:
          'dist/app.js': [
            'app/scripts/utils.coffee'
            'app/scripts/app.coffee'
          ]
    jade:
      dist:
        options:
          data:
            debug: false
        files:
          'dist/index.html': ['app/views/index.jade']
    sass:
      dist:
        options:
          quiet: true
          loadPath: [
            'bower_components/bourbon/app/assets/stylesheets'
            'bower_components/neat/app/assets/stylesheets'
            'bower_components/css-modal/'
          ]
        files:
          'dist/app.css': 'app/styles/app.scss'

    watch:
      tasks: ['coffee', 'jade', 'sass']
      files: [
          'app/**/*'
        ]
      options:
        livereload: true

    uglify:
      my_target:
        files:
          'dist/app.min.js': ['dist/app.js']
          
    connect:
      uses_defaults: {}

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-sass'

  grunt.registerTask('default', ['coffee', 'jade', 'sass', 'uglify'])
  grunt.registerTask('server', ['connect', 'watch'])
