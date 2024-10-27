/// @func __init_jukebox()
/// @desc Holds all the music in the engine
///
/// @returns {array<MusicTrack>}  An array of music tracks
function __init_jukebox() {
    var _musicList = array_create(Music.COUNT);
    
    _musicList[Music.MM1_CUTMAN] = [ musMM1CutMan, true, 3.2, 0 ];
    _musicList[Music.MM1_BOSSRM] = [ musMM1BossRM, true, 3.704, 0 ];
    _musicList[Music.MM2_METALMAN] = [ musMM2MetalMan, true, 0, 0 ];
    _musicList[Music.MM2_BOSS] = [ musMM2Boss, true, 6.395, 0 ];
    _musicList[Music.MM3_GEMINIMAN] = [ musMM3GeminiMan, true, 0, 0 ];
    _musicList[Music.MM3_BOSSRM] = [ musMM3BossRM, true, 5.881, 0 ];
    _musicList[Music.MM5_TITLE_SCREEN] = [ musMM5TitleScreen, true, 0, 0 ];
    _musicList[Music.MM5_PASSWORD] = [ musMM5Password, true, 1.256, 0 ];
    
    return _musicList;
}
