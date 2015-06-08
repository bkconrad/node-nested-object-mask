_ = require 'lodash'
###
kaen\recursive-object-mask

Licensed under the MIT license
For full copyright and license information, please see the LICENSE file

@author     Bryan Conrad <bkconrad@gmail.com>
@copyright  2015 Bryan Conrad
@link       https://github.com/kaen/node-nested-object-mask
@license    http://choosealicense.com/licenses/MIT  MIT License
###

###
@mixin Masker
@since  0.1.0
###
Masker =

  ###
  The only function you'll ever need :)

  See the examples below for details about options and general rules of
  operation.

  If you can not read coffeescript object literals, you can read the compiled
  JS of the examples below in [this gist](https://gist.github.com/bkconrad/4a809a7f6076474e56d8)

  @example Nested masking
    object =
      keepThisKey: 'some value'
      subObject:
        alsoKeepThisKey: 'will do'
        dropThisKey: 'good bye :<'

    mask =
      keepThisKey: true
      # mask within a mask -- maskception
      subObject:
        alsoKeepThisKey: true
        dropThisKey: false

    expected = 
      keepThisKey: 'some value'
      subObject:
        alsoKeepThisKey: 'will do'

  @example Pruning
    # You can also prune empty objects and arrays from the result. Simply pass
    # `pruneEmpty: true` in the options hash:
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

    # Without pruning, the result of the above would retain the empty objects,
    # and would instead look like:
    empty: { }
    emptyWhenFiltered: { }
    notEmptyWhenFiltered:
      keepMe: 'some value'

  @example The '*' Key
    # If you need to keep **all** "own" keys in an object, specify a `'*'` key
    # in the   mask, like so:
    object =
      thing1: { foo: 1, bar: 2 }
      thing2: { foo: 2, baz: 2 }

    mask =
      "*": { foo: true }

    expected =
      thing1: { foo: 1 }
      thing2: { foo: 2 }

    assert.deepEqual result, expected

    # Note that actual globbing is not currently supported, and that you will
    # need to quote the key. Nesting `'*'` keys is also valid, like so:
    mask =
      '*': { '*': true }

  @example Truthiness
    # It is **highly recommended** that you construct your mask using only
    # `true`, `false`, and objects when possible. When creating a mask by
    # iterating over a domain object, make sure to set each value to a boolean
    # for the least complications.

    # If you can not create an ideal `true`/`false`-based mask, NOM will apply
    # general JavaScript "truthiness" to your keys. You should at least be aware
    # of some caveats (the empty string in particular):

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


  @param    {any} object The object to filter via `mask`
  @param    {any} mask The mask to filter `object` with
  @param    {object} options Options to use while masking
  @option   options [boolean] pruneEmpty When true, recursively prunes empty objects and arrays from the result
  @return   any
  @since    0.1.0
  ###
  mask: (object, mask, options) ->
    options = options || { }
    return undefined unless mask
    return object unless _.isObject(object) or _.isArray(object)

    # if the mask contains a key that is simply an asterisk, all  of the
    # object's "own" properties will be passed through. this is achieved by
    # simply setting the original object as the "iteratee" rather than the
    # mask
    result = if _.isArray(object) then [] else {}
    permitAll = _.has(mask, '*') or mask == true
    iteratee = if permitAll then object else mask
    for own k,v of iteratee
      subMask = undefined
      if _.has(mask, k)
        subMask = mask[k]
      else # if permitAll <-- this is always true here
        if _.has(mask, '*')
          subMask = mask['*']
        else
          subMask = { '*': true }
      
      maskedSubObject = module.exports.mask(object[k], subMask, options)
      shouldPruneValue = (options.pruneEmpty && _.isEmpty(maskedSubObject))
      valueWasEmpty = object[k] == undefined
      valueIsEmpty = maskedSubObject == undefined
      unless shouldPruneValue or valueWasEmpty or valueIsEmpty
        result[k] = maskedSubObject

    result

module.exports = Masker
