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
		if (!player_is_user_controlled(self))
			return false;
		if (!_ignoreLock && self.is_action_locked(PlayerAction.SLIDE))
			return false;
		return yDir == gravDir && self.is_input_pressed(InputActions.JUMP) && options_data().downJumpSlide;
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
		if (self.is_input_pressed(InputActions.JUMP))
			return true;
		return jumpBufferTimer > 0 && self.is_input_held(InputActions.JUMP);
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
		if (self.is_input_pressed(InputActions.SHOOT))
			return true;
		
		_autoFire ??= player_is_user_controlled(self) ? options_data().autoFire : false;
		return _autoFire && self.is_input_held(InputActions.SHOOT) && autoFireTimer <= 0;
	}
	
	/// -- is_input_held(input, access_level)
	/// Checks if the player has the specified input held
	///
	/// @param {int}  input  The input to check
	/// @param {int}  [access_level]  The access level required. Overridden by `manualInputs`.
	///
	/// @returns {bool}  Whether the input was held (true), or not (false)
	function is_input_held(_input, _accessLvl = PlayerInputLevel.MAIN) {
		if (manualInputs.is_held(_input))
			return true;
		if (userInputs.is_held(_input)) {
			var _lvlBound = player_is_user_controlled(self) ? playerUser.inputAccessLevel : PlayerInputLevel.MAIN;
			return _accessLvl >= _lvlBound;
		}
		return false;
	}
	
	/// -- is_input_pressed(input, access_level)
	/// Checks if the player has the specified input pressed
	///
	/// @param {int}  input  The input to check
	/// @param {int}  [access_level]  The access level required. Overridden by `manualInputs`.
	///
	/// @returns {bool}  Whether the input was pressed (true), or not (false)
	function is_input_pressed(_input, _accessLvl = PlayerInputLevel.MAIN) {
		if (manualInputs.is_pressed(_input))
			return true;
		if (userInputs.is_pressed(_input)) {
			var _lvlBound = player_is_user_controlled(self) ? playerUser.inputAccessLevel : PlayerInputLevel.MAIN;
			return _accessLvl >= _lvlBound;
		}
		return false;
	}
	
	#endregion
	
	#region Handle
	
	/// -- handle_animation()
	/// Handles the player's animations
	function handle_animation() {
		if (self.is_action_locked(PlayerAction.SPRITE_CHANGE))
			return;
		
		skinSprite = PlayerSpriteType.IDLE;
		skinIndex = 0;
		skinOffset = 0;
		animator.update();
		
		if (skinSprite < PlayerSpriteType.COUNT_STANDARD)
			skinOffset = shootType;
	}
	
	/// -- handle_input()
	/// Handles input for the given player
	function handle_input() {
		if (!player_is_user_controlled(self))
			return;
		
		var _userInputs = playerUser.inputs;
		userInputs.held = _userInputs.held;
		userInputs.pressed |= _userInputs.pressed;
		userInputs.released |= _userInputs.released;
	}
	
	/// -- handle_sections()
	/// Handles the player's interaction with screen sections
	function handle_sections() {
		if (!player_is_active(self) || global.switchingSections)
			return;
		
		var _section = global.section;
		if (!instance_exists(_section))
			return;
		
		var _checkX = clamp(x, _section.left + 4, _section.right - 4),
			_checkY = clamp(y, _section.top + 4, _section.bottom - 4),
			_transition = instance_position(_checkX, _checkY, objScreenTransition);
		if (instance_exists(_transition) && _transition.can_transition(self)) {
			x = _checkX;
			y = _checkY;
			
			var _switch = instance_create_layer(_checkX, _checkY, LAYER_FADER, objSectionSwitcher);
			_switch.playerInstance = id;
			_switch.transitionInstance = _transition;
			return;
		}
		
		var _fallingDown = (gravDir >= 0);
		x = clamp(x, _section.left, _section.right);
		y = _fallingDown ? max(y, _section.top - 32) : min(y, _section.bottom + 32);
		
		if (canDieToPits) {
			var _fellIntoPit = _fallingDown ? y > _section.bottom + 16 : y < _section.top - 16;
			if (_fellIntoPit)
				stateMachine.change_state("Death", { diedToPit: true });
		}
	}
	
	/// -- handle_shooting()
	/// Handles the act of the player shooting
	function handle_shooting() {
		autoFireTimer--;
		
		if (isShooting) {
			shootTimer = max(shootTimer - 1, 0);
			if (shootTimer <= 0) {
				isShooting = false;
				shootType = PlayerShootType.IDLE;
				shootStandStillLock.deactivate();
			}
		}
		
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
			_wpnSwitchLeft = self.is_input_held(InputActions.WEAPON_SWITCH_LEFT, PlayerInputLevel.WPN_SWITCH),
			_wpnSwitchRight = self.is_input_held(InputActions.WEAPON_SWITCH_RIGHT, PlayerInputLevel.WPN_SWITCH),
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
				if (owner == other.id && destroyOnWeaponSwitch)
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
	
	/// -- get_palette(live)
	/// Gets the player's palette
	///
	/// @param {bool}  [live]  If true (default), gets the player's palette as it is currently.
	///		If false, gets their base palette, taking their weapon into account.
	///
	/// @returns {PalettePlayer}  The palette
	function get_palette(_live = true) {
		if (_live)
			return palette.copy_output_colours();
		
		var _characterPalette = characterSpecs.get_player_colours(true);
		_characterPalette[PalettePlayer.primary] = weapon.iconColours[PaletteWeapon.primary];
		_characterPalette[PalettePlayer.secondary] = weapon.iconColours[PaletteWeapon.secondary];
		return _characterPalette;
	}
	
	/// -- refresh_palette()
	/// Updates the player's palette
	function refresh_palette() {
		var _palette = self.get_palette(false);
		
		palette.set_output_colours(_palette);
		if (player_is_user_controlled(self))
			hudElement.set_weapon_palette(_palette[PalettePlayer.primary], _palette[PalettePlayer.secondary], _palette[PalettePlayer.outline]);
		
		signal_bus().emit_signal(SIGNAL_PLAYER_PALETTE_UPDATE, {
			player: self.id
		});
	}
	
	#endregion
	
	#region Restoring Health/Ammo
	
	/// -- restore_health(value)
	/// Restores the player's health by the given amount
	///
	/// @param {number}  value  The amount to health to restore
	function restore_health(_value) {
		if (options_data().instantHealthFill || !player_is_user_controlled(self)) {
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
		if (options_data().instantHealthFill || !player_is_user_controlled(self)) {
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
		
		if (yDir == -gravDir && (!jumpedOffLadder || yspeed * gravDir > 0))
			ladderInstance = collision_line(bbox_x_center(), bbox_top + 2, bbox_x_center(), bbox_bottom - 1, objLadder, false, false);
		else if (ground)
			ladderInstance = instance_position(sprite_x_center(), bbox_vertical(gravDir) + gravDir, objLadder);
		
		var _result = ladderInstance != noone && !test_move_x(bbox_x_center(ladderInstance) - x);
		if (!_result)
			ladderInstance = noone;
		
		return _result;
	}
	
	/// -- try_sliding()
	/// Function that checks if the player is able to slide
	///
	/// @returns {bool}  Whether the player can slide (true), or not (false)
	function try_sliding() {
		if (!ground || self.is_action_locked(PlayerAction.SLIDE))
			return false;
		if (!self.is_input_pressed(InputActions.SLIDE) && !self.check_input_down_jump_slide(true))
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
	
	/// -- fire_weapon(shot_data)
	/// Function to make the player fire a weapon.
	///
	/// @param {WeaponShotBuilder}  shot_data  Defines various parameters towards firing this projectile.
	///
	/// @returns {instance}  The projectile. Returns `noone` if something prevented a projectile being created.
	function fire_weapon(_shotData) {
		// Able to shoot?
		if (!_shotData.check_shot_limit(self) || !_shotData.check_ammo_cost())
			return noone;
		
		// Set the player into a shooting state (if told to)
		if (!is_undefined(_shotData.shootAnimation)) {
			isShooting = true;
			shootType = _shotData.shootAnimation;
			shootTimer = 16;
		}
		
		// Standstill stuff
		shootStandStillLock.deactivate();
		if (_shotData.shootStandstill || isClimbing) {
			if (xDir != 0 && !self.is_action_locked(PlayerAction.TURN_GROUND))
				image_xscale = xDir;
		}
		if (_shotData.shootStandstill)
			shootStandStillLock.activate();
		
		// Reset Auto Fire timer
		autoFireTimer = _shotData.autoShootDelay;
		
		// Reduce Ammo
		if (_shotData.ammoCost > 0) {
			_shotData.weapon.change_ammo(-_shotData.ammoCost);
			if (hudElement.weaponID == _shotData.weapon.id)
				hudElement.weaponAmmo = _shotData.weapon.ammo;
		}
		
		// Make the bullet
		var _bullet = _shotData.generate_shot(self);
		
		// Let others know we just shot this projectile
		signal_bus().emit_signal(SIGNAL_PLAYER_SHOT, {
			player: self.id,
			projectile: _bullet
		});
		
		return _bullet;
	}
	
	/// -- generate_weapons()
	/// Generates a weapon loadout for this player, based on their character specs
	function generate_weapons() {
		array_clear(weaponList);
		var _weapons = characterSpecs.weapons;
		for (var i = 0, n = array_length(_weapons); i < n; i++)
			self.add_weapon(_weapons[i]);
	}
	
	/// -- get_weapon_by_id(weapon_id)
	/// Gets a specifc weapon from the player, given a weapon ID
	///
	/// @param {int}  weapon_id  The weapon ID to look for
	///
	/// @returns {Weapon?}  The weapon with the corresponding ID, or `undefined` if the player lacks said weapon
	function get_weapon_by_id(_weaponID) {
		var i = 0; repeat(weaponSize) {
			if (weaponList[i].id == _weaponID)
				return weaponList[i];
			i++;
		}
		return undefined;
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
		if (player_is_user_controlled(self))
			_result |= playerUser.lockpool.is_locked(_action);
		return _result;
	}
	
	/// -- reset_property(name)
	/// Resets a specific property to what's defined on the player's character specs
	///
	/// @param {string}  name  The name of the property to reset
	function reset_property(_name) {
		if (!struct_exists(characterSpecs.entityProps, _name))
			return;
		
		self[$ _name] = characterSpecs.entityProps[$ _name];
		
		// Update lockpools, if specific properties were set
		switch (_name) {
			case "slideShootEnabled":
				if (slideShootEnabled)
					slideLock.remove_actions(PlayerAction.SHOOT);
				else
					slideLock.add_actions(PlayerAction.SHOOT);
				break;
		}
	}
	
	/// -- reset_all_properties()
	/// Resets all properties defined on the player's character specs
	function reset_all_properties() {
		var _originalProps = characterSpecs.entityProps,
			_propKeys = struct_get_names(_originalProps);
		
		var i = 0; repeat(struct_names_count(_originalProps)) {
			self.reset_property(_propKeys[i]);
			i++;
		}
	}
	
	/// -- teleport_in()
	/// Tells the player to perform a teleport-in sequence
	function teleport_in(_type = teleportInType) {
		var _typeLookup = array_create(TeleportInType.COUNT);
		_typeLookup[TeleportInType.TELEPORT_LONG] = "Default";
		_typeLookup[TeleportInType.TELEPORT_SHORT] = "Quick";
		_typeLookup[TeleportInType.FALL_DOWN] = "Fall";
		_typeLookup[TeleportInType.JUMP_IN] = "Jump";
		_typeLookup[TeleportInType.STAND] = "Stand";
		
		teleportInType = _type;
		stateMachine.change_state($"TeleportIn_{_typeLookup[_type]}");
	}
	
	#endregion