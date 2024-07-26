/// @description Boss Posttick
event_inherited();

sprite_index = cutterExists ? sprCutManNaked : sprCutMan;

if (animator.flag == "shoot")
    shootFlag = true;