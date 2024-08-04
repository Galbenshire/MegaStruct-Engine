/// @description Init
// === UI Init ===
var _pauseMenuPrefab = room_get_info(pfbPauseMenu, false, false, true, true, false);
bgSprites = array_reverse(_pauseMenuPrefab.layers[1].elements);
bgSpritesCount = array_length(bgSprites);

// This is to fix a visual bug when in YYC
for (var i = 0; i < bgSpritesCount; i++)
    bgSprites[i].sprite_index &= 0xFFFFFFFF;

// Grab all the marker positions
var _markerList = _pauseMenuPrefab.layers[0].elements,
    _markerCount = array_length(_markerList);
for (var i = 0; i < _markerCount; i++) {
    var _marker = _markerList[i],
        _markerName = string_split(_marker.name, "__")[1];
    struct_set(markers, _markerName, [_marker.x, _marker.y]);
}

// === Weapons Init ===
weapons = global.player.body.loadout;
weaponCount = array_length(weapons);

// === Menu Init ===

#region Weapons

with (menu.add_submenu("weapons")) {
    for (var i = 0; i < other.weaponCount; i++) {
        with (add_weapon_item($"weapon_{i}", other.weapons[i])) {
            onConfirm = function() {
                player_equip_weapon(weapon, global.player.body);
                player_refresh_palette(global.player.body);
                play_sfx(sfxMenuSelect);
                
                with (owner) {
                    phase = 99;
                    
                    screen_fade({
                        onFadeOutEnd: function(_fader) /*=>*/ { visible = false; },
                        onFadeInEnd: function(_fader) /*=>*/ { instance_destroy(); }
                    });
                }
            };
            
            if (weapon == global.player.body.weapon)
                submenu.defaultItem = self;
        }
    }
    
    generate_neighbours();
}

#endregion

with (menu) {
    defaultSubmenu = submenus.weapons;
    pass_submenu_focus(defaultSubmenu);
}

// === Screen Fade ===
screen_fade({
    onFadeOutStart: function() /*=>*/ { queue_pause(); },
    onFadeOutEnd: function() /*=>*/ { event_user(1); }
});