# used to split input
buildEach = require 'each-part'
# used to combine the splitting transform and our 'transformer'
combine = require('combining')()

class Transformer extends require('stream').Transform

  constructor: (options) ->
    # call super constructor
    super options

    # store the worker function on the transformer
    @process = options.fn

  _transform: (data, encoding, next) ->

    # let's remember if they call next() so we can avoid doing push/next
    nexted = false

    # the common case is we pass data and it returns a single result
    # we pass `next` in case they do want to do some async work...
    result = @process data, ->
      nexted = true
      next()

    # if they want to do some async work and return {wait:true} then
    # don't call next() cuz they will
    if result?.wait then return

    if result?.error? then return next result.error

    # only if they haven't called next() already, then we can push() or next()
    unless nexted
      # unless they tell us not to, push the result
      unless result?.push is false then @push result

      # and we're done
      next()



# export a function which creates a Transformer instance
module.exports = (options) ->

  transformer = new Transformer options

  if options.split?
    # create a splitting stream which pipes to this stream.
    # use options for the transformer
    splitter = buildEach
      delim             : options.split
      readableObjectMode: false
      encoding          : options.encoding
      defaultEncoding   : options.defaultEncoding
      decodeStrings     : options.decodeStrings

    # combine the two streams so no one using transformer knows...
    combine splitter, transformer

  # else, no splitter, so, just return the transformer
  else transformer
