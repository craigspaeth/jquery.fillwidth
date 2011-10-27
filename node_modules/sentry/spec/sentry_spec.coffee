require './helpers/spec_helper.coffee'
sentry = require '../src/sentry.coffee'
fs = require 'fs'
exec = require('child_process').exec
spawn = require('child_process').spawn
path = require 'path'
_ = require 'underscore'

describe 'sentry.watch', ->
  
  describe 'given a relative file string', ->
    
    it 'throws an error if it cant find the file', ->
      try
        sentry.watch('garbage')
      catch e
        expect(e.message).toEqual "SENTRY: File 'garbage' does not exist!"
    
    it 'runs a function when the file is changed', ->
      done = false; waitsFor -> done
      fs.writeFileSync __rootdir + '/spec/fixtures/string/foo.js', 'Blank'
      sentry.watch __rootdir + '/spec/fixtures/string/foo.js', ->
        expect(true).toBeTruthy()
        done = true
      _.defer -> fs.writeFileSync __rootdir + '/spec/fixtures/string/foo.js', 'Hello World'
      
    it 'runs a task when the file is changed', ->
      done = false; waitsFor (-> done), null, 10000
      fs.writeFileSync __rootdir + '/spec/fixtures/string/bar.js', 'Blank'
      sentry.watch __rootdir + '/spec/fixtures/string/bar.js', 'cake stub', (err, stdout, stderr) ->
        expect(stdout.indexOf 'foo').toNotEqual -1
        done = true
      _.defer -> fs.writeFileSync __rootdir + '/spec/fixtures/string/bar.js', 'Hello World'
      
    it 'passes the filename to the callback'  , ->
      done = false; waitsFor -> done
      fs.writeFileSync __rootdir + '/spec/fixtures/string/baz.js', 'Blank'
      sentry.watch __rootdir + '/spec/fixtures/string/baz.js', (filename) ->
        expect(filename).toEqual __rootdir + '/spec/fixtures/string/baz.js'
        done = true
      _.defer -> fs.writeFileSync __rootdir + '/spec/fixtures/string/baz.js', 'Hello World'
      
  describe 'given a single wild card', ->
    
    it 'runs a function when a file is changed', ->
      done = false; waitsFor -> done
      fs.writeFileSync __rootdir + '/spec/fixtures/wildcard/foo.js', 'Blank'
      sentry.watch __rootdir + '/spec/fixtures/wildcard/*', ->
        expect(true).toBeTruthy()
        done = true
      _.defer -> fs.writeFileSync __rootdir + '/spec/fixtures/wildcard/foo.js', 'Hello World'
      
    it 'runs a task when a file is changed', ->
      done = false; waitsFor (-> done), null, 10000
      fs.writeFileSync __rootdir + '/spec/fixtures/wildcard/bar.js', 'Blank'
      sentry.watch __rootdir + '/spec/fixtures/wildcard/*', 'cake stub', (err, stdout, stderr) ->
        expect(stdout.indexOf 'foo').toNotEqual -1
        done = true
      _.defer -> fs.writeFileSync __rootdir + '/spec/fixtures/wildcard/bar.js', 'Hello World'
      
    it 'it passes the filename to the callback', ->
      done = false; waitsFor -> done
      fs.writeFileSync __rootdir + '/spec/fixtures/wildcard/foo.js', 'Blank'
      sentry.watch __rootdir + '/spec/fixtures/wildcard/*', (filename) ->
        expect(filename.match(/foo|baz|qux|bar/)).toBeTruthy() 
        done = true
      _.defer -> fs.writeFileSync __rootdir + '/spec/fixtures/wildcard/foo.js', 'Hello World'
      
    it 'it only watches the file with given extension', ->
      done = false; waitsFor -> done
      filesWritten = 0
      sentryWatchedFiles = 0
      fs.writeFileSync __rootdir + '/spec/fixtures/wildcard/qux.js', 'Blank'
      fs.writeFileSync __rootdir + '/spec/fixtures/wildcard/baz.coffee', 'Blank'
      sentry.watch __rootdir + '/spec/fixtures/wildcard/*.coffee', (filename) ->
        filesWritten++
        sentryWatchedFiles++
        if filesWritten is 2
          expect(sentryWatchedFiles).toEqual 1
          done = true
      fs.watchFile __rootdir + '/spec/fixtures/wildcard/qux.js', (curr, prev) ->
        filesWritten++
        if filesWritten is 2
          expect(sentryWatchedFiles).toEqual 1
          done = true
      _.defer -> fs.writeFileSync __rootdir + '/spec/fixtures/wildcard/qux.js', 'Hello World'
      _.defer -> fs.writeFileSync __rootdir + '/spec/fixtures/wildcard/baz.coffee', 'Hello World'
      
  describe 'given a recursive wild card', ->
    
    it 'runs a function when a deeply nested file is changed', ->
      done = false; waitsFor -> done
      fs.writeFileSync __rootdir + '/spec/fixtures/deepwildcard/deep/foo.js', 'Blank'
      sentry.watch __rootdir + '/spec/fixtures/deepwildcard/**/*.js', ->
        expect(true).toBeTruthy()
        done = true
      _.defer -> fs.writeFileSync __rootdir + '/spec/fixtures/deepwildcard/deep/foo.js', 'Hello World'
      
    it 'runs a function when a not so deeply nested file is changed', ->
      done = false; waitsFor (-> done), null, 10000
      fs.writeFileSync __rootdir + '/spec/fixtures/deepwildcard/bar.js', 'Blank'
      sentry.watch __rootdir + '/spec/fixtures/deepwildcard/**/*.js', 'cake stub', (err, stdout, stderr) ->
        expect(stdout.indexOf 'foo').toNotEqual -1
        done = true
      _.defer -> fs.writeFileSync __rootdir + '/spec/fixtures/deepwildcard/bar.js', 'Hello World'
      
    it 'it passes the filename to the callback', ->
      done = false; waitsFor -> done
      fs.writeFileSync __rootdir + '/spec/fixtures/deepwildcard/deep/foo.js', 'Blank'
      sentry.watch __rootdir + '/spec/fixtures/deepwildcard/**/*', (filename) ->
        expect(filename.match(/foo|baz|qux/)).toBeTruthy() 
        done = true
      _.defer -> fs.writeFileSync __rootdir + '/spec/fixtures/deepwildcard/deep/foo.js', 'Hello World'
      
    it 'it only watches the file with given extension', ->
      done = false; waitsFor -> done
      filesWritten = 0
      sentryWatchedFiles = 0
      fs.writeFileSync __rootdir + '/spec/fixtures/deepwildcard/deep/qux.js', 'Blank'
      fs.writeFileSync __rootdir + '/spec/fixtures/deepwildcard/deep/baz.coffee', 'Blank'
      sentry.watch __rootdir + '/spec/fixtures/deepwildcard/**/*.coffee', (filename) ->
        filesWritten++
        sentryWatchedFiles++
        if filesWritten is 2
          expect(sentryWatchedFiles).toEqual 1
          done = true
      fs.watchFile __rootdir + '/spec/fixtures/deepwildcard/deep/qux.js', (curr, prev) ->
        filesWritten++
        if filesWritten is 2
          expect(sentryWatchedFiles).toEqual 1
          done = true
      _.defer -> fs.writeFileSync __rootdir + '/spec/fixtures/deepwildcard/deep/qux.js', 'Hello World'
      _.defer -> fs.writeFileSync __rootdir + '/spec/fixtures/deepwildcard/deep/baz.coffee', 'Hello World'
      
      
describe 'sentry.watchRegExp', ->

  it 'runs a function when a deeply nested file that matches the regex changes', ->
    done = false; waitsFor -> done
    fs.writeFileSync __rootdir + '/spec/fixtures/regex/deep/foo.txt', 'Blank'
    sentry.watchRegExp './fixtures/regex/', /txt$/, ->
      expect(true).toBeTruthy()
      done = true
    _.defer -> fs.writeFileSync __rootdir + '/spec/fixtures/regex/deep/foo.txt', 'Hello World'
    
describe 'sentry.findWildcards', ->

  it 'given a /* type wildcard finds files one directory deep', ->
    equal = _.isEqual sentry.findWildcards(__rootdir + '/spec/fixtures/wildcard/*'), [
      '/Users/Craig/sentry/spec/fixtures/wildcard/bar.js',
      '/Users/Craig/sentry/spec/fixtures/wildcard/baz.coffee',
      '/Users/Craig/sentry/spec/fixtures/wildcard/foo.js',
      '/Users/Craig/sentry/spec/fixtures/wildcard/qux.js'
    ]
    expect(equal).toBeTruthy()
    
  it 'given a /**/* type wildcard finds files recursive', ->
    equal = _.isEqual sentry.findWildcards(__rootdir + '/spec/fixtures/deepwildcard/**/*'), [ 
      '/Users/Craig/sentry/spec/fixtures/deepwildcard/bar.js',
      '/Users/Craig/sentry/spec/fixtures/deepwildcard/deep/baz.coffee',
      '/Users/Craig/sentry/spec/fixtures/deepwildcard/deep/foo.js',
      '/Users/Craig/sentry/spec/fixtures/deepwildcard/deep/qux.js'
    ]
    expect(equal).toBeTruthy()
    
  it 'given a /**/*.coffee type wildcard finds files with only that extension', ->
    equal = _.isEqual sentry.findWildcards(__rootdir + '/spec/fixtures/deepwildcard/**/*.coffee'), [
      '/Users/Craig/sentry/spec/fixtures/deepwildcard/deep/baz.coffee'
    ]
    expect(equal).toBeTruthy()