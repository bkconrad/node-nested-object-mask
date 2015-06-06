# recursive-object-mask
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

#### Basic
```coffee
# the hero of our story
masker = require 'nested-object-mask'

# the source object we'd like to mask
object =
  keepThisKey: 'some value'
  subObject:
    alsoKeepThisKey: 'will do'
    filterThisKey: 'good bye :<'

# a mask that determines which keys will be kept from the original object if a
# property has a truthy value in the mask, it is kept from the original object
mask =
  keepThisKey: true
  subObject:
    alsoKeepThisKey: true
    filterThisKey: false

# do the thing!
result = masker.mask object, mask

# our result should look like this
expected = 
  keepThisKey: 'some value'
  subObject:
    alsoKeepThisKey: 'will do'

assert.deepEqual result, expected
```

#### The '*' Key
If you need to keep **all** "own" keys in an object, specify a '*' key in the
mask, like so:

```coffee
object:
  thing1: { foo: 1, bar: 2 }
  thing2: { foo: 2, baz: 2 }

mask:
  "*": { foo: true }

expected:
  thing1: { foo: 1 }
  thing2: { foo: 2 }

assert.deepEqual result, expected
```

Note that actual globbing is not currently supported, and that you will need to quote the key. Nesting 

## License

This software is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for more information.
