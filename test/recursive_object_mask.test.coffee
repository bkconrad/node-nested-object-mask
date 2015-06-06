should = require 'should'
expect = require('chai').expect
masker = require '../src/recursive_object_mask'


SUITES = 
  'masks root-level keys':
    object: 
      foo: 1
      bar: 2

    mask:
      foo: true

    expected:
      foo: 1

  'masks nested objects':
    object: 
      obj: {
        sub1: {
          foo: 1
          bar: 2
          baz: 3
        }
        sub2: {
          foo: 4
          bar: 5
          baz: 6
        }
      }
      bar: 2

    mask:
      obj: {
        sub1: {
          foo: true
          bar: true
        }
        sub2: {
          foo: true
          bar: true
        }
      }

    expected:
      obj: {
        sub1: {
          foo: 1
          bar: 2
        }
        sub2: {
          foo: 4
          bar: 5
        }
      }

  'even allows properties whose values are undefined':
    object: 
      foo: 1
      bar: undefined

    mask:
      foo: true
      bar: undefined

    expected:
      foo: 1

  'respects * keys found in masks':
    object: 
      obj: {
        thing1: { foo: 1, bar: 2 }
        thing2: { foo: 2, baz: 2 }
      }
      willBeEmptyWhenFiltered: {
        thing1: { foo: 1, bar: 2 }
        thing2: { foo: 2, baz: 2 }
      }

    mask:
      obj: {
        "*": {
          "*": true
        }
      }
      willBeEmptyWhenFiltered: {
        thing3: true
      }

    expected:
      obj: {
        thing1: { foo: 1, bar: 2 }
        thing2: { foo: 2, baz: 2 }
      }
      willBeEmptyWhenFiltered: {

      }

  'masks work on array elements too':
    object: 
      foo: 'not kept'
      arr: [
        { foo: 1, bar: 2 }
        { foo: 2, baz: 2 }
      ]
      starArray: [
        { foo: 1, bar: 2 }
        { foo: 2, baz: 2 }
      ]

    mask:
      arr: { 1: true }
      starArray: { '*': { foo: true } }

    expected:
      # basically, this should be an array with no value set for [0], but a
      # value set for [1] (which is destinct from the literal [ undefined,
      # 'foo' ]). this is essentially a literal for the following two lines:
      # a = []
      # a[1] = foo
      #
      # use console.log if you still don't understand :)
      arr: ((x)-> x[1] = { foo: 2, baz: 2 } ; x)([])

      starArray: [
        { foo: 1 }
        { foo: 2 }
      ]



describe 'masker', () ->
  describe 'mask', () ->
    for message, spec of SUITES
      do (message, spec) ->
        it message, ->
          result = masker.mask spec.object, spec.mask
          expect(result)
            .to.deep.equal spec.expected
