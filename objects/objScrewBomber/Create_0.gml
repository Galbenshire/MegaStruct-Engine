event_inherited();

phase = 0;
phaseTimer = 0;
cooldownTimer = 0;
bulletCount = 0;
mainHitbox = noone;

// Callbacks
onSpawn = function() {
    cbkOnSpawn_prtEntity();
    phase = 0;
    phaseTimer = 0;
    bulletCount = 0;
    cooldownTimer = 0;
    mainHitbox = hitbox_create_simple(-4, -8, bbox_width(), bbox_height(), true, false, canTakeDamage);
    //mainHitbox.visible = true;
};
onDraw = method(id, cbkOnDraw_colourReplacer);

event_user(0); // Init Palette