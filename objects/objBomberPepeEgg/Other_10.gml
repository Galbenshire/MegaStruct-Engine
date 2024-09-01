/// @description Blow up
var _expl = spawn_entity(x, y, depth, objHarmfulExplosion);
_expl.contactDamage = 6;

play_sfx(sfxExplosionMM3);
entity_kill_self();