/// @description On Pickup
global.bolts += value;
global.bolts = clamp(global.bolts, 0, 999);

__collected = true;
play_sfx(sfxBolt);
