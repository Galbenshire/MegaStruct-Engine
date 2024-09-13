/// @func activate_game_objects(section)
/// @desc Activates all objects within the given section
///
/// @param {objSection}  [section]  The section to check against. Defaults to the current section.
function activate_game_objects(_section = global.section) {
    var _left = _section.left + 0.5,
        _top = _section.top + 0.5,
        _width = _section.right - _section.left - 1,
        _height = _section.bottom - _section.top - 1;
    instance_activate_region(_left, _top, _width, _height, true);
}

/// @func deactivate_game_objects(reset_entities, section)
/// @desc Iterates through all active objects, deactivating them based on various criteria
///
/// @param {bool}  [reset_entities]  If true, entities are not reset when deactivated. Defaults to true.
/// @param {objSection}  [section]  The section to check against. Defaults to the current section.
function deactivate_game_objects(_resetEntities = true, _section = global.section) {
    var _switchingSections = global.switchingSections;
    
    with (all) {
        // Ignore all objects tagged to always be active
        if (asset_has_tags(object_index, "active_always"))
            continue;
        
        // Effects are destroyed
        if (is_object_type(prtEffect)) {
            instance_destroy();
            continue;
        }
        
        // For entities, it depends...
        if (is_object_type(prtEntity)) {
            var _keep = (sectionSwitchBehaviour == SectionSwitchBehaviour.HIDDEN)
                ? false
                : (_switchingSections || place_meeting(x, y, _section));
            if (_keep)
                continue;
            
            if (_resetEntities && (sectionSwitchBehaviour != SectionSwitchBehaviour.PERSISTANT || entity_is_dead())) {
                lifeState = LifeState.DEAD_ONSCREEN;
                __isKilled = false;
                onDespawn();
                event_perform(ev_step, ev_step_begin);
                lifeState = LifeState.DEAD_OFFSCREEN;
                
                if (!instance_exists(id))
                    continue;
            }
            
            if (sectionSwitchBehaviour != SectionSwitchBehaviour.PERSISTANT)
                instance_deactivate_object(id);
            
            continue;
        }
        
        // Intervals reset their timer before deactivating
        if (is_object_type(prtInterval)) {
            timer = startingWaitTime;
            instance_deactivate_object(id);
            continue;
        }
        
        // Anything else, deactivate them
        // If they're tagged as a special object though, keep them if in the current section, or in a section switch
        var _keep = false;
		if (asset_has_tags(object_index, "active_special"))
			_keep = _switchingSections || place_meeting(x, y, _section);
		if (!_keep)
			instance_deactivate_object(id);
    }
}
