/// @description Entity Posttick
stateMachine.posttick();
stateMachine.update_timer();

if (entity_is_dead())
	exit;

self.handle_switching_weapons();
self.handle_shooting();
self.handle_animation();
self.handle_sections();