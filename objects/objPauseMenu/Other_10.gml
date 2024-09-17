/// @description Init
// === Weapons Init ===
weapons = global.player.body.loadout;
weaponCount = array_length(weapons);

// === Menu Init ===

weaponSubmenu = new PauseMenu_Submenu_Weapons();
with (weaponSubmenu) {
    var _items = array_create_ext(other.weaponCount, function(i) {
        var _item = new PauseMenu_Item_Weapon($"weapon_{i}", other.weapons[i]);
        if (_item.weapon == global.player.body.weapon)
            defaultItem = _item;
        return _item;
    });
    
    add_items_from_list(_items, true, true);
	other.menu.add_submenu(self);
}

optionsSubmenu = new PauseMenu_Submenu_Options();
with (optionsSubmenu) {
    var _items = [];
    array_push(_items, new PauseMenu_Item_Text("options", "OPTIONS"));
    array_push(_items, new PauseMenu_Item_Text("retry", "RETRY"));
    array_push(_items, new PauseMenu_Item_Text("exitstage", "EXIT"));
    
    add_items_from_list(_items, true, true);
    defaultItem = items[0];
	other.menu.add_submenu(self);
}

playerSubmenu = new PauseMenu_Submenu_Player();
menu.add_submenu(playerSubmenu);

with (menu) {
    defaultSubmenu = other.weaponSubmenu;
    pass_submenu_focus(defaultSubmenu);
}
weaponSubmenu.neighbourRight = optionsSubmenu;
weaponSubmenu.neighbourLeft = optionsSubmenu;
optionsSubmenu.neighbourRight = weaponSubmenu;
optionsSubmenu.neighbourLeft = weaponSubmenu;

// === Screen Fade ===
screen_fade({
    onFadeOutStart: function() /*=>*/ { queue_pause(); },
    onFadeOutEnd: function() /*=>*/ { event_user(1); },
    fadeOutDuration: 10,
    fadeInDuration: 10
});