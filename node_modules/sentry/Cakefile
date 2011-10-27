exec = require('child_process').exec

task 'build', 'src/ --> lib/', ->
  exec 'coffee -co lib src', (err, stdout, stderr) ->
    if err
      console.log stdout
      console.log stderr
      throw new Error "Error while compiling .coffee to .js"
      
task 'stub', 'A stub task for testing running a child process', ->
  console.log 'foo'
  return 'moo'