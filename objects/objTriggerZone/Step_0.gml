image_blend = c_gray;

if (!game_can_step(pauseMask))
    exit;
if (!isActive) {
    if (overlapCount > 0) {
        array_clear(overlappers);
        overlapCount = 0;
    }
    if (removeIfInactive)
        instance_destroy();
    exit;
}

image_blend = c_white;

var _definedEnter = !is_undefined(onEnter),
    _definedExit = !is_undefined(onExit),
    _definedOverlap = !is_undefined(onOverlap);

// Check for new overlappers
if (place_meeting(x, y, entityType)) {
    var _collideList = ds_list_create(),
        _collideCount = instance_place_list(x, y, entityType, _collideList, false);
    
    var i = 0; repeat(_collideCount) {
        var _entity = _collideList[| i];
        
        if (!entity_is_dead(_entity) && !array_contains(overlappers, _entity)) {
            array_push(overlappers, _entity);
            overlapCount++;
            
            if (_definedEnter)
                onEnter(_entity);
        }
        
        i++;
    }
    
    ds_list_destroy(_collideList);
}

// Handle current (& new) overlappers
var i = overlapCount - 1; repeat(overlapCount) {
    var _entity = overlappers[i],
        _remove = false;
    
    if (!instance_exists(_entity) || entity_is_dead(_entity)) {
        _remove = true;
    } else {
        if (!place_meeting(x, y, _entity)) {
            if (_definedExit)
                onExit(_entity);
            _remove = true;
        } else if (_definedOverlap) {
            onOverlap(_entity);
        }
    }
    
    if (_remove) {
        array_delete(overlappers, i, 1);
        overlapCount--;
    }
    
    i--;
}
