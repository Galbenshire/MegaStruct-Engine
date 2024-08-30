// A special type of collidable that only acts solid to specific types of entities.
// Use the functions below to define the whitelist for a given instance of this collidable.
event_inherited();

entityWhitelist = [];
entityWhitelistCount = 0;

// Function - call this in Creation Code to add objects to this solid's whitelist
// e.g add_to_whitelist(objShieldAttacker);
function add_to_whitelist(_object) {
    array_push(entityWhitelist, _object);
    entityWhitelistCount++;
}

// Function - used during collision checks
function is_solid_to_entity(_entity) {
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
