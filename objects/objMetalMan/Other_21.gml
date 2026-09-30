/// @description Method Init
/// @int
event_inherited();

	/// -- clear_attacks()
	/// Clears all attacks created by this boss. Called when killed.
	function clear_attacks() {
		with (objGenericEnemyBullet) {
			if (owner == other.id)
				instance_destroy();
		}
	}
	
	/// -- perform_action(id, params)
	/// Creates an attack, based on the ID & further parameters provided
	///
	/// @param {string}  id  ID of the attack
	/// @param {struct}  [params]  struct that defines various properties of the attack. Optional.
	///
	/// @returns {instance}  The created attack
	function perform_action(_id, _params = {}) {
		if (_id != "metal_blade")
			return;
			
		play_sfx(sfxMetalBlade);
		with (spawn_entity(x + 8 * image_xscale, y, depth, objGenericEnemyBullet)) {
			sprite_index = sprMetalBlade;
			owner = other.id;
			animSpeed = 0.35;
			contactDamage = 3;
			xspeed = 4 * other.image_xscale;
			set_velocity_vector(4, point_direction(x, y, other.reticle.x, other.reticle.y));
			return self;
		}
		
		return noone;
	}