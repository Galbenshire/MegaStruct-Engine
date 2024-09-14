/// @description Tick
event_inherited();

var _x = x,
    _xscale = image_xscale,
    _mask = mask_index;
mask_index = sprDot;
x -= 6 * image_xscale;
image_xscale *= 12;

if (check_for_solids(x, y)) {
    play_sfx(sfxExplosionMM3);
    spawn_entity(x + 6 * _xscale, y, depth, objHarmfulExplosion, { contactDamage: 4 });
    entity_kill_self();
}

mask_index = _mask;
x = _x;
image_xscale = _xscale;
