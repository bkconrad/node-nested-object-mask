# nested-object-mask (NOM)
[![NPM Version](https://badge.fury.io/js/nested-object-mask.png)](https://npmjs.org/package/nested-object-mask)
[![Build Status](https://secure.travis-ci.org/bkconrad/node-nested-object-mask.png)](http://travis-ci.org/bkconrad/node-nested-object-mask)
[![Built with Grunt](https://cdn.gruntjs.com/builtwith.png)](http://gruntjs.com)

> Like `object-mask`, but nested

Note: This library contains a *rich* nested object masking implementation, and
has more complicated semantics than similar libraries for flat object masking.
If you do not specifically need the *nesting* support from this library, try
`object-mask` instead for a simpler mental model.

## Installation Instructions

Install the module via npm: `npm install nested-object-mask`

## Usage
*NB: `nested-object-mask` works happily with plain JS, but it is written in coffeescript, and so are the examples below (because it's 2015).*

#### Basic
At its simplest, `nested-object-mask` does this:
```coffee
# the hero of our story
masker = require 'nested-object-mask'

# the source object we'd like to mask
object =
  keepThisKey: 'some value'
  dontKeepThisKey: 'good bye :<'

# a mask that determines which keys will be kept from the original object. if a
# property has a truthy value in the mask, it is kept from the original object
mask =
  keepThisKey: true

# our result should look like this
expected = 
  keepThisKey: 'some value'

# do the thing!
result = masker.mask object, mask

# looks good :)
assert.deepEqual result, expected
```


## License

This software is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for more information.
