/// @description State Machine Init
// Base Boss States
// (All bosses will have these by default, but more can be added as needed for a given boss)
// - !!Intro_Start
// - !!Intro_Spawn_
//		- !!Intro_Spawn_DropIn
//		- !!Intro_Spawn_PopIn
// - !!Intro_Pose
// - !!Intro_FillHealth
// - !!Intro_End

// ================================
stateMachine.add("!!Intro_Start", {
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
			if (introSpawnType == "Custom") {
				assert(string_length(customIntroSpawnState) > 0, $"{object_get_name(object_index)} was set to have a custom intro spawn, but the spawn state was not specified");
				stateMachine.change(customIntroSpawnState);
			} else {
				stateMachine.change(string("!!Intro_Spawn_{0}", introSpawnType));
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
        isFinishedSpawn = false;
        visible = true;
        
        introLock.activate();
        introPauseLock.activate();
	},
	posttick: function() {
        if (isFinishedSpawn) {
			var _nextState = (string_length(customIntroPoseState) > 0)
				? customIntroPoseState
				: "!!Intro_Pose_Default";
            stateMachine.change(_nextState);
        }
	},
	leave: function() {
        y = ystart;
	}
});
// --------------------------------
	stateMachine.add_child("!!Intro_Spawn_", "!!Intro_Spawn_DropIn", {
		enter: function() {
			stateMachine.inherit();
			
			y = game_view().top_edge(-sprite_height / 2);
			animator.play("!!intro_spawn_dropin");
			collideWithSolids = false;
			gravEnabled = true;
			grav = DEFAULT_GRAVITY;
		},
		posttick: function() {
			isFinishedSpawn = (y >= ystart);
			stateMachine.inherit();
		},
	});
// --------------------------------
	stateMachine.add_child("!!Intro_Spawn_", "!!Intro_Spawn_PopIn", {
		posttick: function() {
			isFinishedSpawn = true;
			stateMachine.inherit();
		},
	});
// ================================
stateMachine.add("!!Intro_Pose_", {
    enter: function() {
		isIntro = true;
		isFinishedPose = false;
	},
	posttick: function() {
        if (isFinishedPose)
			stateMachine.change("!!Intro_FillHealth");
	},
});
// --------------------------------
	stateMachine.add_child("!!Intro_Pose_", "!!Intro_Pose_Default", {
		enter: function() {
			stateMachine.inherit();
			animator.play("!!intro_pose");
			gravEnabled = introCache.gravEnabled;
			grav = introCache.grav;
			collideWithSolids = introCache.collideWithSolids;
		},
		posttick: function() {
			isFinishedPose = animator.is_animation_finished() || (animator.loops > 0);
			stateMachine.inherit();
		},
	});
// ================================
stateMachine.add("!!Intro_FillHealth", {
    enter: function() {
        isIntro = true;
        isFillingHealthBar = true;
        
		hudElement = new BossHUD();
		hudElement.healthPalette[0][0] = $5800E4;
		hudElement.healthPalette[0][1] = $F8F8F8;
		array_push(objSystem.hud.bossHUD, hudElement);
	},
	tick: function() {
		if (hudElement.healthpoints >= healthpointsStart)
			stateMachine.change("!!Intro_End");
	},
	leave: function() {
        isFillingHealthBar = false;
	}
});
// ================================
stateMachine.add("!!Intro_End", {
	enter: function() {
		isIntro = false;
	},
	posttick: function() {
		assert(string_length(initialFightState) > 0, "initialFightState was not set for {0}", object_get_name(object_index));
        stateMachine.change(initialFightState);
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