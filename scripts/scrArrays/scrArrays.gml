/// @func array_at(array, index)
/// @desc Retrieves the value in an array at the specified index.
///		  If the index is negative, it will search from the back of the array.
///
/// @param {array}  array  The array to check
/// @param {int}  index  The index of the array element to get the value from. Negative values will search backwards.
///
/// @returns {any}  The value at the given index. Returns `undefined` of the index would go beyond the range of the array.
function array_at(_array, _index) {
	var _length = array_length(_array);
	
	if (_index < -_length || _index >= _length)
		return undefined;
	
	return (_index >= 0) ? _array[_index] : _array[_index + _length];
}

/// @func array_empty(array)
/// @desc Checks if the given array is empty
///
/// @param {array}  array  The array to check
///
/// @returns {bool}  Whether the array is empty (true) or not (false)
function array_empty(_array) {
	return array_length(_array) <= 0;
}

/// @func array_slice(array, offset, length)
/// @desc Returns a portion of the given array
///
/// @param {array}  array  The array to slice
/// @param {int}  offset  The index within the array to start slicing from
/// @param {int}  length  The number of array indices to slice
///
/// @returns {array}  The sliced array
function array_slice(_array, _offset, _length) {
	var _slicedArray = [];
	array_copy(_slicedArray, 0, _array, _offset, _length);
	return _slicedArray;
}

/// @func choose_from_array(array)
/// @desc Chooses a random element from the given array
///
/// @param {array}  array  The array to choose from
///
/// @returns {any}  The chosen element from the array
function choose_from_array(_array) {
    var _count = array_length(_array);
    return _array[irandom(_count - 1)];
}

/// @func ds_list_to_array(list)
/// @desc Converts a DS List to an array.
///		  NOTE: This will destroy the original list.
///
/// @param {ds_list}  list  The list to convert
///
/// @returns {array}  An array version of the list
function ds_list_to_array(_list) {
	var _count = ds_list_size(_list),
        _array = array_create(_count);
    
    for (var i = 0; i < _count; i++)
        _array[i] = _list[| i];
    
    ds_list_destroy(_list);
    return _array;
}
