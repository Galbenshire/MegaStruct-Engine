#region Music

/// @func music_volume(in_general)
/// @desc Gets the current volume of the music in the game
///
/// @param {bool}  [in_general]  If true, this functions returns the volume of music in general.
///		If false (default), it returns the volume relative to the currently playing track.
///
/// @returns {number}  The volume of music, in a 0-1 range
function music_volume(_inGeneral = false) {
	return options_data().get_music_volume() * (_inGeneral ? 1 : objSystem.audio.trackVolume);
}

/// @func fade_music(duration, to)
/// @desc Fades the current music to the specified volume level
///
/// @param {number}  duration  how long the fade occurs for, in seconds
/// @param {number}  [to]  the final volume level after the fade. Defaults to 0, muted
function fade_music(_duration, _to = 0) {
	with (objSystem.audio) {
		trackVolume = _to;
		if (trackIsPlaying)
			audio_sound_gain(track, trackVolume, _duration * 1000);
	}
}

/// @func music_is_paused()
/// @desc Checks if the current music is paused
///
/// @returns {bool}  
function music_is_paused() {
	with (objSystem.audio)
		return trackIsPlaying ? audio_is_paused(track) : false;
	return false;
}

/// @func music_is_playing()
/// @desc Checks if the current music is playing
///
/// @returns {bool}  
function music_is_playing() {
	with (objSystem.audio) {
		return trackIsPlaying
			? audio_is_playing(track) && !audio_is_paused(track)
			: false;
	}
	return false;
}

/// @func pause_music()
/// @desc Pauses the music currently playing
function pause_music() {
	if (objSystem.audio.trackIsPlaying)
		audio_pause_sound(objSystem.audio.track);
}

/// @func play_music(music_id, volume)
/// @desc Plays a piece of music
///
/// @param {int}  music_id  ID of the music to play, corresponding to the `Music` enum
/// @param {number}  [volume]  How loud the track should be. Defaults to 1.
function play_music(_id, _volume = 1) {
	var _track = global.musicTracks[_id];
	
	with (objSystem.audio) {
		if (trackIsPlaying)
			audio_stop_sound(track);
		
		trackIsPlaying = true;
		trackVolume = max(0, _volume);
		trackID = _id;
		track = audio_play_sound_on(emitterMusic, _track[MusicTrack.asset], _track[MusicTrack.loops], 90, trackVolume);
		audio_sound_loop_start(track, _track[MusicTrack.loopStart]);
		audio_sound_loop_end(track, _track[MusicTrack.loopEnd]);
	}
}

/// @func resume_music()
/// @desc Resumes the music, if it was previously paused
function resume_music() {
	if (objSystem.audio.trackIsPlaying)
		audio_resume_sound(objSystem.audio.track);
}

/// @func stop_music()
/// @desc Stops the music currently playing
function stop_music() {
	with (objSystem.audio) {
		if (trackIsPlaying)
			audio_stop_sound(track);
		trackVolume = 0;
		trackIsPlaying = false;
	}
}

/// @func update_music_volume(volume)
/// @desc Updates the volume of the music currently playing
///
/// @param {number}  [volume]  How loud the track should be. Defaults to the current volume of the track.
function update_music_volume(_volume) {
	with (objSystem.audio) {
		_volume ??= trackVolume;
		trackVolume = max(0, _volume);
		if (trackIsPlaying)
			audio_sound_gain(track, trackVolume, 0);
	}
}

#endregion

#region Sound Effects

/// @func sound_volume()
/// @desc Gets the current volume of sound effects in the game
///
/// @returns {number}  The volume of sound effects, in a 0-1 range
function sound_volume() {
	return options_data().get_sound_volume();
}

/// @func create_sound_instance()
/// @desc Creates an inactive sound instance. For when you want an 'optional' sound instance
///
/// @returns {sound_instance}  
function create_sound_instance() {
	var _sfx = audio_play_sound(sfxExplosionMM3, 0, false, 0);
	//audio_stop_sound(_sfx);
	return _sfx;
}

/// @func loop_sfx(sound, volume, pitch, stack_sounds, emitter)
/// @desc Shortcut for looping a sound effect with the play_sfx() script
///
/// @param {sound}  sound  The sound effect to loop
/// @param {number}  [volume]  How loud the sound should be. Defaults to 1.
/// @param {number}  [pitch]  Adjusts the pitch of the sound. Defaults to 1 (no change).
/// @param {bool}  [stack_sounds]  By default, looping a sound effect will stop all instances of that sound first. Setting this to false stops that.
///
/// @returns {sound_instance}  A reference to the sound effect you just looped
function loop_sfx(_sound/*:sound*/, _volume/*:number*/ = 1, _pitch/*:number*/ = 1, _stack/*:bool*/ = false) {
	return play_sfx(_sound, _volume, _pitch, true, _stack);
}

/// @func pause_all_sfx()
/// @desc Pauses all sound effects currently playing
function pause_all_sfx() {
	var _fixMusic = music_is_playing();
	audio_pause_all();
	if (_fixMusic)
		resume_music();
}

/// @func resume_all_sfx()
/// @desc Resume any sound effects that had been paused
function resume_all_sfx() {
	var _fixMusic = !music_is_paused();
	audio_resume_all();
	if (_fixMusic)
		resume_music();
}

/// @func play_sfx(sound, volume, pitch, loop, stack_sounds, emitter)
/// @desc Plays the given sound effect.
///
/// @param {sound}  sound  The sound effect to play
/// @param {number}  [volume]  How loud the sound should be. Defaults to 1.
/// @param {number}  [pitch]  Adjusts the pitch of the sound. Defaults to 1 (no change).
/// @param {bool}  [loop]  Whether the sound should loop (true) or not (false). Defaults to false.
/// @param {bool}  [stack_sounds]  By default, playing a sound effect will stop all instances of that sound first. Setting this to false stops that.
///
/// @returns {sound_instance}  A reference to the sound effect you just played
function play_sfx(_sound/*:sound*/, _volume/*:number*/ = 1, _pitch/*:number*/ = 1, _loop/*:bool*/ = false, _stack/*:bool*/ = false) {
	if (!_stack)
		stop_sfx(_sound);
	
	return audio_play_sound_on(objSystem.audio.emitterSFX, _sound, _loop, 50 - 10 * _loop, _volume, /**/, _pitch);
}

/// @func stop_sfx(sound)
/// @desc Stops all instances of a given sound effect, or a specific instance of a sound
///
/// @param {sound|sound_instance}  sound  The sound effect to stop
function stop_sfx(_sound/*:sound|sound_instance*/) {
	audio_stop_sound(_sound);
}

#endregion
