/// @description Spike-Entity Collision
with (target) {
	if (!entity_can_take_damage())
        exit;
    
    var _spikeHit = (xcollInstance == other.id)
        || (ycoll * gravDir < 0 && ycollInstance == other.id)
        || (ground && groundInstance == other.id && in_range(bbox_x_center(), other.bbox_left, other.bbox_right));
    if (_spikeHit) {
		var _damageSource = new DamageSource(other.id, self.id, other.contactDamage);
		_damageSource.apply_damage();
		delete _damageSource;
    }
}
