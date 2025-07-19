/// @func __init_jukebox()
/// @desc Holds all the music in the engine
///
/// @returns {array<MusicTrack>}  An array of music tracks
function __init_jukebox() {
    var _musicList = array_create(Music.COUNT);
    
    // - MM1
    _musicList[Music.MM1_CUTMAN] = __add_jukebox_track(musMM1CutMan, true, 3.2);
    _musicList[Music.MM1_BOSSRM] = __add_jukebox_track(musMM1BossRM, true, 3.704);
    // - MM2
    _musicList[Music.MM2_METALMAN] = __add_jukebox_track(musMM2MetalMan, true);
    _musicList[Music.MM2_BOSS] = __add_jukebox_track(musMM2Boss, true, 6.395);
    // - MM3
    _musicList[Music.MM3_GEMINIMAN] = __add_jukebox_track(musMM3GeminiMan, true);
    _musicList[Music.MM3_BOSSRM] = __add_jukebox_track(musMM3BossRM, true, 5.881);
    // - MM5
    _musicList[Music.MM5_TITLE_SCREEN] = __add_jukebox_track(musMM5TitleScreen, true);
    _musicList[Music.MM5_PASSWORD] = __add_jukebox_track(musMM5Password, true, 1.256);
    
    return _musicList;
}

/// @func __add_jukebox_track(asset, loops, loop_start, loop_end)
/// @desc Adds a music track to the jukebox
///
/// @param {sound}  asset
/// @param {bool}  loops
/// @param {number}  [loop_start]
/// @param {number}  [loop_end]
///
/// @returns {MusicTrack}  The music track
function __add_jukebox_track(_asset, _loops, _loopStart = 0, _loopEnd = 0) {
    var _track = array_create(MusicTrack.sizeof);
    _track[MusicTrack.asset] = _asset;
    _track[MusicTrack.loops] = _loops;
    _track[MusicTrack.loopStart] = _loopStart;
    _track[MusicTrack.loopEnd] = _loopEnd;
    return _track;
}