event_inherited();

// == Initialize Variables ==
event_user(0);

// == Gemini Man Specific Callbacks
onHurt = function(_damageSource) {
	cbkOnHurt_prtBoss(_damageSource);
	
	with (clone)
		iFrames = other.iFrames;
	
	if (!isAlone && (healthpoints < (healthpointsStart / 2))) {
		with (clone)
			entity_kill_self();
		
		isStalled = false;
		isAlone = true;
	}
};
onDeath = function(_damageSource) {
	cbkOnDeath_prtBoss(_damageSource);
	
	with (objGenericEnemyBullet) {
        if (owner == other.id)
            instance_destroy();
    }
	with (objGeminiManLaser)
		instance_destroy();
};