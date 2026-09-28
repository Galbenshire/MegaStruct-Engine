/// @description Boss Posttick
event_inherited();

sprite_index = cutterExists ? sprCutManNaked : sprCutMan;

if (animator.has_flag("shoot"))
    shootFlag = true;
