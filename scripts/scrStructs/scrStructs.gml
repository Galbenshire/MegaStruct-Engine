/// @func struct_copy(dest, src)
/// @desc Copies the data from one struct into another struct
///
/// @param {struct}  dest  The reference to the struct to copy to.
/// @param {struct}  src  The reference to the struct to copy from.
function struct_copy(_dest, _src) {
    var _srcNames = struct_get_names(_src);
    
    var i = 0; repeat(array_length(_srcNames)) {
        var _name = _srcNames[i];
        _dest[$ _name] = _src[$ _name];
        
        i++;
    }
}

/// @func struct_merge(a, b, overwrite_a)
/// @desc Creates a new struct by merging two seperate structs together
///
/// @param {struct}  a  The base struct
/// @param {struct}  b  The struct to merge into `a`
/// @param {bool}  [overwrite_a]  Whether to prioritize data from `a` (false) or `b` (true). Defaults to true.
///
/// @returns {struct}  The merged struct
function struct_merge(_a, _b, _overwriteA = true) {
    var _merged = variable_clone(_a),
        _bNames = struct_get_names(_b);
    
    var i = 0; repeat(array_length(_bNames)) {
        var _name = _bNames[i];
        if (_overwriteA || !struct_exists(_merged, _name))
            _merged[$ _name] = _b[$ _name];
        
        i++;
    }
    
    return _merged;
}

/// @func struct_remove_all(struct)
/// @desc Removes all variables from a struct, without deleting it
///
/// @param {struct}  struct  The struct reference to remove all variables from
function struct_remove_all(_struct) {
    var _names = struct_get_names(_struct);
    var i = 0; repeat(array_length(_names)) {
        struct_remove(_struct, _names[i]);
        i++;
    }
}
