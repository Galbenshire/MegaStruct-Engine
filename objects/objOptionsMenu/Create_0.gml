menu = new OptionsMenu();
guiTemplate = new GUITemplate(pfbOptionsMenu);
guiPositionHeader = guiTemplate.get_position("header");
guiPositionBody = guiTemplate.get_position("body");

phase = 0;
phaseTimer = 0;

crossFadeDuration = 10;

bgY = 0;
bgSpeed = 1/5;

event_user(0); // Menu Init

appSurfResizeListener = signal_bus().connect_to_signal("appSurfaceResize", self, function(_data) /*=>*/ { menu.get_submenu("display").refresh_item_values(); });