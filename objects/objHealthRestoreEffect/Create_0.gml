// Performs the "game pauses while player health/ammo gets refilled" effect

healthpoints = 0;
ammo = [[], []]; // Array 0 = weapons; Array 1 = corresponding ammo to restore;
ammoCount = 0;

timer = 0;

queue_pause();