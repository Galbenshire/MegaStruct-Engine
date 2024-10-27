/// @description Method Init
/// @init
// These tabs spaces are just so it looks better organized in the outline view in GMEdit
	
	/// -- common_state_intro_spawn(event)
	/// Executes code common for an intro state
	///
	/// @param {string}  event  The event to execute
	function common_state_intro_spawn(_event) {
		switch (_event) {
			case "enter":
				isIntro = true;
				visible = true;
				
				if (lockControlsDuringIntro) {
					introLock.activate();
					introPauseLock.activate();
				}
				
				if (playBossMusic) {
					preFightMusicCache[MusicSnapshot.musicID] = objSystem.music.trackID;
					preFightMusicCache[MusicSnapshot.startAt] = audio_sound_get_track_position(objSystem.music.track);
					preFightMusicCache[MusicSnapshot.volume] = objSystem.music.trackVolume;
					play_music(bossMusicID);
				}
				break;
			
			case "posttick":
				if (strikeIntroPose)
					stateMachine.change_state("!!Intro_Pose");
				else
					stateMachine.change_state("!!FinishIntro");
				break;
			
			case "leave":
				isIntro = false;
				break;
		}
	}
	
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
		show_debug_message($"create_projectile not implemented for {object_get_name(object_index)}");
		return noone;
	}
	
	/// -- disconnect_hud()
	/// Removes the boss' healthbar from the HUD
	function disconnect_hud() {
		with (objSystem.hud) {
			var _index = array_get_index(bossHUD, other.hudElement);
			if (_index != NOT_FOUND)
				array_delete(bossHUD, _index, 1);
		}
	}
	
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