

module.exports = (functions...) ->

  # return a function which accepts options and calls each function
  (options) ->

    # at first our context is `this`
    context = this

    # replace context with the returned context object each time
    context = fn.call context, options for fn in functions

    # return final result, which is the final `context` value
    return context
