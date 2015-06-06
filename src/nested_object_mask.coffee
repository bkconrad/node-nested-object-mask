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
SimpleClass documentation

@since  0.1.0
###
module.exports =

  ###
  Recursively mask an object

  @param    {object} object The object to filter via `mask`
  @param    {object} mask The mask to filter `object` with
  @return   string
  @since    0.1.0
  ###
  mask: (object, mask) ->
    return undefined if mask == false
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
      
      maskedSubObject = module.exports.mask(object[k], subMask)
      unless object[k] == undefined or maskedSubObject == undefined
        result[k] = module.exports.mask(object[k], subMask)

    result

