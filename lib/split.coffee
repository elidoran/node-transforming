
# need these to include in the object we return
string   = require './string'
toObject = require './toObject'
toString = require './toString'

# this combines functions into one
compose  = require './compose'

module.exports = (options) ->

  # figure out the delim from options or default to newline
  delim = options?.delim ? (if typeof options is 'string' then options) ? '\n'

  # store it in our next object we send back
  return next =
    _options:
      split: delim
      writableObjectMode: false # can't split objects, so, can't be object mode

    # may pass on Buffer unless string() is called
    string: string

    # outputs buffer/string unless toObject() is called
    toObject: toObject

    # outputs buffer/string by default, but, this accepts the worker function
    toString: toString

    # Convenience for common case of string->object
    stringToObject: compose string, toObject
