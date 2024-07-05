/// @description Spike-Entity Collision
with (target) {
	if (!canTakeDamage || iFrames != 0 || entity_is_dead())
        exit;
    
    var _spikeHit = (xcollInstance == other.id)
        || (ycoll * gravDir < 0 && ycollInstance == other.id)
        || (ground && groundInstance == other.id && in_range(bbox_x_center(), other.bbox_left, other.bbox_right));
    
    if (!_spikeHit)
        exit;
    
    var _damageSource = new DamageSource(other, self, other.contactDamage);
		
	healthpoints -= _damageSource.damage;
	onHurt(_damageSource);
	hitTimer = 0;
		
	if (healthpoints <= 0) {
		_damageSource.hasKilled = true;
		onDeath(_damageSource);
	}
	
	delete _damageSource;
}
