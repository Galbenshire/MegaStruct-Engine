#region Substeps (mainly called during a Step Event)

/// @self {prtPlayer}
/// @func player_gravity()
/// @desc Works like the entity_gravity function, but takes the player's gravity locks into account
function player_gravity() {
    var _grav = grav * !lockpool.is_locked(PlayerAction.GRAVITY);
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
	
	var _transition = instance_position(x, y, objScreenTransition);
	if (instance_exists(_transition)) {
		var _isValid = inside_section_point(_transition.centerX, _transition.centerY);
		if (_transition.image_angle == 90)
			_isValid &= isClimbing;
		
		if (_isValid) {
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
	if (!is_undefined(weapon))
		weapon.onTick(self);
	
	if (isShooting) {
		shootTimer = approach(shootTimer, 0, 1);
		if (shootTimer == 0) {
			isShooting = false;
			shootAnimation = 0;
		}
	}
}

/// @self {prtPlayer}
/// @func player_handle_switch_weapons()
function player_handle_switch_weapons() {
	if (loadoutSize <= 0 || lockpool.is_locked(PlayerAction.WEAPON_CHANGE)) {
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
	
	if (loadout[_index] != weapon) {
		if (!is_undefined(weapon))
			weapon.onUnequip(self);
		weapon = loadout[_index];
		weapon.onEquip(self);
		
		with (prtProjectile) {
			if (owner == other.id)
				instance_destroy();
		}
		
		quickSwitchTimer = 8 + (10 * (quickSwitchTimer < 0));
		weaponIconTimer = 32;
		play_sfx(sfxWeaponSwitch);
		player_refresh_palette_body();
		player_refresh_palette_icon();
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
    
    if (yDir == 0 || lockpool.is_locked(PlayerAction.CLIMB))
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
	if (!ground || lockpool.is_locked(PlayerAction.SLIDE))
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
/// @desc Gives a player object a weapon
///
/// @param {int}  weapon_id  The ID of the weapon to add
/// @param {prtPlayer}  [player]  The player entity to add the weapon to. Defaults to the calling instance.
function player_add_weapon(_weaponID, _player = self) {
	PLAYER_ONLY_FUNCTION
	
	with (_player) {
		var _weapon = global.weaponList[_weaponID].instantiate();
		array_push(loadout, _weapon);
		loadoutSize = array_length(loadout);
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
		isShooting = true;
		shootAnimation = _params.shootAnimation;
		shootTimer = 17;
		
		if (isClimbing) {
			if (xDir != 0 && !lockpool.is_locked(PlayerAction.TURN_GROUND))
				image_xscale = xDir;
		}
		
		var _gunOffset/*:Vector2*/ = player_gun_offset();
		
		// Make the bullet
		var _bulletX = x + (_gunOffset[Vector2.x] + (_params[$ "offsetX"] ?? 0)) * _player.image_xscale,
			_bulletY = y + (_gunOffset[Vector2.y] + (_params[$ "offsetY"] ?? 0)) * _player.image_yscale,
			_bulletDepth = depth + (_params[$ "depthOffset"] ?? -1),
			_bulletObj = _params.object;
		
		var _bullet = spawn_entity(_bulletX, _bulletY, _bulletDepth, _bulletObj, {
			image_xscale: sign(image_xscale),
			image_yscale: sign(image_yscale)
		});
		_bullet.owner = id;
		_bullet.playerID = playerID;
		
		return _bullet;
	}
	
	return noone; // failsafe
}

/// @func player_get_character(player)
/// @desc Get the playable character the given player entity is set as
///
/// @param {prtPlayer}  [player]  The player entity to check. Defaults to the calling instance.
///
/// @returns {Character}  The playable character set for this player
function player_get_character(_player = self) {
	PLAYER_ONLY_FUNCTION
	return global.characterList[_player.characterID];
}

/// @self {prtPlayer}
/// @func player_gun_offset()
/// @desc Gets the relative position of the player's gun/arm cannon
///		  Mainly used to get a base offset when furing a weapon
///
/// @returns {Vector2}  Gun offset
function player_gun_offset() {
	var _offset/*:Vector2*/ = [16, 4];
	if (isClimbing)
		_offset[@Vector2.y] -= 2;
	else if (!ground)
		_offset[@Vector2.y] -= 5;
	return _offset;
}

/// @func player_refresh_palette_body(player)
/// @desc Updates the player's palette for their body
///
/// @param {prtPlayer}  [player]
function player_refresh_palette_body(_player = self) {
	PLAYER_ONLY_FUNCTION
	
	with (_player) {
		var _characterPalette = global.characterList[characterID].get_colours();
		
		if (!is_undefined(weapon)) {
			var _weaponPalette = weapon.get_colours();
			_characterPalette[PalettePlayer.primary] = _weaponPalette[PaletteWeapon.primary];
			_characterPalette[PalettePlayer.secondary] = _weaponPalette[PaletteWeapon.secondary];
		}
		
		for (var i = 0; i < bodyPalette.colourCount; i++)
			bodyPalette.set_output_colour_at(i, _characterPalette[i]);
	}
}

/// @func player_refresh_palette_icon()
/// @desc Updates the player's palette for the weapon icon
///
/// @param {prtPlayer}  [player]
function player_refresh_palette_icon(_player = self) {
	PLAYER_ONLY_FUNCTION
	
	with (_player) {
		if (is_undefined(weapon))
			return;
		
		var _weaponPalette = weapon.get_colours();
		for (var i = 0; i < iconPalette.colourCount; i++)
			iconPalette.set_output_colour_at(i, _weaponPalette[i]);
	}
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
	var _character = global.characterList[_characterID];
	var _body = spawn_entity(_x, _y, _depthOrLayer, _character.object, {
		characterID: _character.id
	});
	return _body;
}

#endregion
