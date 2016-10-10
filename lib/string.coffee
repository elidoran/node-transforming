toObject = require './toObject'
toString = require './toString'

module.exports = (options) ->

  # figure out the encoding from options or default to utf8
  encoding = options?.encoding ? (if typeof options is 'string' then options) ? 'utf8'

  # TODO: could only set default encoding if they specify it...

  # store in our _options
  # store 'default encoding' for Writable side
  @_options.defaultEncoding = encoding

  # set decodeStrings to false because we want a string
  @_options.decodeStrings = false

  # must be non-object, so, set the mode option to be sure
  @_options.writableObjectMode = false

  return next =
    _options: @_options

    # outputs buffer/string unless toObject() is called
    toObject: toObject

    # outputs buffer/string by default, but, this accepts the worker function
    toString: toString
