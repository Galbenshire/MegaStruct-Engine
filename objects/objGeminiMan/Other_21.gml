/// @description Method Init
/// @init
event_inherited();

	/// -- clear_attacks()
	/// Clears all attacks created by this boss. Called when killed.
	function clear_attacks() {
		with (objGenericEnemyBullet) {
			if (owner == other.id)
				instance_destroy();
		}
		with (objGeminiManLaser)
			instance_destroy();
	}
	
	/// -- perform_action(id, params)
	/// Creates an attack, based on the ID & further parameters provided
	///
	/// @param {string}  id  ID of the attack
	/// @param {struct}  [params]  struct that defines various properties of the attack. Optional.
	///
	/// @returns {instance}  The created attack
	function perform_action(_id, _params = {}) {
		var _x = x + 12 * image_xscale,
			_y = y + 2 * image_yscale;
		
		if (_id == "bullet") {
			with (spawn_entity(_x, _y, depth - 0.5, objGenericEnemyBullet)) {
				sprite_index = sprBusterShot;
				image_xscale = other.image_xscale;
				owner = other.id;
				contactDamage = 3;
				xspeed = 4 * image_xscale;
				return self;
			}
		} else if (_id == "laser") {
			for (var i = -1; i <= 1; i++) {
				var _laser = spawn_entity(_x + 7 * i, _y, depth - 0.5, objGeminiManLaser);
				_laser.xspeed = 2 * image_xscale;
			}
		}
		
		return noone;
	}