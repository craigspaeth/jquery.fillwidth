coffee = require 'coffee-script'
fs = require 'fs'

task 'build', 'generate the js for test and in root', (options) ->
  fs.readFile 'jquery.lineup.coffee', (err, data) ->
    fs.writeFile 'jquery.lineup.js', coffee.compile data.toString()
    fs.writeFile 'test/src/jquery.lineup.js', coffee.compile data.toString()
  fs.readFile 'test/spec/jquery.lineup_spec.coffee', (err, data) ->
    fs.writeFile 'test/spec/jquery.lineup_spec.js', coffee.compile data.toString()