coffee = require 'coffee-script'
sentry = require 'sentry'
fs = require 'fs'

build = ->
  fs.readFile 'jquery.fillwidth.coffee', (err, data) ->
    fs.writeFile 'jquery.fillwidth.js', coffee.compile data.toString()
    fs.writeFile 'test/src/jquery.fillwidth.js', coffee.compile data.toString()
    fs.writeFile 'example/src/jquery.fillwidth.js', coffee.compile data.toString()
  fs.readFile 'test/spec/jquery.fillwidth_spec.coffee', (err, data) ->
    fs.writeFile 'test/spec/jquery.fillwidth_spec.js', coffee.compile data.toString()

task 'build', 'generate the js for test and in root', build
task 'watch', 'watch for file changes in jquery.fillwidth.coffee and build', ->
  sentry.watch 'jquery.fillwidth.coffee', ->
    build()
    console.log 'compiled'
  
  sentry.watch __dirname + '/test/spec/jquery.fillwidth_spec.coffee', ->
    build()
    console.log 'compiled'