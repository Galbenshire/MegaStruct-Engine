/// @description Method Init
/// @init
// These tabs spaces are just so it looks better organized in the outline view in GMEdit
	
	#region HUD
	
	/// -- connect_hud()
	/// Adds the boss' healthbar to the HUD
	function connect_hud() {
		array_push(objSystem.hud.bossHUD, hudElement);
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
	
	/// -- update_hud_health(amount)
	/// Updates the healthbar on the boss's HUD
	///
	/// @param {number}  [amount]  The amount to set the healthbar to. Optional.
	function update_hud(_amount) {
		hudElement.healthpoints = _amount;
	}
	
	#endregion
	
	#region Other
	
	/// -- clear_attacks()
	/// Clears all attacks created by this boss. Called when killed.
	function clear_attacks() {
		// ...
	}
	
	/// -- death_effect()
	/// Boss death effect
	function death_effect() {
		if (doPlayerDeathExplosion) {
			player_death_explosion(x, y, depth);
			play_sfx(sfxDeath);
		}
	}
	
	/// -- get_intro_sequence()
	/// Gets a list of states that makes up the boss's intro sequence
	function get_intro_sequence() {
		if (!array_empty(customIntroSequence))
			return customIntroSequence;
		
		var _sequence = [];
		if (lockControlsDuringIntro)
			array_push(_sequence, "!!Intro_WaitForOthers");
		if (showHealthbar)
			array_push(_sequence, "!!Intro_FillHealthbar");
		if (strikeIntroPose)
			array_push(_sequence, "!!Intro_Pose");
		if (introType == "Custom") {
			assert(!string_empty(customIntroState), $"{object_get_name(object_index)} was set to have a custom intro spawn, but the state was not specified");
			array_push(_sequence, customIntroState);
		} else {
			array_push(_sequence, "!!Intro_Spawn");
		}
		return _sequence;
	}
	
	/// -- perform_action(id, params)
	/// Creates an attack, based on the ID & further parameters provided
	///
	/// @param {string}  id  ID of the attack
	/// @param {struct}  [params]  struct that defines various properties of the attack. Optional.
	///
	/// @returns {instance}  The created attack
	function perform_action(_id, _params = {}) {
		show_debug_message($"perform_action not implemented for {object_get_name(object_index)}");
		return noone;
	}
	
	/// -- restore_music()
	/// Halts the boss music, restoring the music that was playing before the fight began
	/// (or cutting the music altogether if configured to do so)
	function restore_music() {
		switch (postFightMusicBehaviour) {
			case PostBossMusicBehaviour.CONTINUE:
				// Do nothing
				break;
			case PostBossMusicBehaviour.STOP:
				stop_music();
				audio_stop_all();
				break;
			case PostBossMusicBehaviour.RESUME:
				if (preFightMusicCache[MusicSnapshot.musicID] != -1) {
					play_music(preFightMusicCache[MusicSnapshot.musicID], preFightMusicCache[MusicSnapshot.volume]);
					audio_sound_set_track_position(objSystem.audio.track, preFightMusicCache[MusicSnapshot.startAt]);
				} else {
					stop_music();
				}
				break;
		}
	}
	
	#endregion