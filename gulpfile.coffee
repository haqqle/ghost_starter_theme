"use strict"

gulp      = require("gulp")
jadeToHbs = require('gulp-jade-hbs')
reload    = require('gulp-livereload')
jeditor   = require("gulp-json-editor")
$         = require("gulp-load-plugins")(lazy: false)
$run      = require('run-sequence')
$logger   = $.util.log

paths =
  scss_files:   ['./source/assets/css/*.scss']
  css_files:    ['./source/assets/css/*.css']
  coffee_files: ['./source/assets/js/**/*.coffee']
  js_files:     ['./source/assets/js/**/*.js']
  jade_files:   ['./source/**/*.jade']
  font_files:   ['./source/assets/fonts/**/*']
  image_files:  ['./source/assets/images/**/*']
  destination:  ['./theme/']

gulp.task "package", ->
  gulp.src("./package.json")
    .pipe(jeditor (json) ->
      {
        'name': json.name
        'version': json.version
      }
    )
    .pipe(gulp.dest("#{paths.destination}"));

gulp.task "copy", ->
  # copy fonts
  gulp.src(paths.font_files)
    .pipe(gulp.dest("#{paths.destination}./assets/fonts"))

  # copy images
  gulp.src(paths.image_files)
    .pipe(gulp.dest("#{paths.destination}./assets/images"))

  # copy css
  gulp.src(paths.css_files)
  .pipe(gulp.dest("#{paths.destination}./assets/css"))

  # copy js
  gulp.src(paths.js_files)
  .pipe(gulp.dest("#{paths.destination}./assets/js"))


gulp.task 'sass', (done) ->
  gulp.src(paths.scss_files)
    .pipe($.plumber(errorHandler: $.notify.onError("Error: <%= error.message %>")))
    .pipe($.sass(errLogToConsole: true))
    .pipe($.concat('style.css'))
    .pipe(gulp.dest("#{paths.destination}./assets/css"))
    .pipe($.minifyCss(keepSpecialComments: 0))
    .pipe($.rename(extname: '.min.css'))
    .pipe(gulp.dest("#{paths.destination}./assets/css"))
    .pipe($.size(showFiles: true))


gulp.task 'coffee', (done) ->
  gulp.src(paths.coffee_files)
    .pipe($.plumber(errorHandler: $.notify.onError("Error: <%= error.message %>")))
    .pipe($.coffee(bare: false).on('error', $logger))
    .pipe($.jshint(".jshintrc"))
    .pipe($.jshint.reporter('jshint-stylish'))
    .pipe($.concat('app.js'))
    .pipe($.insert.prepend("'use strict';\n"))
    .pipe(gulp.dest("#{paths.destination}./assets/js"))
    .pipe($.size(showFiles: true))


gulp.task 'jade', (done) ->
  LOCALS = {pretty: true}
  gulp.src(paths.jade_files)
    .pipe($.plumber(errorHandler: $.notify.onError("Error: <%= error.message %>")))
    .pipe(jadeToHbs({ locals: LOCALS }))
    .pipe(gulp.dest("#{paths.destination}"))
    .pipe($.size(showFiles: true))
    .pipe(reload());

gulp.task 'watch', ->
  reload.listen();
  gulp.watch(paths.scss_files, ['sass'])
  gulp.watch(paths.coffee_files, ['coffee'])
  gulp.watch(paths.jade_files, ['jade'])
  gulp.watch(paths.font_files, ['copy'])
  gulp.watch(paths.css_files, ['copy'])
  gulp.watch(paths.js_files, ['copy'])
  gulp.watch(paths.image_files, ['copy'])
  gulp.watch(['./package.json'], ['package'])

gulp.task 'build', (callback) ->
  $run("sass", "coffee", "jade", "copy", "package", callback)

gulp.task 'default', ['build']
