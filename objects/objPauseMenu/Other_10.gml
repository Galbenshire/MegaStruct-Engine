/// @description Init
// === UI Init ===
var _pauseMenuPrefab = room_get_info(pfbPauseMenu, false, false, true, true, false);
bgSprites = array_reverse(_pauseMenuPrefab.layers[0].elements);
bgSpritesCount = array_length(bgSprites);

// This is to fix a visual bug when in YYC
for (var i = 0; i < bgSpritesCount; i++)
    bgSprites[i].sprite_index &= 0xFFFFFFFF;

// === Screen Fade ===
screen_fade({
    onFadeOutStart: function() /*=>*/ { queue_pause(); },
    onFadeOutEnd: function() /*=>*/ { event_user(1); },
    onFadeInEnd: function() /*=>*/ { active = true; }
});