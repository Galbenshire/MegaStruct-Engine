/// @description Method Init
/// @init
// These tabs spaces are just so it looks better organized in the outline view in GMEdit
	
	/// -- require_animation(animation_name)
	/// Helper function for ensure the boss as a required animation defined
	///
	/// @param {string}  animation_name  The name of the required animation
	function require_animation(_animName) {
		assert(animator.has_animation(_animName), $"Missing animation for {object_get_name(object_index)} (\"{_animName}\")");
	}
	
	/// -- update_hud_health(amount)
	/// Updates the healthbar on the boss's HUD
	///
	/// @param {number}  [amount]  The amount to set the healthbar to. Optional.
	function update_hud(_amount) {
		hudElement.healthpoints = _amount;
	}