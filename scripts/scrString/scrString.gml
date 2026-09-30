#region Searching and Information

/// @func string_contains(substr, str)
/// @desc This function returns if the given string contains the sustring specified
///
/// @param {string}  substr  The substring to look for
/// @param {string}  str  The string to check in
///
/// @returns {bool}  Whether the string contains the substring (true) or not (false)
function string_contains(_substr, _str) {
	return string_pos(_substr, _str) != 0;
}

/// @func string_empty(str)
/// @desc This function returns if the given string is empty
///
/// @param {string}  str  The string to check
///
/// @returns {bool}  Whether the string is empty (true) or not (false)
function string_empty(_str) {
	return string_length(_str) == 0;
}

/// @func string_random_char(str)
/// @desc Gets a random char from a given string
///
/// @param {string}  str  The string to use
///
/// @returns {string}  A random char from the string
function string_random_char(_str) {
	return string_char_at(_str, irandom(string_length(_str)));
}

#endregion