// *Very* stripped down version of the normal entity step code.
// These eggs tend to be in very high numbers when present,
// and since they are never intended to do any entity physics,
// cutting it out should help with framerates.
if (entity_is_dead() && !entity_can_respawn())
	instance_destroy();