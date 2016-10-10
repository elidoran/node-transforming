
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

  # build the transform
  transform = buildTransformer @_options

  # return it
  return transform
