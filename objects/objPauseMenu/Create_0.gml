menu = new PauseMenu();
weaponSubmenu = undefined;
optionsSubmenu = undefined;
playerSubmenu = undefined;

guiTemplate = new GUITemplate(pfbPauseMenu);
guiPositionWeapons = guiTemplate.get_position("weapons");
guiPositionOptions = guiTemplate.get_position("options");
guiPositionPlayer = guiTemplate.get_position("player");

phase = 0;
phaseTimer = 0;

weapons = [];
weaponCount = 0;

event_user(0);
play_sfx(sfxPause);