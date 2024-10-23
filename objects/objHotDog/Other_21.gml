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
		if (_id == "fire") {
			_x = x + _x * image_xscale;
			_y = y + _y * image_yscale;
			
			with (spawn_entity(_x, _y, depth - 0.5, objGenericEnemyBullet)) {
				sprite_index = sprHotDogFire;
				image_index = other.stateMachine.timer;
				owner = other.id;
				animSpeed = 0.5;
				contactDamage = 2;
				xspeed.value = 4 * other.image_xscale;
				yspeed.value = 5 * other.image_yscale;
				gravEnabled = true;
				grav = -0.3;
				return self;
			}
		} else if (_id == "death_explode") {
			instance_create_depth(_x, _y, depth + irandom(1), objExplosion);
			play_sfx(sfxEnemyHit);
		}
		
		return noone;
	}