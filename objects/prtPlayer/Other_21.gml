/// @description Method Init
/// @init
// These tabs spaces are just so it looks better organized in the outline view in GMEdit

	#region Checking Inputs
	
	/// -- check_input_shoot(auto_fire)
	/// Helper function for if the player is trying to input a shoot action.
	/// It will check if the player is in a state where they are able to do so.
	/// Mainly used by weapons to know if the player is trying to shoot a projectile.
	///
	/// @param {bool}  [auto_fire]  Whether the function should use auto-fire beaviour (true) or not (false).
	///		If controller by a user, this defaults to whatever is set in options_data.
	///		If not, it defaults to false.
	///
	/// @returns {bool}  Whether the player can fire a shot (true), or not (false)
	function check_input_shoot(_autoFire) {
		if (self.is_action_locked(PlayerAction.SHOOT))
			return false;
		
		_autoFire ??= self.is_user_controlled() ? options_data().autoFire : false;
		return _autoFire
			? inputs.is_held(InputActions.SHOOT) && autoFireTimer <= 0
			: inputs.is_pressed(InputActions.SHOOT);
	}
	
	/// -- check_input_down_jump_slide()
	/// Helper function for if the player is trying to perform a slide by jumping while holding down.
	/// It will check if the player is in a state where they are able to do so.
	///
	/// @returns {bool}  Whether the player can down+jump to slide (true), or not (false)
	function check_input_down_jump_slide() {
		if (self.is_action_locked(PlayerAction.SLIDE))
			return false;
		
		return self.is_user_controlled()
			? yDir == gravDir && inputs.is_pressed(InputActions.JUMP) && options_data().downJumpSlide
			: false;
	}
	
	#endregion
	
	#region Handle
	
	/// -- handle_sections()
	/// Handles the player's interaction with screen sections
	function handle_sections() {
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
	
	/// -- handle_shooting()
	/// Handles the act of the player shooting
	function handle_shooting() {
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
	
	/// -- handle_switching_weapons()
	function handle_switching_weapons() {
		if (loadoutSize <= 0 || self.is_action_locked(PlayerAction.WEAPON_CHANGE)) {
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
			self.equip_weapon(_index);
			
			with (prtProjectile) {
				if (owner == other.id)
					instance_destroy();
			}
			
			quickSwitchTimer = 8 + (10 * (quickSwitchTimer < 0));
			weaponIconTimer = 32;
			self.refresh_palette();
			play_sfx(sfxWeaponSwitch);
		}
		
		weaponIconTimer--;
	}
	
	#endregion
	
	#region Weapons
	
	/// -- add_weapon(weapon_id)
	/// Gives a player object a weapon to add to their loadout
	///
	/// @param {int}  weapon_id  The ID of the weapon to add
	function add_weapon(_weaponID) {
		var _weapon = weapon_create_from_id(_weaponID);
		array_push(loadout, _weapon);
		loadoutSize = array_length(loadout);
	}
	
	/// -- equip_weapon(weapon_or_loadout_index)
	/// Makes this player entity equip a weapon
	///	This can either be an actual Weapon instance,
	///	or an index from the player's loadout
	///
	/// @param {Weapon|int}  weapon_or_loadout_index  The weapon instance to equip (or the weapon at a given location in the player's loadout)
	function equip_weapon(_weaponOrLoadout) {
		var _weapon = undefined;
		if (is_instanceof(_weaponOrLoadout, Weapon))
			_weapon = _weaponOrLoadout;
		else if (is_numeric(_weaponOrLoadout))
			_weapon = array_at(loadout, _weaponOrLoadout);
		
		if (self.is_user_controlled())
			playerUser.hudElement.assign_weapon(_weapon);
		
		if (!is_undefined(weapon))
			weapon.on_unequip(self);
		weapon = _weapon;
		if (!is_undefined(weapon))
			weapon.on_equip(self);
	}
	
	/// -- fire_weapon(params, player)
	/// Function to make the player fire a weapon.
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
	///
	/// @returns {instance}  The projectile. Returns `noone` if something prevented a projectile being created.
	function fire_weapon(_params = {}) {
		// Check for the bullet limit
		if (_params.limit > 0) {
			var _limit = _params.limit;
			
			with (prtProjectile) {
				if (owner != other.id)
					continue;
				
				_limit -= bulletLimitCost;
				if (_limit <= 0)
					return noone;
			}
		}
		
		// What weapon is this for?
		var _weapon = _params[$ "weapon"] ?? weapon;
		
		// Check for ammo
		if (_params.cost > 0 && !is_undefined(_weapon)) {
			if (_weapon.ammo <= 0)
				return noone;
				
			_weapon.change_ammo(-_params.cost);
			if (self.is_user_controlled() && playerUser.hudElement.ammoWeapon == _weapon.id)
				playerUser.hudElement.ammo = _weapon.ammo;
		}
		
		// We should be good to go
		isShooting = true;
		shootAnimation = _params.shootAnimation;
		shootTimer = 17;
		shootStandStillLock.deactivate();
		if (_params[$ "autoShootDelay"] ?? false)
			autoFireTimer = _params.autoShootDelay;
		
		// Standstill stuff
		var _standstill = _params[$ "standstill"] ?? false;
		if (_standstill || isClimbing) {
			if (xDir != 0 && !self.is_action_locked(PlayerAction.TURN_GROUND))
				image_xscale = xDir;
		}
		if (_standstill)
			shootStandStillLock.activate();
		
		// Make the bullet
		var _gunOffset = characterSpecs.spritesheet_gun_offset(shootAnimation, skinCellX, skinCellY),
			_bulletX = x + (_gunOffset[Vector2.x] + (_params[$ "offsetX"] ?? 0)) * image_xscale,
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
	
	/// -- generate_loadout()
	/// Generates a weapon loadout for this player, based on their character specs
	function generate_loadout() {
		var _loadout = characterSpecs.loadout,
			_loadoutSize = array_length(_loadout);
		for (var i = 0; i < _loadoutSize; i++)
			self.add_weapon(_loadout[i]);
	}
	
	#endregion
	
	#region Other

	/// -- is_action_locked(player_action)
	/// Checks if the given player action is locked on this player
	///
	/// @param {int}  player_action
	///
	/// @returns {bool}  Whether the action is locked (true) or not (false)
	function is_action_locked(_action) {
		var _result = lockpool.is_locked(_action);
		if (self.is_user_controlled())
			_result |= playerUser.lockpool.is_locked(_action);
		
		return _result;
	}
	
	/// -- is_user_controlled()
	/// Checks if this player entity is being controlled by a player user.
	///
	/// @returns {bool}  Whether this player is being controlled (true), or not (false)
	function is_user_controlled() {
		return !is_undefined(playerUser);
	}
	
	/// -- refresh_palette()
	/// Updates the player's palette
	function refresh_palette() {
		var _characterPalette = characterSpecs.get_default_colours();
		
		if (!is_undefined(weapon)) {
			_characterPalette[PalettePlayer.primary] = weapon.colours[PaletteWeapon.primary];
			_characterPalette[PalettePlayer.secondary] = weapon.colours[PaletteWeapon.secondary];
		}
		
		for (var i = 0; i < palette.colourCount; i++)
			palette.set_colour_at(i, _characterPalette[i]);
		if (self.is_user_controlled())
			playerUser.hudElement.ammoPalette = array_slice(_characterPalette, 0, 3);
	}
	
	/// -- restore_ammo(value, weapon)
	/// Restores the player's weapon ammo by the given amount
	function restore_ammo(_value, _weapon) {
		var _isCPU = !self.is_user_controlled();
		
		if (options_data().instantHealthFill || _isCPU) {
			_weapon.change_ammo(_value);
			if (!_isCPU && playerUser.hudElement.ammoWeapon == _weapon.id)
				playerUser.hudElement.ammo = _weapon.ammo;
			return;
		}
		
		var _restorer = instance_exists(objHealthRestoreEffect)
			? instance_nearest(0, 0, objHealthRestoreEffect)
			: instance_create_layer(0, 0, LAYER_SYSTEM, objHealthRestoreEffect);
		_restorer.queue_ammo_refill(_weapon, _value);
	}

	/// -- restore_health(value)
	/// Restores the player's health by the given amount
	function restore_health(_value) {
		var _isCPU = !self.is_user_controlled();
		
		if (options_data().instantHealthFill || _isCPU) {
			healthpoints = clamp(healthpoints + _value, 0, healthpointsStart);
			if (!_isCPU)
				playerUser.hudElement.healthpoints = healthpoints;
			return;
		}
		
		var _restorer = instance_exists(objHealthRestoreEffect)
			? instance_nearest(0, 0, objHealthRestoreEffect)
			: instance_create_layer(0, 0, LAYER_SYSTEM, objHealthRestoreEffect);
		_restorer.queue_health_refill(_value);
	}
	
	/// -- try_climbing()
	/// Function that checks if the player is able to climb a ladder
	///
	/// @returns {bool}  Whether the player can climb a ladder (true), or not (false)
	function try_climbing() {
		ladderInstance = noone;
		
		if (yDir == 0 || self.is_action_locked(PlayerAction.CLIMB))
			return false;
		
		if (yDir != gravDir)
			ladderInstance = collision_line(bbox_x_center(), bbox_top + 2, bbox_x_center(), bbox_bottom - 1, objLadder, false, false);
		else if (ground)
			ladderInstance = instance_position(sprite_x_center(), bbox_vertical(gravDir) + gravDir, objLadder);
		
		return ladderInstance != noone && !test_move_x(bbox_x_center(ladderInstance) - x);
	}
	
	/// -- try_sliding()
	/// Function that checks if the player is able to slide
	///
	/// @returns {bool}  Whether the player can slide (true), or not (false)
	function try_sliding() {
		if (!ground || self.is_action_locked(PlayerAction.SLIDE))
			return false;
		
		var _input = inputs.is_pressed(InputActions.SLIDE) || self.check_input_down_jump_slide();
		if (!_input)
			return false;
		
		// Check if there's space ahead
		mask_index = maskSlide;
		var _hasSpace = !test_move_x(image_xscale);
		mask_index = maskNormal;
		
		return _hasSpace;
	}
	
	#endregion