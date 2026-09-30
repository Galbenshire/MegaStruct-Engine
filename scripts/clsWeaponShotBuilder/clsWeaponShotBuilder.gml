/// @func WeaponShotBuilder()
/// @desc There's a lot of parameters that can go towards the player firing a weapon
///       This class is designed to make managing all that easier
function WeaponShotBuilder() constructor {
    assert(is_instanceof(other, Weapon), "WeaponShotBuilder intended for instances of Weapon");
    
    #region Variables
    
    weapon = other; /// @is {Weapon}
    shotObject = objBusterShot;
    autoShootDelay = 8;
    shotParams = {};
    
    ammoCost = 0;
    strictAmmoCheck = false;
    
    spawnOffsetX = 0;
    spawnOffsetY = 0;
    includeGunOffset = true;
    
    shootAnimation = PlayerShootType.SHOOT;
    shootStandstill = false;
    
    shotLimit = 1;
    shotLimitFilter = [ prtProjectile ];
    shotLimitFilterSize = 1;
    
    #endregion
    
    #region Function - Getters
    
    /// @method get_shot_param(parameter)
	/// @desc Gets the value of the given parameter on the shot param struct
	///
	/// @param {string}  parameter  The key name of the parameter
	///
	/// @returns {any?}  The value of the parameter, or `undefined` if not found
    static get_shot_param = function(_param) {
		return shotParams[$ _param];
    };
    
    /// @method get_shot_spawn_position(player)
	/// @desc Gets the spawn position of this shot for a given player
	///
	/// @param {prtPlayer}  player  The player to use in the check
	///
	/// @returns {Vector2}  The spawn position of this shot
    static get_shot_spawn_position = function(_player) {
		var _position = [spawnOffsetX, spawnOffsetY];
		
		if (includeGunOffset) {
			var _gunOffset = _player.characterSpecs.get_gun_offset_at(_player.shootType, _player.skinSprite);
			_position[Vector2.x] += _gunOffset[Vector2.x];
			_position[Vector2.y] += _gunOffset[Vector2.y];
		}
		
		_position[Vector2.x] *= _player.image_xscale;
		_position[Vector2.y] *= _player.image_yscale;
		_position[Vector2.x] += _player.x;
		_position[Vector2.y] += _player.y;
		
		return _position;
    };
    
    #endregion
    
    #region Function - Setters
    
    /// @method set_ammo_cost(cost, strict_check)
	/// @desc Sets the ammo used to fire this shot.
	///
	/// @param {number}  cost  The ammo cost
	/// @param {bool}  [strict_check]  If true, the weapon's ammo must be >= the cost to be fired. Defaults to false.
	///
	/// @returns {WeaponShotBuilder}  A reference to this struct. Useful for method chaining.
    static set_ammo_cost = function(_cost, _strict = false) {
        ammoCost = _cost;
        strictAmmoCheck = bool(_strict);
        return self;
    };
    
    /// @method set_auto_shoot_delay(value)
	/// @desc Alters the rate at which this shot is fired when Auto Fire is enabled
	///
	/// @param {number}  value  The length of the delay
	///
	/// @returns {WeaponShotBuilder}  A reference to this struct. Useful for method chaining.
    static set_auto_shoot_delay = function(_value) {
		autoShootDelay = _value;
        return self;
    };
    
    /// @method set_shoot_animation(value)
	/// @desc Sets the shoot animation the player should be put into when firing this weapon
	///
	/// @param {int?}  [value]  The shoot animation. (Check the `PlayerShootype` enum)
	///		If not defined, the player will not actually be placed into a shooting state.
	///
	/// @returns {WeaponShotBuilder}  A reference to this struct. Useful for method chaining.
    static set_shoot_animation = function(_value) {
        shootAnimation = _value;
        return self;
    };
    
    /// @method set_shot_limit(value, filter)
	/// @desc Sets the bullet limit for this shot.
	///       If the number of bullets onscreen exceed this limit, the shot is not allowed to be fired.
	///
	/// @param {int}  value  The shot limit
	/// @param {array<object>}  [filter]  The list of objects to check for during limit checks. Defaults to prtProjectile.
	///
	/// @returns {WeaponShotBuilder}  A reference to this struct. Useful for method chaining.
    static set_shot_limit = function(_value, _filter = [ prtProjectile ]) {
        shotLimit = _value;
        
        if (is_array(_filter)) {
            shotLimitFilter = !array_empty(_filter) ? _filter : [ prtProjectile ];
            shotLimitFilterSize = array_length(shotLimitFilter);
        }
        
        return self;
    };
    
    /// @method set_shoot_standstill(bool)
	/// @desc Sets whether this shot should place the player into a standstill when on the ground
	///
	/// @param {bool}  bool  Wether tha player is placed into a standstill (true) or not (false)
	///
	/// @returns {WeaponShotBuilder}  A reference to this struct. Useful for method chaining.
    static set_shoot_standstill = function(_bool) {
		shootStandstill = bool(_bool);
		return self;
    };
    
    /// @method set_shot_object(object)
	/// @desc Sets the object to spawn when firing this weapon
	///
	/// @param {object}  object  The object representing the shot
	///
	/// @returns {WeaponShotBuilder}  A reference to this struct. Useful for method chaining.
    static set_shot_object = function(_obj) {
        shotObject = _obj;
        return self;
    };
    
    /// @method set_shot_param(parameter, value)
	/// @desc Sets the value of a given parameter on the shot param struct
	///
	/// @param {string}  parameter  The key name of the parameter
	/// @param {any}  value  The value of the parameter
	///
	/// @returns {WeaponShotBuilder}  A reference to this struct. Useful for method chaining.
    static set_shot_param =  function(_param, _value) {
		struct_set(shotParams, _param, _value);
		return self;
    };
    
    /// @method set_spawn_offset(x, y, include_gun_offset)
	/// @desc Sets the position the shot should spawn at, relative to the player.
	///       This will take into account the orientation of the player as well. (i.e. image_xscale & image_yscale)
	///
	/// @param {int}  x  x-position to offset the spawn by
	/// @param {int}  y  y-position to offset the spawn by
	/// @param {bool}  [include_gun_offset]  If true, the position of the player's "gun" is used as the base.
	///		If false, the player themselves is used instead.
	///		Defaults to true.
	///
	/// @returns {WeaponShotBuilder}  A reference to this struct. Useful for method chaining.
    static set_spawn_offset = function(_x, _y, _includeGun = true) {
		spawnOffsetX = _x;
		spawnOffsetY = _y;
		includeGunOffset = _includeGun;
		return self;
    };
    
    #endregion
    
    #region Function - Firing the shot
    
    /// @method check_ammo_cost()
	/// @desc Checks if the weapon has enough ammo to fire this shot
	///
	/// @returns {bool}  Whether the weapon has enough ammo for this shot (true) or not (false)
    static check_ammo_cost = function() {
		if (ammoCost <= 0)
			return true;
		if (weapon.ammo <= 0)
			return false;
		return weapon.ammo >= ammoCost * strictAmmoCheck;
    };
    
    /// @method check_shot_limit(player)
	/// @desc Checks if the specified player is able to fire this shot, given the shot limit
	///
	/// @param {prtPlayer}  player  The player to check this against
	///
	/// @returns {bool}  Whether the shot limit permits this shot (true) or not (false)
    static check_shot_limit = function(_player) {
		if (shotLimit <= 0)
			return true;
		
		var _limit = shotLimit;
		var i = 0; repeat(shotLimitFilterSize) {
			with (shotLimitFilter[i]) {
				if (owner != _player.id)
					continue;
				
				_limit -= bulletLimitCost;
				if (_limit <= 0)
					return false;
			}
			i++;
		}
		
		return true;
    };
    
    /// @method generate_shot(player)
	/// @desc Creates a shot, using both the builder's data & the player
	///
	/// @param {prtPlayer}  player  The player to create this shot for
	///
	/// @returns {instance}  The newly created shot
    static generate_shot = function(_player) {
		var _position = self.get_shot_spawn_position(_player),
			_depth = _player.depth + 1;
		
		shotParams.image_xscale = sign(_player.image_xscale);
		shotParams.image_yscale = sign(_player.image_yscale);
		shotParams.gravDir = _player.gravDir;
		
		var _bullet = instance_create(_position[Vector2.x], _position[Vector2.y], _depth, shotObject, shotParams);
		entity_transfer_ownership(_bullet, _player);
		_bullet.createdBy = _player.id;
		_bullet.lifeState = LifeState.ALIVE;
		_bullet.destroyOnWeaponSwitch = true;
		_bullet.onSpawn();
		
		return _bullet
    };
    
    #endregion
}

/// @func create_weapon_shot_builder()
/// @desc Helper function for making a WeaponShotBuilder instance.
///       Mainly so method chaining is possible right off a fresh instance.
///
/// @returns {WeaponShotBuilder}  A WeaponShotBuilder instance
function create_weapon_shot_builder() {
    return new WeaponShotBuilder();
}
