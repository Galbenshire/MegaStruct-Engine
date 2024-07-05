/// @description Boss Posttick
event_inherited();

sprite_index = cutterExists ? sprCutManNaked : sprCutMan;

if (animator.flag == "shoot") {
	show_debug_message("shoot - {0}", global.roomTimer);
    shootFlag = true;
}