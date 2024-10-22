event_inherited();

// required prtBoss variables, so the clone doesn't crash the game
stateMachine = new EntityState();
animator = new FrameAnimationPlayer();
introCache = {};
isInactive = true;
isFillingHealthBar = false;
isTeleporting = false;
hitsparkEffect = true;

event_perform_object(objGeminiMan, ev_other, ev_user0); // Common Data
event_perform_object(objGeminiMan, ev_other, ev_user11); // Method Init
event_perform_object(objGeminiMan, ev_other, ev_user12); // Animation Init
event_perform_object(objGeminiMan, ev_other, ev_user13); // State Machine Init

// Callback Overrides
onHurt = function(_damageSource) {
    healthpoints = healthpointsStart;
    
    with (clone) {
        healthpoints -= _damageSource.damage * !_damageSource.has_flag(DamageFlags.MOCK_DAMAGE);
		onHurt(_damageSource);
    }
};