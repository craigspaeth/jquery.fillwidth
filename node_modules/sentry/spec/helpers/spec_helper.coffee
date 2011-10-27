# Run an entire suite aynchronously
_done = false
@done = -> _done = true
@runAsync = (timeout = 10000) ->
  beforeEach -> _done = false
  afterEach -> waitsFor (-> _done), null, timeout
  
global.__rootdir = __dirname.split('/').slice(0, -2).join('/')