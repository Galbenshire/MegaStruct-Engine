/// @description State Machine Init
// ==== Base Boss States ====
// (All bosses will have these by default, but more can be added as needed for a given boss)
// - !!Inactive
// - !!Intro
// - !!Intro_Spawn
// - !!Intro_Pose
// - !!Intro_FillHealthbar
// - !!Intro_WaitForOthers


#region Main States

stateMachine.add_state("!!Inactive", {
	enter: function(_prevState) {
		introCache = {
            canTakeDamage,
            canDealDamage,
            gravEnabled,
            grav,
            collideWithSolids
        };
        
		isInactive = true;
		canTakeDamage = false;
		canDealDamage = false;
		gravEnabled = false;
		collideWithSolids = false;
		visible = false;	
	},
	posttick: function(_substate, _timer) {
		// Wait until all user-controlled players are not doing their intros
		var _anyPlayersNotReady = instance_any(prtPlayer, function(el, i) /*=>*/ {return el.isIntro && el.is_user_controlled()});
		if (!_anyPlayersNotReady)
			stateMachine.change_state("!!Intro");
	},
	leave: function(_newState) /*=>*/ { isInactive = false; }
});
stateMachine.add_state("!!Intro", {
	enter: function(_prevState) {
		isIntro = true;
		visible = true;
		
		if (lockControlsDuringIntro) {
			introLock.activate();
			introPauseLock.activate();
		}
		
		if (playBossMusic) {
			preFightMusicCache = music_snapshot();
			play_music(bossMusicID);
		}
		
		array_foreach(self.get_intro_sequence(), function(_state, i) /*=>*/ { stateMachine.push_state(_state); });
	},
	posttick: function(_substate, _timer) {
		assert(!string_empty(initialFightState), $"{nameof(initialFightState)} was not set for {object_get_name(object_index)}");
		stateMachine.change_state(initialFightState);
	},
	leave: function(_newState) {
		isIntro = false;
		isFighting = true;
		isReady = true;
		canTakeDamage = introCache.canTakeDamage;
		canDealDamage = introCache.canDealDamage;
        gravEnabled = introCache.gravEnabled;
        grav = introCache.grav;
        collideWithSolids = introCache.collideWithSolids;
        
        introLock.deactivate();
        introPauseLock.deactivate();
		
		ground = true;
		entity_check_ground();
	}
});

#endregion

#region Intro Component States

stateMachine.add_state("!!Intro_Spawn", {
	enter: function(_prevState) {
		switch (introType) {
			case "DropIn":
				y = game_view().top_edge(-sprite_height / 2);
				collideWithSolids = false;
				gravEnabled = true;
				grav = DEFAULT_GRAVITY;
				animator.play("!!dropin");
				break;
			case "TeleportIn":
				y = game_view().top_edge(-sprite_height / 2);
				yspeed.value = 8;
				animator.play("!!teleport-idle");
				collideWithSolids = false;
				isTeleporting = true;
				break;
			case "PopIn": break;
		}
	},
	posttick: function(_substate, _timer) {
		switch (introType) {
			case "DropIn":
				if (y >= ystart)
					stateMachine.pop_state();
				break;
			case "TeleportIn":
				if (stateMachine.substate == 0) {
					if (y >= ystart) {
						y = ystart;
						yspeed.clear_all();
						stateMachine.change_substate(1);
						animator.play("!!teleport-in");
					}
				} else if (animator.is_animation_finished()) {
					stateMachine.pop_state();
				}
				break;
			case "PopIn": stateMachine.pop_state(); break;
		}
	},
	leave: function(_newState) {
		y = ystart;
		visible = true;
		yspeed.clear_all();
		gravEnabled = false;
		isTeleporting = false;
		
		if (introType == "DropIn")
			animator.play("!!dropin-end");
	}
});
stateMachine.add_state("!!Intro_Pose", {
	enter: function(_prevState) /*=>*/ { animator.play("!!pose"); },
	resume: function(_prevState) /*=>*/ { animator.play("!!pose"); },
	tick: function(_substate, _timer) {
		if (animator.is_animation_finished(true))
			stateMachine.pop_state();
	}
});
stateMachine.add_state("!!Intro_FillHealthbar", {
	enter: function(_prevState) /*=>*/ { isFillingHealthBar = false; },
	tick: function(_substate, _timer) {
		if (_substate == 0) { // Delay before showing healthbar
			if (_timer >= healthbarFillDelay) {
				self.connect_hud();
				hudElement.healthpoints *= !lockControlsDuringIntro;
				isFillingHealthBar = true;
				stateMachine.set_substate(1);
			}
		} else if (!isFillingHealthBar) { // Wait for the healtbar to refill fully
			stateMachine.pop_state();
		}
	},
	leave: function(_newState) /*=>*/ { isFillingHealthBar = false; },
});
stateMachine.add_state("!!Intro_WaitForOthers", {
	tick: function(_substate, _timer) {
		isReady = true;
		if (instance_all(prtBoss, function(el, i) /*=>*/ {return el.isReady}))
			stateMachine.pop_state();
	}
});

#endregion