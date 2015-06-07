expect = require('chai').expect
masker = require '../src/nested_object_mask'


PRUNE_EMPTY_SUITES =
  'prunes empty objects':
    object:
      empty: { }
      emptyWhenFiltered:
        foo: 'bar'
      notEmptyWhenFiltered:
        keepMe: 'some value'

    mask:
      empty: true
      emptyWhenFiltered:
        doesNotExist: true
      notEmptyWhenFiltered:
        keepMe: true

    expected:
      notEmptyWhenFiltered:
        keepMe: 'some value'

describe 'masker', () ->
  describe 'mask', () ->
    describe 'given { pruneEmpty: true }', () ->
      for message, spec of PRUNE_EMPTY_SUITES
        do (message, spec) ->
          it message, ->
            result = masker.mask spec.object, spec.mask, pruneEmpty: true
            expect(result)
              .to.deep.equal spec.expected
