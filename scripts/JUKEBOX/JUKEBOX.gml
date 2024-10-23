/// @func __init_jukebox()
/// @desc Holds all the music in the engine
///
/// @returns {array<MusicTrack>}  An array of music tracks
function __init_jukebox() {
    var _musicList = array_create(MusicAsset.COUNT);
    
    _musicList[MusicAsset.MM1_CUTMAN] = [ musMM1CutMan, true, 3.2, 0 ];
    _musicList[MusicAsset.MM2_METALMAN] = [ musMM2MetalMan, true, 0, 0 ];
    _musicList[MusicAsset.MM3_GEMINIMAN] = [ musMM3GeminiMan, true, 0, 0 ];
    _musicList[MusicAsset.MM5_TITLE_SCREEN] = [ musMM5TitleScreen, true, 0, 0 ];
    _musicList[MusicAsset.MM5_PASSWORD] = [ musMM5Password, true, 1.256, 0 ];
    
    return _musicList;
}
