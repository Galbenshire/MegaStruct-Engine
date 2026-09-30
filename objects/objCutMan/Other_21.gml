/// @description Method Init
/// @init
event_inherited();
	/// -- clear_attacks()
	/// Clears all attacks created by this boss. Called when killed.
	function clear_attacks() {
		with (objCutManCutter)
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
		if (_id != "cutter")
			return;
		
		var _x = x + 12 * image_xscale,
			_y = y + 4 * image_yscale;
		
		var _cutter = spawn_entity(_x, _y, depth, objCutManCutter);
		_cutter.xspeed = 3 * image_xscale;
		_cutter.owner = self;
		set_velocity_vector(3, point_direction(x, y, reticle.x, reticle.y), _cutter);
		return _cutter;
	}