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
            hitmaskMaster,
            gravEnabled,
            grav,
            collideWithSolids
        };
        
		isInactive = true;
		hitmaskMaster = 0;
		gravEnabled = false;
		collideWithSolids = false;
		visible = false;	
	},
	posttick: function(_substate, _timer) {
		// Wait until all user-controlled players are not doing their intros
		var _anyPlayersNotReady = instance_any(prtPlayer, function(el, i) /*=>*/ {return !player_is_active(el) && player_is_user_controlled(el)});
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
			global.player.inputAccessLevel = PlayerInputLevel.CHARGE;
			player_halt(global.player.body, true);
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
		hitmaskMaster = introCache.hitmaskMaster;
        gravEnabled = introCache.gravEnabled;
        grav = introCache.grav;
        collideWithSolids = introCache.collideWithSolids;
        
        introLock.deactivate();
        introPauseLock.deactivate();
        global.player.inputAccessLevel = PlayerInputLevel.MAIN;
		
		ground = true;
		entity_check_ground(1);
		
		signal_bus().emit_signal(SIGNAL_BOSS_FIGHTSTART, {});
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
				teleportRef = instance_create_depth(x, y, depth, objTeleportInEffect, {
					sprite_index: sprHotDogTeleport,
					image_xscale,
					image_yscale,
					colourPrimary: healthColourPrimary,
					colourSecondary: healthColourSecondary,
					teleportSFX
				});
				teleportRef.target = self.id;
				visible = false;
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
				if (!instance_exists(teleportRef))
					stateMachine.pop_state();
				break;
			case "PopIn": stateMachine.pop_state(); break;
		}
	},
	leave: function(_newState) {
		y = ystart;
		visible = true;
		yspeed = 0;
		gravEnabled = false;
		
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