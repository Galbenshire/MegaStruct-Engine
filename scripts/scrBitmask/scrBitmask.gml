/// @func bitmask_has_bit(bitmask, bit)
/// @desc Checks if the given bitmask has a particular bit set
///
/// @param {int}  bitmask  The bitmask to use
/// @param {int}  bit  The bit to check for
///
/// @returns {bool}  Whether the bitmask has the bit set (true) or not (false)
function bitmask_has_bit(_mask, _bit) {
    return bool(_mask & _bit);
}

/// @func bitmask_merge_bits(bits)
/// @desc Merges all given bits into a bitmask
///
/// @param {array<int>}  bits  The bits to merge
///
/// @returns {int}  The resulting bitmask
function bitmask_merge_bits(_bits) {
    return array_reduce(_bits, function(_prev, _curr, i) /*=>*/ {return bitmask_set_bit(_prev, _curr)}, 0);
}

/// @func bitmask_set_bit(bitmask, bit)
/// @desc Sets the specified bit on a given bitmask
///
/// @param {int}  bitmask  The bitmask to use
/// @param {int}  bit  The bit to set
///
/// @returns {int}  The new bitmask
function bitmask_set_bit(_mask, _bit) {
    return _mask | _bit;
}

/// @func bitmask_toggle_bit(bitmask, bit)
/// @desc Toggles the specified bit on a given bitmask
///
/// @param {int}  bitmask  The bitmask to use
/// @param {int}  bit  The bit to toggle
///
/// @returns {int}  The new bitmask
function bitmask_toggle_bit(_mask, _bit) {
    return _mask ^ _bit;
}

/// @func bitmask_unset_bit(bitmask, bit)
/// @desc Unsets the specified bit on a given bitmask
///
/// @param {int}  bitmask  The bitmask to use
/// @param {int}  bit  The bit to unset
///
/// @returns {int}  The new bitmask
function bitmask_unset_bit(_mask, _bit) {
    return _mask & ~_bit;
}
