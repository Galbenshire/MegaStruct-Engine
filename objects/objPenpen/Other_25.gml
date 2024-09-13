/// @description Post Tick
event_inherited();

image_index += animSpeed;

if (xcoll != 0) {
    if (itemDropType != ItemDropType.CUSTOM)
        itemDropType = ItemDropType.NONE;
    
    entity_kill_self();
}
