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

#### Nesting
If you made it here, it's probably because you need *nested* masking. Here it is:

```coffee
object =
  keepThisKey: 'some value'
  subObject:
    alsoKeepThisKey: 'will do'
    dropThisKey: 'good bye :<'

mask =
  keepThisKey: true
  subObject:
    alsoKeepThisKey: true
    dropThisKey: false

expected = 
  keepThisKey: 'some value'
  subObject:
    alsoKeepThisKey: 'will do'
```

#### Pruning
You can also prune empty objects and arrays from the result. Simply pass `pruneEmpty: true` in the options hash:

```coffee
object =
  empty: { }
  emptyWhenFiltered:
    foo: 'bar'
  notEmptyWhenFiltered:
    keepMe: 'some value'

mask =
  empty: true
  emptyWhenFiltered:
    doesNotExist: true
  notEmptyWhenFiltered:
    keepMe: true

expected =
  notEmptyWhenFiltered:
    keepMe: 'some value'

result = masker.mask object, mask, pruneEmpty: true
```

Without pruning, the result of the above would retain the empty objects, and would instead look like:
```coffee
empty: { }
emptyWhenFiltered: { }
notEmptyWhenFiltered:
  keepMe: 'some value'
```

#### The '*' Key
If you need to keep **all** "own" keys in an object, specify a `'*'` key in the
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

Note that actual globbing is not currently supported, and that you will need to quote the key. Nesting `'*'` keys is also valid, like so:

```coffee
mask:
  '*': { '*': true }
```

#### Truthiness
It is **highly recommended** that you construct your mask using only `true`, `false`, and objects when possible. When creating a mask by iterating over a domain object, make sure to set each value to a boolean for the least complications.

If you can not create an ideal `true`/`false`-based mask, NOM will apply general JavaScript "truthiness" to your keys. You should at least be aware of some caveats (the empty string in particular):

```coffee
object:
  trueTrue: 'kept'
  trueOne: 'kept'
  trueString: 'kept'
  trueObject: 'kept'
  trueArray: 'kept'
  trueRegex: 'kept'
  falseFalse: 'dropped'
  falseString: 'dropped'
  falseNull: 'dropped'
  falseZero: 'dropped'
  falseNaN: 'dropped'
  falseUndefined: 'dropped'

mask:
  trueTrue: true
  trueOne: 1
  trueString: 'yes'
  trueObject: {}
  trueArray: []
  trueRegex: /asdf/
  falseFalse: false
  falseString: ''
  falseNull: null
  falseZero: 0
  falseNaN: NaN
  falseUndefined: undefined

expected:
  trueTrue: 'kept'
  trueOne: 'kept'
  trueString: 'kept'
  trueObject: 'kept'
  trueArray: 'kept'
  trueRegex: 'kept'
```

## License

This software is licensed under the **MIT License**. See the [LICENSE](LICENSE) file for more information.
