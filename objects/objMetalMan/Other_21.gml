/// @description Method Init
/// @int
event_inherited();

	/// -- create_projectile(id, x, y, params)
	/// Creates an attack, based on the ID & further parameters provided
	///
	/// @param {string}  id  ID of the attack
	/// @param {number}  x  horizontal position of the attack (can be relative to the boss or not. depends on context)
	/// @param {number}  y  vertical position of the attack (can be relative to the boss or not. depends on context)
	/// @param {struct}  [params]  struct that defines various properties of the attack. Optional.
	///
	/// @returns {instance}  The created attack
	function create_projectile(_id, _x, _y, _params = {}) {
		if (_id != "metal_blade")
			return;
		
		_x = x + _x * image_xscale;
		_y = y + _y * image_yscale;
		play_sfx(sfxMetalBlade);
		
		with (spawn_entity(_x, _y, depth, objGenericEnemyBullet)) {
			sprite_index = sprMetalBlade;
			owner = other.id;
			animSpeed = 0.35;
			contactDamage = 3;
			xspeed.value = 4 * other.image_xscale;
			set_velocity_vector(4, point_direction(x, y, other.reticle.x, other.reticle.y));
			return self;
		}
		
		return noone;
	}