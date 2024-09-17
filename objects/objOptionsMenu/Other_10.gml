/// @description Init Menu
#region Main

with (new OptionsMenu_Submenu("main", "OPTIONS")) {
	var _items = [];
	array_push(_items, new OptionsMenu_Item_SwitchSubmenu("LEAVE", undefined));
	array_push(_items, new OptionsMenu_Item_SwitchSubmenu("CONTROLS", "controls"));
	array_push(_items, new OptionsMenu_Item_SwitchSubmenu("DISPLAY", "display"));
	array_push(_items, new OptionsMenu_Item_SwitchSubmenu("AUDIO", "audio"));
	array_push(_items, new OptionsMenu_Item_SwitchSubmenu("OTHER", "misc"));
	
	add_items_from_list(_items, true, true);
	other.menu.add_submenu(self);
}

#endregion

#region Controls

with (new OptionsMenu_Submenu("controls", "CONTROLS")) {
	var _items = [];
	array_push(_items, new OptionsMenu_Item_SwitchSubmenu("BACK", "main"));
	array_push(_items, new OptionsMenu_Item_ControlBinding(true));
	array_push(_items, new OptionsMenu_Item_ControlBinding(false));
	array_push(_items, new OptionsMenu_Item_Toggle("downJumpSlide", "DOWN+JUMP", false, ["NONE", "SLIDE"]));
	array_push(_items, new OptionsMenu_Item_Toggle("autoFire", "AUTO FIRE"));
	array_push(_items, new OptionsMenu_Item_Toggle("chargeToggle", "CHARGE TOGGLE"));
	
	add_items_from_list(_items, true, true);
	other.menu.add_submenu(self);
}

#endregion

#region Display

with (new OptionsMenu_Submenu("display", "DISPLAY")) {
	var _items = [];
	array_push(_items, new OptionsMenu_Item_SwitchSubmenu("BACK", "main"));
	array_push(_items, new OptionsMenu_Item_Toggle("fullscreen", "FULLSCREEN", true));
	array_push(_items, new OptionsMenu_Item_ScreenSize());
    array_push(_items, new OptionsMenu_Item_Toggle("pixelPerfect", "PIXEL PERFECT", true));
    array_push(_items, new OptionsMenu_Item_Toggle("vsync", "VSYNC", true));
    array_push(_items, new OptionsMenu_Item_Toggle("showFPS", "SHOW FPS"));
    
    add_items_from_list(_items, true, true);
	other.menu.add_submenu(self);
}

#endregion

#region Audio

with (new OptionsMenu_Submenu("audio", "AUDIO")) {
	var _items = [];
	array_push(_items, new OptionsMenu_Item_SwitchSubmenu("BACK", "main"));
	array_push(_items, new OptionsMenu_Item_Slider("volumeMaster", "MASTER VOLUME"));
	array_push(_items, new OptionsMenu_Item_Slider("volumeMusic", "MUSIC VOLUME"));
	array_push(_items, new OptionsMenu_Item_Slider("volumeSound", "SOUND VOLUME"));
	
	add_items_from_list(_items, true, true);
	other.menu.add_submenu(self);
}

#endregion

#region Other

with (new OptionsMenu_Submenu("misc", "OTHER")) {
	var _items = [];
	array_push(_items, new OptionsMenu_Item_SwitchSubmenu("BACK", "main"));
	array_push(_items, new OptionsMenu_Item_GameSpeed());
	array_push(_items, new OptionsMenu_Item_Toggle("chargeBar", "CHARGE BAR"));
	
	add_items_from_list(_items, true, true);
	other.menu.add_submenu(self);
}

#endregion

with (menu) {
	for (var i = 0; i < submenuCount; i++) {
		with (submenus[i]) {
			refresh_item_values();
			defaultItem = items[0];
		}
	}
	
	defaultSubmenu = submenus[0];
	pass_submenu_focus(defaultSubmenu);
}