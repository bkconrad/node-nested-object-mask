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

  'even allows properties whose values are undefined':
    object: 
      foo: 1
      bar: undefined

    mask:
      foo: true
      bar: undefined

    expected:
      foo: 1

  'implicitly keeps all array elements':
    object: 
      foo: 'not kept'
      arr: [
        { foo: 1, bar: 2 }
        { foo: 2, baz: 2 }
      ]

    mask:
      arr: { foo: true }

    expected:
      arr: [
        { foo: 1 }
        { foo: 2 }
      ]

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
          foo: true
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

describe 'masker', () ->
  describe 'mask', () ->
    for message, spec of SUITES
      do (message, spec) ->
        it message, ->
          expect(masker.mask spec.object, spec.mask)
            .to.deep.equal spec.expected
