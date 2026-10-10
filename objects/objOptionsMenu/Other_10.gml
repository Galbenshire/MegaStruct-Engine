/// @description Init Menu
#region Main

with (new OptionsMenu_Submenu("main", "OPTIONS")) {
	self.add_item(new OptionsMenu_Item_SwitchSubmenu("LEAVE", undefined));
	self.add_item(new OptionsMenu_Item_SwitchSubmenu("CONTROLS", "controls"));
	self.add_item(new OptionsMenu_Item_SwitchSubmenu("DISPLAY", "display"));
	self.add_item(new OptionsMenu_Item_SwitchSubmenu("AUDIO", "audio"));
	self.add_item(new OptionsMenu_Item_SwitchSubmenu("OTHER", "misc"));
	
	self.initialize_list(true);
	other.menu.add_submenu(self);
}

#endregion

#region Controls

with (new OptionsMenu_Submenu("controls", "CONTROLS")) {
	self.add_item(new OptionsMenu_Item_SwitchSubmenu("BACK", "main"));
	self.add_item(new OptionsMenu_Item_ControlBinding(true));
	self.add_item(new OptionsMenu_Item_ControlBinding(false));
	self.add_item(new OptionsMenu_Item_Toggle("downJumpSlide", "DOWN+JUMP", false, ["NONE", "SLIDE"]));
	self.add_item(new OptionsMenu_Item_Toggle("autoFire", "AUTO FIRE"));
	self.add_item(new OptionsMenu_Item_Toggle("chargeToggle", "CHARGE TOGGLE"));
	
	self.initialize_list(true);
	other.menu.add_submenu(self);
}

#endregion

#region Display

with (new OptionsMenu_Submenu("display", "DISPLAY")) {
	self.add_item(new OptionsMenu_Item_SwitchSubmenu("BACK", "main"));
	self.add_item(new OptionsMenu_Item_Toggle("fullscreen", "FULLSCREEN", true));
	if (!is_browser())
		self.add_item(new OptionsMenu_Item_ScreenSize());
    self.add_item(new OptionsMenu_Item_Toggle("pixelPerfect", "PIXEL PERFECT", true));
    self.add_item(new OptionsMenu_Item_Toggle("vsync", "VSYNC", true));
    self.add_item(new OptionsMenu_Item_Toggle("showFPS", "SHOW FPS"));
    
    self.initialize_list(true);
	other.menu.add_submenu(self);
}

#endregion

#region Audio

with (new OptionsMenu_Submenu("audio", "AUDIO")) {
	self.add_item(new OptionsMenu_Item_SwitchSubmenu("BACK", "main"));
	self.add_item(new OptionsMenu_Item_Slider("volumeMaster", "MASTER VOLUME"));
	self.add_item(new OptionsMenu_Item_Slider("volumeMusic", "MUSIC VOLUME"));
	self.add_item(new OptionsMenu_Item_Slider("volumeSound", "SOUND VOLUME"));
	
	self.initialize_list(true);
	other.menu.add_submenu(self);
}

#endregion

#region Other

with (new OptionsMenu_Submenu("misc", "OTHER")) {
	self.add_item(new OptionsMenu_Item_SwitchSubmenu("BACK", "main"));
	self.add_item(new OptionsMenu_Item_GameSpeed());
	self.add_item(new OptionsMenu_Item_Toggle("chargeBar", "CHARGE BAR"));
	self.add_item(new OptionsMenu_Item_Toggle("instantHealthFill", "HEALTH FILL", false, ["GRADUAL", "INSTANT"]));
	self.add_item(new OptionsMenu_Item_Toggle("damagePopup", "DAMAGE POPUP"));
	self.add_item(new OptionsMenu_Item_Toggle("screenShake", "SCREEN SHAKES"));
	
	self.initialize_list(true);
	other.menu.add_submenu(self);
}

#endregion

with (menu) {
	for (var i = 0; i < submenuCount; i++) {
		with (submenus[i]) {
			self.refresh_item_values();
			defaultItem = items[0];
		}
	}
	
	defaultSubmenu = submenus[0];
	self.pass_submenu_focus(defaultSubmenu);
}