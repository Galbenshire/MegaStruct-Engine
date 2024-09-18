#region Substeps (mainly called during a Step Event)

/// @self {prtPlayer}
/// @func player_gravity()
/// @desc Works like the entity_gravity function, but takes the player's gravity locks into account
function player_gravity() {
    var _grav = grav * !player_is_action_locked(PlayerAction.GRAVITY);
    entity_gravity(_grav);
}

/// @self {prtPlayer}
/// @func player_handle_sections()
/// @desc Handles the player's interaction with screen sections
function player_handle_sections() {
	if (isIntro || global.switchingSections)
		return;
	
	var _section = global.section;
	if (!instance_exists(_section))
		return;
	
	var _checkX = clamp(x, _section.left + 4, _section.right - 4),
		_checkY = clamp(y, _section.top + 4, _section.bottom - 4),
		_transition = instance_position(_checkX, _checkY, objScreenTransition);
	if (instance_exists(_transition)) {
		if (isClimbing || isFreeMovement || _transition.image_angle != 90) {
			x = _checkX;
			y = _checkY;
			
			var _switch = instance_create_depth(x, y, depth, objSectionSwitcher);
			_switch.playerInstance = id;
			_switch.transitionInstance = _transition;
			return;
		}
	}
	
	var _fallingDown = (gravDir >= 0);
	x = clamp(x, _section.left, _section.right);
	y = _fallingDown ? max(y, _section.top - 32) : min(y, _section.bottom + 32);
	
	if (!canDieToPits)
		exit;
	
	var _fellIntoPit = _fallingDown ? y > _section.bottom + 16 : y < _section.top - 16;
	if (_fellIntoPit) {
		diedToAPit = true;
		stateMachine.change("Death");
	}
}

/// @self {prtPlayer}
/// @func player_handle_shooting()
/// @desc Handles the act of the player shooting
function player_handle_shooting() {
	autoFireTimer--;
	
	if (!is_undefined(weapon))
		weapon.on_tick(self);
	
	if (isShooting) {
		shootTimer = approach(shootTimer, 0, 1);
		if (shootTimer == 0) {
			isShooting = false;
			shootAnimation = 0;
			shootStandStillLock.deactivate();
		}
	}
}

/// @self {prtPlayer}
/// @func player_handle_switch_weapons()
function player_handle_switch_weapons() {
	if (loadoutSize <= 0 || player_is_action_locked(PlayerAction.WEAPON_CHANGE)) {
		quickSwitchTimer = 0;
		weaponIconTimer = 0;
		return;
	}
	
	var _index = array_get_index(loadout, weapon),
		_wpnSwitchLeft = inputs.is_held(InputActions.WEAPON_SWITCH_LEFT),
		_wpnSwitchRight = inputs.is_held(InputActions.WEAPON_SWITCH_RIGHT),
		_dir = _wpnSwitchRight - _wpnSwitchLeft;
	
	if (_dir != 0) {
		if (--quickSwitchTimer <= 0)
			_index = modf(_index + _dir, loadoutSize);
	} else if (_wpnSwitchLeft && _wpnSwitchRight) {
		_index = 0;
	} else {
		quickSwitchTimer = 0;
	}
	
	if (_index != NOT_FOUND && loadout[_index] != weapon) {
		player_equip_weapon(_index);
		
		with (prtProjectile) {
			if (owner == other.id)
				instance_destroy();
		}
		
		quickSwitchTimer = 8 + (10 * (quickSwitchTimer < 0));
		weaponIconTimer = 32;
		play_sfx(sfxWeaponSwitch);
		player_refresh_palette();
	}
	
	weaponIconTimer--;
}

/// @self {prtPlayer}
/// @func player_try_climbing()
/// @desc Function that checks if the player is able to climb a ladder
///
/// @returns {bool}  Whether the player can climb a ladder (true), or not (false)
function player_try_climbing() {
    ladderInstance = noone;
    
    if (yDir == 0 || player_is_action_locked(PlayerAction.CLIMB))
        return false;
    
    if (yDir != gravDir)
        ladderInstance = collision_line(bbox_x_center(), bbox_top + 2, bbox_x_center(), bbox_bottom - 1, objLadder, false, false);
    else if (ground)
        ladderInstance = instance_position(sprite_x_center(), bbox_vertical(gravDir) + gravDir, objLadder);
    
    return ladderInstance != noone;
}

/// @self {prtPlayer}
/// @func player_try_sliding()
/// @desc Function that checks if the player is able slide
///
/// @returns {bool}  Whether the player can slide (true), or not (false)
function player_try_sliding() {
	if (!ground || player_is_action_locked(PlayerAction.SLIDE))
        return false;
    
    var _input = inputs.is_pressed(InputActions.SLIDE) || (yDir == gravDir && inputs.is_pressed(InputActions.JUMP) && options_data().downJumpSlide);
    if (!_input)
		return false;
	
	// Check if there's space ahead
	mask_index = maskSlide;
	var _hasSpace = !test_move_x(image_xscale);
	mask_index = maskNormal;
    
    return _hasSpace;
}

#endregion

#region Player Functions

// That is, functions intended exclusively for the player entity

/// @func player_add_weapon(weapon_id, player)
/// @desc Gives a player object a weapon to add to their loadout
///
/// @param {int}  weapon_id  The ID of the weapon to add
/// @param {prtPlayer}  [player]  The player entity to add the weapon to. Defaults to the calling instance.
function player_add_weapon(_weaponID, _player = self) {
	PLAYER_ONLY_FUNCTION
	
	with (_player) {
		var _weapon = weapon_create_from_id(_weaponID);
		array_push(loadout, _weapon);
		loadoutSize = array_length(loadout);
	}
}

/// @func player_equip_weapon(weapon_or_loadout_index, player)
/// @desc Makes a player entity equip a weapon
///		  This can either be an actual Weapon instance,
///		  or an index from the player's loadout
///
/// @param {Weapon|int}  weapon_or_loadout_index  The ID of the weapon to add
function player_equip_weapon(_weaponOrLoadout, _player = self) {
	PLAYER_ONLY_FUNCTION
	
	with (_player) {
		var _weapon = undefined;
		if (is_instanceof(_weaponOrLoadout, Weapon))
			_weapon = _weaponOrLoadout;
		else if (is_numeric(_weaponOrLoadout))
			_weapon = array_at(loadout, _weaponOrLoadout);
		
		if (!is_undefined(playerUser))
			playerUser.hudElement.assign_weapon(_weapon);
		
		if (!is_undefined(weapon))
			weapon.on_unequip(self);
		weapon = _weapon;
		if (!is_undefined(weapon))
			weapon.on_equip(self);
	}
}

/// @func player_fire_weapon(params, player)
/// @desc Script to make the player fire a weapon.
///
/// @param {struct}  params  Defines various parameters of this projectile.
///		The list of applicable parameters are as follows:
///		-- REQUIRED --
///		- object: The object of the projectile to create
///		- cost: Uses up this many units of ammo to fire. If you have no ammo, this projectile will not be created.
///		- limit: A limit to the number of projectiles onscreen
///		- shootAnimation: The player's shoot animation after firing
///		-- OPTIONAL --
///		- weapon: What weapon this projectile is for. Used for ammo checks. Defaults to the player's current weapon
///		- offsetX: x-offset from the player, in addition to the base offset from the player's "gun" position
///		- offsetY: y-offset from the player, in addition to the base offset from the player's "gun" position
///		- depthOffset: Depth of the bullet relative to the player. Defaults to one value in front of the player
///		- standstill: A boolean for if the player should be put in a standstill. Defaults to false.
///		- autoShootDelay: Controls rate of fire when Auto-Fire is enabled
/// @param {prtPlayer}  [_player]
///
/// @returns {instance}  The projectile. Returns `noone` if something prevented a projectile being created.
function player_fire_weapon(_params = {}, _player = self) {
	PLAYER_ONLY_FUNCTION
	
	// Check for the bullet limit
	if (_params.limit > 0) {
		var _limit = _params.limit;
		
		with (prtProjectile) {
			if (owner != _player.id)
				continue;
			
			_limit -= bulletLimitCost;
			if (_limit <= 0)
				return noone;
		}
	}
	
	var _weapon = _params[$ "weapon"] ?? _player.weapon;
	
	// Check for ammo
	if (_params.cost > 0 && !is_undefined(_weapon)) {
		if (_weapon.ammo <= 0)
			return noone;
		
		_weapon.change_ammo(-_params.cost);
	}
	
	with (_player) {
		if (is_player_controlled() && !is_undefined(_weapon)) {
			var _hud = playerUser.hudElement;
			
			if (_hud.ammoWeapon == _weapon.id)
				_hud.ammo = _weapon.ammo;
		}
		
		isShooting = true;
		shootAnimation = _params.shootAnimation;
		shootTimer = 17;
		shootStandStillLock.deactivate();
		
		if (_params[$ "autoShootDelay"] ?? false)
			autoFireTimer = _params.autoShootDelay;
		
		var _standstill = _params[$ "standstill"] ?? false;
		if (_standstill || isClimbing) {
			if (xDir != 0 && !player_is_action_locked(PlayerAction.TURN_GROUND))
				image_xscale = xDir;
		}
		if (_standstill)
			shootStandStillLock.activate();
		
		// Make the bullet
		var _gunOffset = character.get_gun_offset(self);
		var _bulletX = x + (_gunOffset[Vector2.x] + (_params[$ "offsetX"] ?? 0)) * image_xscale,
			_bulletY = y + (_gunOffset[Vector2.y] + (_params[$ "offsetY"] ?? 0)) * image_yscale,
			_bulletDepth = depth + (_params[$ "depthOffset"] ?? 1),
			_bulletObj = _params.object;
		
		var _bullet = spawn_entity(_bulletX, _bulletY, _bulletDepth, _bulletObj, {
			image_xscale: sign(image_xscale),
			image_yscale: sign(image_yscale)
		});
		_bullet.owner = id;
		_bullet.playerID = playerID;
		
		signal_bus().emit_signal("playerShot", {
			player: other.id,
			projectile: _bullet
		});
		
		return _bullet;
	}
	
	return noone; // failsafe
}

/// @func player_generate_loadout()
/// @desc Generates a weapon loadout for the player, based on its character
///
/// @param {prtPlayer}  [player]
function player_generate_loadout(_player = self) {
	PLAYER_ONLY_FUNCTION
	
	with (_player) {
		var _loadout = character.loadout,
			_loadoutSize = array_length(_loadout);
		for (var i = 0; i < _loadoutSize; i++)
			player_add_weapon(_loadout[i]);
	}
}

/// @func player_is_action_locked(player_action, player)
/// @desc Checks if the specified player action is locked on the given player entity
///
/// @param {int}  player_action
/// @param {prtPlayer}  [player]
function player_is_action_locked(_action, _player = self) {
	PLAYER_ONLY_FUNCTION
	
	var _result = _player.lockpool.is_locked(_action);
	if (!is_undefined(_player.playerUser))
		_result |= _player.playerUser.lockpool.is_locked(_action);
	
	return _result;
}

/// @func player_refresh_palette(player)
/// @desc Updates the player's palette
///
/// @param {prtPlayer}  [player]
function player_refresh_palette(_player = self) {
	PLAYER_ONLY_FUNCTION
	
	with (_player) {
		var _characterPalette = character.get_colours();
		
		if (!is_undefined(weapon)) {
			var _weaponPalette = weapon.get_colours();
			_characterPalette[PalettePlayer.primary] = _weaponPalette[PaletteWeapon.primary];
			_characterPalette[PalettePlayer.secondary] = _weaponPalette[PaletteWeapon.secondary];
		}
		
		for (var i = 0; i < palette.colourCount; i++) {
			palette.set_output_colour_at(i, _characterPalette[i]);
			paletteCache.set_output_colour_at(i, _characterPalette[i]);
		}
		
		if (!is_undefined(playerUser))
			playerUser.hudElement.ammoPalette = array_slice(palette.outputColours, 0, 3);
	}
}

/// @func player_restore_ammo(value, weapon, player)
/// @desc Restores a player's weapon ammo by the given amount
function player_restore_ammo(_value, _weapon, _player = self) {
	PLAYER_ONLY_FUNCTION
	
	var _restorer = instance_exists(objHealthRestoreEffect)
		? instance_nearest(0, 0, objHealthRestoreEffect)
		: instance_create_layer(0, 0, LAYER_SYSTEM, objHealthRestoreEffect);
	
	var _weaponIndex = array_get_index(_restorer.ammo[0], _weapon);
	if (_weaponIndex == NOT_FOUND) {
		array_push(_restorer.ammo[0], _weapon);
		array_push(_restorer.ammo[1], _value);
		_restorer.ammoCount++;
	} else {
		_restorer.ammo[_weaponIndex] += _value;
	}
}

/// @func player_restore_health(value, player)
/// @desc Restores a player's health by the given amount
function player_restore_health(_value, _player = self) {
	PLAYER_ONLY_FUNCTION
	
	var _restorer = instance_exists(objHealthRestoreEffect)
		? instance_nearest(0, 0, objHealthRestoreEffect)
		: instance_create_layer(0, 0, LAYER_SYSTEM, objHealthRestoreEffect);
	
	_restorer.healthpoints += _value;
}

/// @func player_shot_input(auto_fire, player)
/// @desc Helper function for if the player is trying to input a shoot action.
///		  This function will check if the player is in a state where they are able to do so.
///		  Mainly used by weapons to know if the player is trying to shoot a projectile.
/// @param {bool}  [auto_fire]  Whether the function sould use the auto-fire beaviour (true) or not (false). Defaults to whatever is set in options_data
/// @param {prtPlayer}  [player]  The player trying to shoot. Defaults to the calling instance.
///
/// @returns {bool}  Whether the player can fire a shot (true), or not (false)
function player_shot_input(_autoFire = options_data().autoFire, _player = self) {
	PLAYER_ONLY_FUNCTION
	
	if (player_is_action_locked(PlayerAction.SHOOT, _player))
		return false;
	
	return _autoFire
		? _player.inputs.is_held(InputActions.SHOOT) && _player.autoFireTimer <= 0
		: _player.inputs.is_pressed(InputActions.SHOOT);
}

#endregion

#region Other

/// @func is_a_player(scope)
/// @desc Checks if the specified instance is a player object.
///
/// @param {instance}  [scope]  The instance to check. Defaults to the calling instance.
///
/// @returns {bool}  Whether the instance is a player (true), or not (false)
function is_a_player(_scope = self) {
    return is_object_type(prtPlayer, _scope);
}

/// @func is_player_controlled(scope)
/// @desc Checks if the specified player entity is being controlled by a player user.
///
/// @param {prtPlayer}  [scope]  The player entity to check. Defaults to the calling instance.
///
/// @returns {bool}  Whether the player is being controlled (true), or not (false)
function is_player_controlled(_scope = self) {
	return is_a_player(_scope) ? !is_undefined(_scope.playerUser) : false;
}

/// @func spawn_player_entity(x, y, depth_or_layer, character_id)
/// @desc Creates an instance of a player character
///
/// @param {number}  x  The x position the player will be created at
/// @param {number}  y  The y position the player will be created at
/// @param {number|layer|string}  depth_or_layer
/// @param {number}  character_id
///
/// @returns {prtPlayer}
function spawn_player_entity(_x, _y, _depthOrLayer, _characterID) {
	var _character = character_create_from_id(_characterID);
	var _body = spawn_entity(_x, _y, _depthOrLayer, _character.object, {
		character: _character
	});
	return _body;
}

#endregion
