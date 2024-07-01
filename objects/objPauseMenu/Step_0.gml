if (!active)
    return;

if (global.player.inputs.is_pressed(InputActions.PAUSE)) {
    screen_fade({
        onFadeOutStart: function(_fader) /*=>*/ { active = false; },
        onFadeOutEnd: function(_fader) /*=>*/ { visible = false; },
        onFadeInEnd: function(_fader) /*=>*/ { instance_destroy(); }
    });
    
    play_sfx(sfxMenuSelect);
}