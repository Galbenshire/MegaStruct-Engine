/// @description State Machine Init
// Base Boss States
// (All bosses will have these by default, but more can be added as needed for a given boss)
// - !!Inactive
// - !!Intro_Spawn_DropIn
// - !!Intro_Spawn_PopIn
// - !!Intro_Spawn_TeleportIn
// - !!Intro_Pose
// - !!FinishIntro

with (stateMachine.add("!!Inactive")) {
	set_event("enter", function() {
		introCache = {
            canTakeDamage: canTakeDamage,
            canDealDamage: canDealDamage,
            gravEnabled: gravEnabled,
            grav: grav,
            collideWithSolids: collideWithSolids
        };
        
		isInactive = true;
		canTakeDamage = false;
		canDealDamage = false;
		gravEnabled = false;
		collideWithSolids = false;
		visible = false;	
	});
	set_event("tick", function() {
		if (instance_all(prtPlayer, function(el, i) /*=>*/ {return !el.isIntro})) {
			if (introType == "Custom") {
				assert(!string_empty(customIntroState), $"{object_get_name(object_index)} was set to have a custom intro spawn, but the state was not specified");
				stateMachine.change_state(customIntroState);
			} else {
				stateMachine.change_state($"!!Intro_Spawn_{introType}");
			}
		}
	});
	set_event("leave", function() /*=>*/ { isInactive = false; });
}
with (stateMachine.add("!!Intro_Spawn_DropIn")) {
	set_event("enter", function() {
		self.require_animation("!!dropin");
		if (lockControlsDuringIntro)
			self.require_animation("!!dropin-end");
		
		self.common_state_intro_spawn("enter");
		
		y = game_view().top_edge(-sprite_height / 2);
		collideWithSolids = false;
		gravEnabled = true;
		grav = DEFAULT_GRAVITY;
		animator.play("!!dropin");
	});
	set_event("posttick", function() {
		if (y >= ystart)
			self.common_state_intro_spawn("posttick");
	});
	set_event("leave", function() {
		self.common_state_intro_spawn("leave");
		
		y = ystart;
		yspeed.clear_all();
		gravEnabled = false;
		
		if (lockControlsDuringIntro)
			animator.play("!!dropin-end");
	});
}
with (stateMachine.add("!!Intro_Spawn_PopIn")) {
	set_event("enter", function() /*=>*/ { self.common_state_intro_spawn("enter"); });
	set_event("posttick", function() /*=>*/ { self.common_state_intro_spawn("posttick"); });
	set_event("leave", function() /*=>*/ { self.common_state_intro_spawn("leave"); });
}
with (stateMachine.add("!!Intro_Spawn_TeleportIn")) {
	set_event("enter", function() {
		self.common_state_intro_spawn("enter");
		
		y = game_view().top_edge(-sprite_height / 2);
		yspeed.value = 8;
		animator.play("!!teleport-idle");
		collideWithSolids = false;
		isTeleporting = true;
	});
	set_event("posttick", function() {
		if (stateMachine.substate == 0) {
			if (y >= ystart) {
				y = ystart;
				yspeed.clear_all();
				stateMachine.change_substate(1);
				animator.play("!!teleport-in");
			}
		} else if (animator.is_animation_finished()) {
			self.common_state_intro_spawn("posttick");
		}
	});
	set_event("leave", function() {
		self.common_state_intro_spawn("leave");
		
		y = ystart;
		yspeed.clear_all();
		isTeleporting = false;
	});
}
with (stateMachine.add("!!Intro_Pose")) {
	set_event("enter", function() {
		self.require_animation("!!pose");
		isIntro = true;
		animator.play("!!pose");
	});
	set_event("posttick", function() {
		if (animator.is_animation_finished() || (animator.loops > 0))
			stateMachine.change_state("!!FinishIntro");
	});
	set_event("leave", function() {
		isIntro = false;
	});
}
with (stateMachine.add("!!FinishIntro")) {
	set_event("enter", function() {
		isReady = false;
	});
	set_event("posttick", function() {
		switch (stateMachine.substate) {
			case 0: // Delay before showing healthbar
				if (stateMachine.timer >= healthbarFillDelay) {
					if (showHealthbar) {
						array_push(objSystem.hud.bossHUD, hudElement);
						hudElement.healthpoints *= !lockControlsDuringIntro;
						isFillingHealthBar = true;
					}
					stateMachine.change_substate(1 + !showHealthbar);
				}
				break;
			
			case 1: // Wait for the healtbar to refill fully
				if (!isFillingHealthBar)
					stateMachine.change_substate(2);
				break;
			
			case 2: // Ready to fight
				isReady = true;
				
				if (isReady) {
					assert(!string_empty(initialFightState), $"{nameof(initialFightState)} was not set for {object_get_name(object_index)}");
					stateMachine.change_state(initialFightState);
				}
				break;
		}
	});
	set_event("leave", function() {
		isFighting = true;
        canTakeDamage = introCache.canTakeDamage;
        canDealDamage = introCache.canDealDamage;
        gravEnabled = introCache.gravEnabled;
        grav = introCache.grav;
        collideWithSolids = introCache.collideWithSolids;
        
        introLock.deactivate();
        introPauseLock.deactivate();
		
		ground = true;
		entity_check_ground();
	});
}

stateMachine.change_state("!!Inactive");