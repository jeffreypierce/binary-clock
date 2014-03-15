module.exports = (grunt) ->

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    coffee:
      main:
        options:
          join: true
        files:
          '.tmp/app.js': [
            'app/scripts/utils.coffee'
            'app/scripts/app.coffee'
          ]
    cson:
      main:
        expand: true
        src: ['app/manifest.cson']
        dest: '.tmp'
        ext: '.json'
        
    jade:
      main:
        options:
          data:
            debug: false
        files:
          '.tmp/index.html': ['app/views/index.jade']
    sass:
      main:
        options:
          quiet: true
          loadPath: [
            'bower_components/bourbon/app/assets/stylesheets'
            'bower_components/neat/app/assets/stylesheets'
            'bower_components/css-modal/'
          ]
        files:
          '.tmp/app.css': 'app/styles/app.scss'

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
          'dist/app.min.js': ['.tmp/app.js']
    
    copy:
      main:
        files: [
          {src: '.tmp/index.html', dest: 'dist/index.html'}
          {src: '.tmp/app.css', dest: 'dist/app.css'}
          {src: '.tmp/app/manifest.json', dest: 'dist/manifest.json'}
          {src: 'app/assets/icon_128.png', dest: 'dist/icon_128.png'}
        ]
        
          
    connect:
      uses_defaults: {}

  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-cson'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-sass'
  grunt.loadNpmTasks 'grunt-contrib-copy'

  grunt.registerTask('default', ['coffee', 'jade', 'sass', 'uglify', 'cson', 'copy'])
  grunt.registerTask('server', ['connect', 'watch'])
