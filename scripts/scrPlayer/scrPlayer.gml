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
	// if (inputs.is_pressed(InputActions.SHOOT) && !lockpool.is_locked(PlayerAction.SHOOT)) {
	// 	var _params = {
	// 		sprite_index: sprBusterShot,
	// 		pierces: PierceType.NEVER,
	// 		factionLayer: [ Faction.PLAYER_PROJECTILE ],
	// 		factionMask: [ Faction.ENEMY_FULL ]
	// 	};
	// 	with (spawn_entity(x, y, depth, prtProjectile, _params)) {
	// 		xspeed.value = 5.5 * other.image_xscale;
	// 	}
	// 	isShooting = true;
	// 	shootAnimation = 1;
	// 	shootTimer = 17;
	// 	play_sfx(sfxBuster);
	// }
	
	if (weaponCount > 0) {
		weapons[weaponIndex].onTick(self);
	}
	
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
	if (weaponCount <= 0 || lockpool.is_locked(PlayerAction.WEAPON_CHANGE))
		return;
	
	var _dir = inputs.is_pressed(InputActions.WEAPON_SWITCH_RIGHT) - inputs.is_pressed(InputActions.WEAPON_SWITCH_LEFT);
	if (_dir == 0)
		return;
	
	weaponIndex = modf(weaponIndex + _dir, weaponCount);
	player_update_palette();
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

#region Functions for the player object

/// @func player_add_weapon()
/// @desc Gives a player object a weapon
function player_add_weapon(_weaponID, _player = self) {
	assert(is_a_player(_player), "player_add_weapon can only be used by an object that inherits from prtPlayer");
	
	with (_player) {
		var _weapon = global.weaponList[_weaponID].instantiate();
		array_push(weapons, _weapon);
		weaponCount = array_length(weapons);
	}
}

/// @func player_update_palette()
/// @desc Updates the player's palette
function player_update_palette(_player = self) {
	assert(is_a_player(_player), "player_update_palette can only be used by an object that inherits from prtPlayer");
	
	with (_player) {
		var _characterPalette/*:PalettePlayer*/ = global.characterList[characterID].get_colours();
		
		if (weaponCount > 0) {
			var _weaponPalette/*:PaletteWeapon*/ = weapons[weaponIndex].get_colours();
			_characterPalette[@PalettePlayer.primary] = _weaponPalette[PaletteWeapon.primary];
			_characterPalette[@PalettePlayer.secondary] = _weaponPalette[PaletteWeapon.secondary];
		}
		
		for (var i = 0; i < bodyPalette.colourCount; i++)
			bodyPalette.set_output_colour_at(i, _characterPalette[i]);
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

/// @func player_input_palette()
/// @desc Creates a copy of input colours used for the player object
///
/// @returns {PalettePlayer}
function player_input_palette() {
	var _palette/*:PalettePlayer*/ = array_create(PalettePlayer.sizeof);
	_palette[@PalettePlayer.primary] = $EC7000;
	_palette[@PalettePlayer.secondary] = $F8B838;
	_palette[@PalettePlayer.outline] = $9858F8;
	_palette[@PalettePlayer.skin] = $A8D8FC;
	_palette[@PalettePlayer.face] = $000000;
	_palette[@PalettePlayer.eyes] = $FFFFFF;
	
	return _palette;
}

/// @func spawn_player_character(x, y, depth_or_layer, character_id)
/// @desc Creates an instance of a player character
///
/// @param {number}  x  The x position the player will be created at
/// @param {number}  y  The y position the player will be created at
/// @param {number|layer|string}  depth_or_layer
/// @param {number}  character_id
///
/// @returns {prtPlayer}
function spawn_player_character(_x, _y, _depthOrLayer, _characterID) {
	var _character = global.characterList[_characterID];
	var _body = spawn_entity(_x, _y, _depthOrLayer, _character.object, {
		characterID: _character.id
	});
	return _body;
}

#endregion
