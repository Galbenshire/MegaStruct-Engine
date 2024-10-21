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
		if (_id != "cutter")
			return;
		
		_x = x + _x * image_xscale;
		_y = y + _y * image_yscale;
		
		var _cutter = spawn_entity(_x, _y, depth, objCutManCutter);
		_cutter.xspeed.value = 3 * image_xscale;
		_cutter.owner = self;
		set_velocity_vector(3, point_direction(x, y, reticle.x, reticle.y), _cutter);
		return _cutter;
	}