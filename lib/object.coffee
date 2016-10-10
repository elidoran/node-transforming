toObject = require './toObject'
toString = require './toString'

module.exports = (options) ->

  # must be an object, so, set the mode option
  @_options.writableObjectMode = true

  return next =
    _options: @_options

    # outputs buffer/string unless toObject() is called
    toObject: toObject

    # outputs buffer/string by default, but, this accepts the worker function
    toString: toString
