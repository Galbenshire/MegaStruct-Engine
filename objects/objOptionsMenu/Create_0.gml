menu = new OptionsMenu();

phase = 0;
phaseTimer = 0;

bgSprites = [];
bgSpritesCount = 0;
markers = {};

crossFadeDuration = 10;

bgY = 0;
bgSpeed = 1/5;

event_user(0); // Menu Init
event_user(1); // Marker/Backdrop Init

appSurfResizeListener = signal_bus().connect_to_signal("appSurfaceResize", self, function(_data) /*=>*/ { menu.submenus.display.refresh_item_values(); });