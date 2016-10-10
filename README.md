# transforming
[![Build Status](https://travis-ci.org/elidoran/node-transforming.svg?branch=master)](https://travis-ci.org/elidoran/node-transforming)
[![Dependency Status](https://gemnasium.com/elidoran/node-transforming.png)](https://gemnasium.com/elidoran/node-transforming)
[![npm version](https://badge.fury.io/js/transforming.svg)](http://badge.fury.io/js/transforming)

Conveniently create Transform instances for your function to operate on the data.

Conveniences:

1. split input based on delimiter (string or regex)
2. convert from Buffer to string via encoding
3. push result and call callback
4. emit error

## Install

```sh
npm install transforming --save
```

## Usage

```javascript
// get the module and build it
var transforming = require('transforming')()

// make a fromJson converter function
var fromJson = JSON.parse.bind JSON

// make a toJson converter function
var toJson JSON.stringify.bind JSON

// build a transform which:
//  1. accepts bytes containing newline delimited json strings
//  2. splits the bytes by newline chars
//  3. converts bytes to string using 'utf8' encoding
//  4. passes string to the `fromJson` converter function
//  5. catches errors and emits an 'error' event with their message
//  6. pushes object result from converter function on to next stream
//  7. emits a 'data' event with the object result
var transformToObject = transforming.split('\n').string('utf8').toObject(fromJson)
//   OR: default string encoding is 'utf8'
var transformToObject = transforming.split().string().toObject(fromJson)
//   OR: common to go from string to object
var transformToObject = transforming.split().stringToObject(fromJson)
//   OR: common to split text on newlines and pass utf8 string to object converter
var transformToObject = transforming.splitStringToObject(fromJson)

// build a transform which:
//  1. accepts objects
//  2. passes object to the `toJson` converter function
//  3. catches errors and emits an 'error' event with their message
//  4. pushes string result from converter function on to next stream
//  5. emits a 'data' event with the string result
var transformToString = transforming.toString(toJson)

// create a pipeline
transformToObject.pipe(transformToString).pipe(process.stdout)

// write an object to the object converter (it's in the middle, that's okay)
transformToString.write({hello: 'there'})
// will output to console:
// {"hello":"there"}

transformToObject.write('{"hello":"there"}')
// will also output the same thing as above to the console:
// {"hello":"there"}
// because it makes it an object which is piped forward to the next transform
// which converts it back to a string before sending it to stdout
```

## MIT License
