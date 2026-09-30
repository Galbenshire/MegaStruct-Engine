/// @description Method Init
/// @init
event_inherited();

	/// -- perform_action(id, params)
	/// Creates an attack, based on the ID & further parameters provided
	///
	/// @param {string}  id  ID of the attack
	/// @param {struct}  [params]  struct that defines various properties of the attack. Optional.
	///
	/// @returns {instance}  The created attack
	function perform_action(_id, _params = {}) {
		if (_id == "fire") {
			with (spawn_entity(x + 16 * image_xscale, y, depth - 0.5, objGenericEnemyBullet)) {
				sprite_index = sprHotDogFire;
				image_index = other.stateMachine.get_timer();
				owner = other.id;
				animSpeed = 0.5;
				contactDamage = 2;
				xspeed = 4 * other.image_xscale;
				yspeed = 5 * other.image_yscale;
				gravEnabled = true;
				grav = -0.3;
				return self;
			}
		} else if (_id == "death_explode") {
			instance_create_depth(_params.x, _params.y, depth + irandom_range(-1, 1), objExplosion);
			play_sfx(sfxEnemyHit);
		}
		
		return noone;
	}