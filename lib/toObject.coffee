
buildTransformer = require './transformer'

module.exports = (options) ->

  # figure out the function from options
  fn = options?.fn ? (if typeof options is 'function' then options)

  # TODO: return error?
  unless fn? then return error:'No function provided to \'toObject\''

  # store it in our _options
  @_options.fn = fn

  # mark it as passing on objects
  @_options.readableObjectMode = true

  # build the transform
  transform = buildTransformer @_options

  # return it
  return transform
