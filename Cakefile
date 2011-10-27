coffee = require 'coffee-script'
sentry = require 'sentry'
fs = require 'fs'

build = ->
  fs.readFile 'jquery.lineup.coffee', (err, data) ->
    fs.writeFile 'jquery.lineup.js', coffee.compile data.toString()
    fs.writeFile 'test/src/jquery.lineup.js', coffee.compile data.toString()
    fs.writeFile 'example/src/jquery.lineup.js', coffee.compile data.toString()
  fs.readFile 'test/spec/jquery.lineup_spec.coffee', (err, data) ->
    fs.writeFile 'test/spec/jquery.lineup_spec.js', coffee.compile data.toString()

task 'build', 'generate the js for test and in root', build
task 'watch', 'watch for file changes in jquery.lineup.coffee and build', ->
  sentry.watch 'jquery.lineup.coffee', ->
    build()
    console.log 'compiled'