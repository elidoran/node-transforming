
# we need these to include in the object we return
split    = require './split'
string   = require './string'
toObject = require './toObject'
object   = require './object'
toString = require './toString'

# this combines some of the above into single functions for convenience
compose  = require './compose'

module.exports = (buildOptions) ->

  # TODO: buildOptions ?

  return first =
    # start with empty options
    _options: {}

    # passes on stream as-is unless split() is called
    split: split

    # passes on Buffer unless string() is called
    string: string

    # outputs buffer/string unless toObject() is called
    toObject: toObject

    # expects input of buffer/string unless object() is called
    object: object

    # outputs buffer/string by default, but, this accepts the worker function
    toString: toString

    # Convenience for common case of object->string
    objectToString: compose object, toString

    # Convenience for common case of string->object
    stringToObject: compose string, toObject

    # Convenience for common case of newline delimited string->object
    splitStringToObject: compose split, string, toObject
