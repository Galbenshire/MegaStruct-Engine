/// @func loop_sfx(sound, stack_sounds)
/// @desc Shortcut for looping a sound effect with the play_sfx() script
///
/// @param {sound}  sound  The sound effect to loop
/// @param {bool}  [stack_sounds]  By default, playing a sound effect will stop all instances of that sound first. Setting this to false stops that.
///
/// @returns {sound_instance}  A reference to the sound effect you just looped
function loop_sfx(_sound/*:sound*/, _stack/*:bool*/ = false) {
	return play_sfx(_sound, true, _stack);
}

/// @func play_music(music_id)
/// @desc Plays a piece of music
function play_music(_id) {
	var _track = global.musicTracks[_id];
	
	with (objSystem.music) {
		if (!is_undefined(track))
			audio_stop_sound(track);
		
		track = audio_play_sound(_track[MusicTrack.asset], 90, _track[MusicTrack.loops]);
		audio_sound_loop_start(track, _track[MusicTrack.loopStart]);
		audio_sound_loop_end(track, _track[MusicTrack.loopEnd]);
		audio_sound_gain(track, options_data().get_music_volume(), 0);
	}
}

/// @func play_sfx(sound, loop, stack_sounds)
/// @desc Plays the given sound effect.
///
/// @param {sound}  sound  The sound effect to play
/// @param {bool}  [loop]  Whether the sound should loop (true) or not (false). Defaults to false.
/// @param {bool}  [stack_sounds]  By default, playing a sound effect will stop all instances of that sound first. Setting this to false stops that.
///
/// @returns {sound_instance}  A reference to the sound effect you just played
function play_sfx(_sound/*:sound*/, _loop/*:bool*/ = false, _stack/*:bool*/ = false) {
	if (!_stack)
		stop_sfx(_sound);
	
	var _sfx = audio_play_sound(_sound, 50 - 10 * _loop, _loop);
	audio_sound_gain(_sfx, options_data().get_sound_volume(), 0);
	return _sfx;
}

/// @func stop_sfx(sound)
/// @desc Stops all instances of a given sound effect, or a specific instance of a sound
///
/// @param {sound|sound_instance}  sound  The sound effect to stop
function stop_sfx(_sound/*:sound|sound_instance*/) {
	audio_stop_sound(_sound);
}
