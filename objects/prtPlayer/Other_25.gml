/// @description Entity Posttick
stateMachine.tick("posttick");
stateMachine.update_state();

self.handle_switching_weapons();
self.handle_shooting();
self.handle_animation();
self.handle_sections();