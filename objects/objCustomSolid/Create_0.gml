event_inherited();

entityWhitelist = [];
entityWhitelistCount = 0;

// Function - call this in Creation Code to add objects to this solid's whitelist
// e.g addToWhiteList(objShieldAttacker);
function addToWhiteList(_object) {
    array_push(entityWhitelist, _object);
    entityWhitelistCount++;
}

// Function - used during collision checks
function isSolidToEntity(_entity) {
    var _result = false;
    
    var i = 0;
    repeat(entityWhitelistCount) {
        _result = is_object_type(entityWhitelist[i], _entity);
        i++;
        if (_result)
            break;
    }
    
    if (invertWhitelist)
        _result = !_result;
    
    return _result;
}
