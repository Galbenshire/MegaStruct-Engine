/// @description Method Init
/// @init
// These tabs spaces are just so it looks better organized in the outline view in GMEdit

	#region Checking Inputs
	
	/// -- check_input_down_jump_slide(ignore_lock)
	/// Helper function for if the player is trying to perform a slide by jumping while holding down.
	/// It will check if the player is in a state where they are able to do so.
	///
	/// @param {bool}  [ignore_lock]  If true, the function ignores whether or not the act of sliding is locked.
	///		Defaults to false.
	///
	/// @returns {bool}  Whether the player can down+jump to slide (true), or not (false)
	function check_input_down_jump_slide(_ignoreLock = false) {
		if (!self.is_user_controlled())
			return false;
		if (!_ignoreLock && self.is_action_locked(PlayerAction.SLIDE))
			return false;
		return yDir == gravDir && inputs.is_pressed(InputActions.JUMP) && options_data().downJumpSlide;
	}
	
	/// -- check_input_jump(ignore_lock)
	/// Helper function for if the player is trying to perform a jump action.
	/// It will check if the player is in a state where they are able to do so.
	///
	/// @param {bool}  [ignore_lock]  If true, the function ignores whether or not the act of jumping is locked.
	///		Defaults to false.
	///
	/// @returns {bool}  Whether the player can jump (true), or not (false)
	function check_input_jump(_ignoreLock = false) {
		if (!_ignoreLock && self.is_action_locked(PlayerAction.JUMP))
			return false;
		if (inputs.is_pressed(InputActions.JUMP))
			return true;
		return jumpBufferTimer > 0 && inputs.is_held(InputActions.JUMP);
	}
	
	/// -- check_input_shoot(auto_fire, ignore_lock)
	/// Helper function for if the player is trying to input a shoot action.
	/// It will check if the player is in a state where they are able to do so.
	/// Mainly used by weapons to know if the player is trying to shoot a projectile.
	///
	/// @param {bool}  [auto_fire]  Whether the function should use auto-fire beaviour (true) or not (false).
	///		If controller by a user, this defaults to whatever is set in options_data.
	///		If not, it defaults to false.
	/// @param {bool}  [ignore_lock]  If true, the function ignores whether or not the act of shooting is locked.
	///		Defaults to false.
	///
	/// @returns {bool}  Whether the player can fire a shot (true), or not (false)
	function check_input_shoot(_autoFire, _ignoreLock = false) {
		if (!_ignoreLock && self.is_action_locked(PlayerAction.SHOOT))
			return false;
		if (inputs.is_pressed(InputActions.SHOOT))
			return true;
		
		_autoFire ??= self.is_user_controlled() ? options_data().autoFire : false;
		return _autoFire && inputs.is_held(InputActions.SHOOT) && autoFireTimer <= 0;
	}
	
	#endregion
	
	#region Handle
	
	/// -- handle_animation()
	/// Handles the player's animations
	function handle_animation() {
		if (self.is_action_locked(PlayerAction.SPRITE_CHANGE))
			return;
		
		skinPage = undefined;
		skinCellX = 0;
		skinCellY = 0;
		animator.update();
		
		if (is_undefined(skinPage))
			skinPage = shootAnimation;
	}
	
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
			stateMachine.change_state("Death");
		}
	}
	
	/// -- handle_shooting()
	/// Handles the act of the player shooting
	function handle_shooting() {
		autoFireTimer--;
		
		if (isShooting) {
			shootTimer = approach(shootTimer, 0, 1);
			if (shootTimer == 0) {
				isShooting = false;
				shootAnimation = PlayerSpritesheetPage.IDLE;
				shootStandStillLock.deactivate();
			}
		}
		
		if (!is_undefined(weapon))
			weapon.on_tick(self);
	}
	
	/// -- handle_switching_weapons()
	function handle_switching_weapons() {
		if (self.is_action_locked(PlayerAction.WEAPON_CHANGE)) {
			quickSwitchTimer = 0;
			weaponIconTimer = 0;
			return;
		}
		
		var _weaponIndex = array_get_index(weaponList, weapon),
			_wpnSwitchLeft = inputs.is_held(InputActions.WEAPON_SWITCH_LEFT),
			_wpnSwitchRight = inputs.is_held(InputActions.WEAPON_SWITCH_RIGHT),
			_dir = _wpnSwitchRight - _wpnSwitchLeft;
		
		if (_dir != 0) {
			if (--quickSwitchTimer <= 0)
				_weaponIndex = modf(_weaponIndex + _dir, weaponSize);
		} else if (_wpnSwitchLeft && _wpnSwitchRight) {
			_weaponIndex = 0;
		} else {
			quickSwitchTimer = 0;
		}
		
		if (_weaponIndex != NOT_FOUND && weaponList[_weaponIndex] != weapon) {
			self.equip_weapon(_weaponIndex);
			
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
	
	#region Palette
	
	/// -- get_palette(weapon)
	/// Gets a palette from the player, based on the given weapon
	///
	/// @param {Weapon}  weapon  The weapon to use. Defaults to the player's current.
	function get_palette(_weapon = weapon) {
		var _characterPalette = characterSpecs.get_default_colours();
		_characterPalette[PalettePlayer.primary] = _weapon.colours[PaletteWeapon.primary];
		_characterPalette[PalettePlayer.secondary] = _weapon.colours[PaletteWeapon.secondary];
		
		return _characterPalette;
	}
	
	/// -- refresh_palette()
	/// Updates the player's palette
	function refresh_palette() {
		var _palette = self.get_palette();
		
		for (var i = 0; i < palette.colourCount; i++)
			palette.set_output_colour_at(i, _palette[i]);
		if (self.is_user_controlled())
			hudElement.set_weapon_palette(_palette[PalettePlayer.primary], _palette[PalettePlayer.secondary], _palette[PalettePlayer.outline]);
	}
	
	#endregion
	
	#region Restoring Health/Ammo
	
	/// -- restore_health(value)
	/// Restores the player's health by the given amount
	///
	/// @param {number}  value  The amount to health to restore
	function restore_health(_value) {
		if (options_data().instantHealthFill || !self.is_user_controlled()) {
			healthpoints = clamp(healthpoints + _value, 0, healthpointsStart);
			hudElement.healthpoints = healthpoints;
			play_sfx(sfxEnergyRestore);
		} else {
			health_restore_effect().queue_health_refill(self, _value);
		}
	}
	
	/// -- restore_weapon_ammo(value, weapon)
	/// Restores the player's weapon ammo by the given amount
	///
	/// @param {number}  value  The amount to ammo to restore
	/// @param {Weapon}  weapon  The weapon to restore the ammo of
	function restore_weapon_ammo(_value, _weapon) {
		if (options_data().instantHealthFill || !self.is_user_controlled()) {
			_weapon.change_ammo(_value);
			play_sfx(sfxEnergyRestore);
			
			if (hudElement.weaponID == _weapon.id)
				hudElement.weaponAmmo = _weapon.ammo
		} else {
			health_restore_effect().queue_ammo_refill(self, _weapon, _value);
		}
	}
	
	#endregion
	
	#region Try Actions
	
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
		
		var _input = inputs.is_pressed(InputActions.SLIDE) || self.check_input_down_jump_slide(true);
		if (!_input)
			return false;
		
		// Check if there's space ahead
		mask_index = maskSlide;
		var _hasSpace = !test_move_x(image_xscale);
		mask_index = maskNormal;
		
		return _hasSpace;
	}
	
	#endregion
	
	#region Weapons
	
	/// -- add_weapon(weapon_id)
	/// Gives a player object a weapon to add to their loadout
	///
	/// @param {int}  weapon_id  The ID of the weapon to add
	function add_weapon(_weaponID) {
		var _weapon = weapon_create_from_id(_weaponID);
		characterSpecs.personalize_weapon(_weapon);
		array_push(weaponList, _weapon);
		weaponSize = array_length(weaponList);
	}
	
	/// -- equip_weapon(weapon_or_index)
	/// Makes this player entity equip a weapon
	///	This can either be an actual Weapon instance,
	///	or an index from the player's weapon loadout
	///
	/// @param {Weapon|int}  weapon_or_index  The weapon instance to equip (or the weapon at a given location in the player's loadout)
	function equip_weapon(_weaponOrIndex) {
		var _weapon = undefined;
		if (is_instanceof(_weaponOrIndex, Weapon))
			_weapon = _weaponOrIndex;
		else if (is_numeric(_weaponOrIndex))
			_weapon = array_at(weaponList, _weaponOrIndex);
		
		if (is_undefined(_weapon))
			return;
		
		weapon.on_unequip(self);
		weapon = _weapon;
		hudElement.assign_weapon(_weapon);
		weapon.on_equip(self);
	}
	
	/// -- fire_weapon(params, player)
	/// Function to make the player fire a weapon.
	///
	/// @param {struct}  params  Defines various parameters towards firing this projectile.
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
	///		- projParams: a struct that defines parameters on the projectile itself
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
			if (hudElement.weaponID == _weapon.id)
				hudElement.weaponAmmo = _weapon.ammo;
		}
		
		// We should be good to go
		isShooting = true;
		shootAnimation = _params.shootAnimation;
		shootTimer = 16;
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
		
		var _bulletParams = _params[$ "projParams"] ?? {};
		_bulletParams.image_xscale = sign(image_xscale);
		_bulletParams.image_yscale = sign(image_yscale);
		
		var _bullet = spawn_entity(_bulletX, _bulletY, _bulletDepth, _bulletObj, _bulletParams);
		_bullet.owner = id;
		_bullet.playerID = playerID;
		
		// Let others know we just shot this projectile
		signal_bus().emit_signal("playerShot", {
			player: self.id,
			projectile: _bullet
		});
		
		return _bullet;
	}
	
	/// -- generate_weapons()
	/// Generates a weapon loadout for this player, based on their character specs
	function generate_weapons() {
		weaponList = [];
		var _weapons = characterSpecs.weapons;
		for (var i = 0, n = array_length(_weapons); i < n; i++)
			self.add_weapon(_weapons[i]);
	}
	
	#endregion
	
	#region Other
	
	/// -- common_state_air(event)
	/// Executes code common across multiple "air" states
	///
	/// @param {string}  event  The event to execute
	///
	/// @returns {bool}  `true` if a state change has occurred, `false` otherwise
	function common_state_air(_event) {
		switch (_event) {
			case "enter":
				ground = false;
				groundInstance = noone;
				break;
			
			case "tick":
				var _airSpeed = slideBoostActive ? slideSpeed : airSpeed;
				xspeed.value = _airSpeed * xDir * !self.is_action_locked(PlayerAction.MOVE_AIR);
				
				if (xDir != 0 && !self.is_action_locked(PlayerAction.TURN_AIR))
					image_xscale = xDir;
				break;
			
			case "posttick":
				if (self.try_climbing()) {
					stateMachine.change_state("Climb");
					return true;
				}
				
				if (ground) {
					stateMachine.change_state(xDir == 0 ? "Idle" : "Walk");
					play_sfx(sfxLand);
					return true;
				}
				break;
		}
		return false;
	}
	
	/// -- common_state_ground(event)
	/// Executes code common across multiple "ground" states
	///
	/// @param {string}  event  The event to execute
	///
	/// @returns {bool}  `true` if a state change has occurred, `false` otherwise
	function common_state_ground(_event) {
		switch (_event) {
			case "enter":
				slideBoostActive = false;
				midairJumps = 0;
				break;
			
			case "tick":
				if (self.check_input_jump() && !self.check_input_down_jump_slide()) {
					stateMachine.change_state("Jump");
					return true;
				}
				
				if (xDir != 0 && !self.is_action_locked(PlayerAction.TURN_GROUND))
					image_xscale = xDir;
				break;
			
			case "posttick":
				if (self.try_climbing()) {
					stateMachine.change_state("Climb");
					return true;
				}
				
				if (!ground) {
					move_and_collide_y(gravDir);
					stateMachine.change_state("Fall");
					coyoteTimer = COYOTE_FALL_BUFFER;
					return true;
				}
				
				if (self.try_sliding()) {
					stateMachine.change_state("Slide");
					return true;
				}
				break;
		}
		return false;
	}

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
	
	#endregion