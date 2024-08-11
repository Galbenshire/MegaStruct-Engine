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

/// @func array_find(array, predicate, offset, length)
/// @desc This function is used to find the first array element that satisfies a condition.
///
/// @param {array}  array  The array to use
/// @param {function<any,int,bool>}  predicate  The Predicate Method to run on each element
/// @param {int}  [offset]  The offset, or starting index, in the array. Defaults to 0, the first index.
/// @param {int}  [length]  The number of elements to traverse. Defaults to infinity, which means traverse the whole array.
///
/// @returns {any?}  The first element found, or `undefined` if nothing is found
function array_find(_array, _predicate, _offset = 0, _length = infinity) {
	var _index = array_find_index(_array, _predicate, _offset, _length);
	return (_index != NOT_FOUND) ? _array[_index] : undefined;
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

/// @func ds_list_to_array(list, destroy_list)
/// @desc Converts a DS List to an array.
///
/// @param {ds_list}  list  The list to convert
/// @param {bool}  list  Whether to destroy the list given afterwards (true) or not (false). Defaults to true.
///
/// @returns {array}  An array version of the list
function ds_list_to_array(_list, _destroyList = true) {
	var _count = ds_list_size(_list),
        _array = array_create(_count);
    
    for (var i = 0; i < _count; i++)
        _array[i] = _list[| i];
    
    if (_destroyList)
		ds_list_destroy(_list);
    
    return _array;
}
