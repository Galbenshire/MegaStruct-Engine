/// @description On Pickup
global.bolts = clamp(global.bolts + value, 0, 999);
play_sfx(sfxBolt);
event_inherited();
