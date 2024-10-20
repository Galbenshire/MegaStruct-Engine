/// @description State Machine Init
// Base Boss States
// (All bosses will have these by default, but more can be added as needed for a given boss)
// - !!Inactive
// - !!StartFight

// ================================
stateMachine.add("!!Inactive", {
	enter: function() {
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
	},
	tick: function() {
		if (instance_all(prtPlayer, function(el, i) /*=>*/ {return !el.isIntro})) {
			if (introType == "Custom") {
				assert(!string_empty(customIntroState), $"{object_get_name(object_index)} was set to have a custom intro spawn, but the state was not specified");
				stateMachine.change(customIntroState);
			} else {
				stateMachine.change($"!!Intro_Spawn_{introType}");
			}
		}
	},
	posttick: function() {
        // ...
	},
	leave: function() {
        isInactive = false;
	}
});
// ================================
stateMachine.add("!!Intro_Spawn_", {
	enter: function() {
        isIntro = true;
        isFinishedIntro = false;
        visible = true;
        
        if (lockControlsDuringIntro) {
			introLock.activate();
			introPauseLock.activate();
        } else if (showHealthbar) {
			array_push(objSystem.hud.bossHUD, hudElement);
        }
	},
	posttick: function() {
		if (isFinishedIntro)
			stateMachine.change("!!StartFight");
	},
	leave: function() {
        isIntro = false;
	}
});
// --------------------------------
	stateMachine.add_child("!!Intro_Spawn_", "!!Intro_Spawn_DropIn", {
		enter: function() {
			self.require_animation("!!dropin");
			stateMachine.inherit();
			
			y = game_view().top_edge(-sprite_height / 2);
			collideWithSolids = false;
			gravEnabled = true;
			grav = DEFAULT_GRAVITY;
			animator.play("!!dropin");
		},
		posttick: function() {
			//isFinishedIntro = (y >= ystart);
			
			if (y >= ystart)
				isFinishedIntro = true;
			stateMachine.inherit();
		},
		leave: function() {
			stateMachine.inherit();
			
			y = ystart;
			yspeed.clear_all();
			gravEnabled = false;
		}
	});
// --------------------------------
	stateMachine.add_child("!!Intro_Spawn_", "!!Intro_Spawn_PopIn", {
		enter: function() {
			stateMachine.inherit();
			isFinishedIntro = true;
		}
	});
// --------------------------------
	stateMachine.add_child("!!Intro_Spawn_", "!!Intro_Spawn_TeleportIn", {
		enter: function() {
			stateMachine.inherit();
			
			y = game_view().top_edge(-sprite_height / 2);
			yspeed.value = 8;
			animator.play("!!teleport-idle");
			collideWithSolids = false;
			isTeleporting = true;
		},
		posttick: function() {
			if (stateMachine.substate == 0) {
				if (y >= ystart) {
					y = ystart;
					yspeed.clear_all();
					stateMachine.change_substate(1);
					animator.play("!!teleport-in");
				}
			} else if (animator.is_animation_finished()) {
				isFinishedIntro = true;
			}
			
			stateMachine.inherit();
		},
		leave: function() {
			stateMachine.inherit();
			
			y = ystart;
			yspeed.clear_all();
			isTeleporting = false;
		}
	});
// ================================
stateMachine.add("!!StartFight", {
	enter: function() {
		print("fight can start", WarningLevel.SHOW);
		isFillingHealthBar = (showHealthbar && lockControlsDuringIntro);
		isReady = !isFillingHealthBar;
	},
	posttick: function() {
		isReady = !isFillingHealthBar;
		
		if (isReady) {
			assert(!string_empty(initialFightState), $"{nameof(initialFightState)} was not set for {object_get_name(object_index)}");
			stateMachine.change(initialFightState);
		}
	},
	leave: function() {
		isFighting = true;
        canTakeDamage = introCache.canTakeDamage;
        canDealDamage = introCache.canDealDamage;
        gravEnabled = introCache.gravEnabled;
        grav = introCache.grav;
        collideWithSolids = introCache.collideWithSolids;
        
        introLock.deactivate();
        introPauseLock.deactivate();
	}
});
