assert = require 'assert'

buildTransforming = require '../../lib'

transforming = buildTransforming()

uppercase = (string) -> string.toUpperCase?()

tests = [

  {
    what: 'with uppercase converter'
    build: [
      { name: 'string' }
      { name: 'toString', args: [uppercase] }
    ]
    calls: [
      { name: 'end', args: ['testing', 'utf8'] }
    ]
    output: ['TESTING']
  }

  {
    what: 'with uppercase converter'
    build: [
      { name: 'string' }
      { name: 'toString', args: [uppercase] }
    ]
    calls: [
      { name: 'write', args: ['testing1', 'utf8'] }
      { name: 'write', args: ['testing2', 'utf8'] }
      { name: 'end', args: ['testing3', 'utf8'] }
    ]
    output: ['TESTING1', 'TESTING2', 'TESTING3']
  }


  {
    what: 'with uppercase converter'
    build: [
      { name: 'split' }
      { name: 'string' }
      { name: 'toString', args: [uppercase] }
    ]
    calls: [
      { name: 'end', args: ['one\ntwo\nthree', 'utf8'] }
    ]
    output: ['ONE', 'TWO', 'THREE']
  }


]

describe 'test transforming', ->

  for test in tests

    do (test) ->

      describe test.what, ->

        # at first, we start calling a funtion on `transforming`
        context = transforming

        # that'll change with each return.
        # call the function with the args and keep the result as the next context
        context = context[build.name](build.args...) for build in test.build

        # now we're done with that, we should have the transform
        transform = context

        # remember its data results
        results = []
        transform.on 'data', (data) -> results.push data

        ended = false
        finished = false
        transform.on 'end', -> ended = true
        transform.on 'finish', -> finished = true

        transform[call.name](call.args...) for call in test.calls

        it 'should produce the transform', -> assert transform

        it 'should have ended', -> assert ended

        it 'should have finished', -> assert finished

        it 'should transform input to output', ->

          assert.deepEqual results, test.output
