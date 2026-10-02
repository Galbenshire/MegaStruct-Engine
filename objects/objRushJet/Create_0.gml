event_inherited();

characterSpecs ??= character_create_from_id(characterID); /// @is {Character}
assert(!is_undefined(characterSpecs), $"Invalid characterID provided for {object_get_name(object_index)} (ID: {characterID})");

sprite_index = characterSpecs.get_sprite(PlayerSpriteType.JET);

stateMachine = new StateStacker("TeleportIn", true);
palette = new ColourPalette(characterSpecs.jetColours);
jetLock = new PlayerLockPoolSwitch(undefined, PlayerAction.MOVE_GROUND, PlayerAction.TURN_GROUND, PlayerAction.CLIMB, PlayerAction.SLIDE);
weapon = undefined; // If tied to a weapon, it will decrement ammo on use

teleportIndex = 0;
teleportFrames = [0, 1, 0, 2];
teleportFrameCount = array_length(teleportFrames);

// Callbacks
onSpawn = function() {
	cbkOnSpawn_base();
	owner.lockpool.add_switch(jetLock);
};
onDeath = function(_damageSource) {
	cbkOnDeath_projectile(_damageSource);
	instance_create_depth(bbox_x_center(), bbox_y_center(), depth, objExplosion);
};
onDraw = function() {
	var _y = y;
	if (sprite_index == sprRushTeleport)
		y -= 16 * image_yscale;
	cbkOnDraw_colour_replacer();
	y = _y;
};

event_user(EVENT_PLAYER_STATEMACHINE_INIT); // Init the State Machine