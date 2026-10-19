// An area that can execute code whenever an specific entity overlaps

onEnter = undefined; /// @is {function<instance, void>?}
onExit = undefined; /// @is {function<instance, void>?}
onOverlap = undefined; /// @is {function<instance, void>?}

overlappers = [];
overlapCount = 0;

pauseMask = PauseType.GAMEPLAY;
if (triggerMidSectionSwitch)
    pauseMask = bitmask_unset_bit(pauseMask, PauseType.SECTION_SWITCH);

if (entityType != prtEntity && !object_is_ancestor(entityType, prtEntity)) {
    print_err($"Trigger Zone ({x}, {y}) configured to listen to a non-entity ({object_get_name(entityType)})");
    isActive = false;
}