/// @description Entity Posttick
stateMachine.posttick();
stateMachine.update_timer();

if (entity_is_dead())
	exit;

self.handle_switching_weapons();
self.handle_shooting();

if (!self.is_action_locked(PlayerAction.SPRITE_CHANGE))
	event_user(10);

self.handle_sections();