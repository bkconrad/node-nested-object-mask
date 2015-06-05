###
kaen\recursive-object-mask

Licensed under the MIT license
For full copyright and license information, please see the LICENSE file

@author     Bryan Conrad <bkconrad@gmail.com>
@copyright  2015 Bryan Conrad
@link       https://github.com/kaen/recursive-object-mask
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
    result = { }
    for k,v of mask
      result[k] = object[k]

    result

