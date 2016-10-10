
buildTransformer = require './transformer'

module.exports = (options) ->

  # figure out the function from options
  fn = options?.fn ? (if typeof options is 'function' then options)

  # TODO: return error?
  unless fn? then return error:'No function provided to \'toString\''

  # store it in our _options
  @_options.fn = fn

  if options?.encoding? then @_options.encoding = options.encoding
  else @_options.encoding = 'utf8'

  # mark it as passing on string/buffer, not objects
  @_options.readableObjectMode = false

  # unless they called string(), which sets this value to false, then let's
  # set it to true assuming they are converting from an object to a string
  # example: transforming.toString(fn) would expect object -> string
  @_options.writableObjectMode ?= true

  # build the transform
  transform = buildTransformer @_options

  # return it
  return transform
