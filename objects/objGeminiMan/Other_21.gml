/// @description Method Init
/// @init
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
		_x = x + _x * image_xscale;
		_y = y + _y * image_yscale;
		
		if (_id == "bullet") {
			with (spawn_entity(_x, _y, depth - 0.5, objGenericEnemyBullet)) {
				sprite_index = sprBusterShot;
				image_xscale = other.image_xscale;
				owner = other.id;
				contactDamage = 3;
				xspeed.value = 4 * image_xscale;
				return self;
			}
		} else if (_id == "laser") {
			for (var i = -1; i <= 1; i++) {
				var _laser = spawn_entity(_x + 7 * i, _y, depth - 0.5, objGeminiManLaser);
				_laser.xspeed.value = 2 * image_xscale;
			}
		}
		
		return noone;
	}