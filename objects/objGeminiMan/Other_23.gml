/// @description State Machine Init
event_inherited();

// === States ===
// - SpawnClone
// - CloneDelay
// - DoubleTrouble_Jump
// - DoubleTrouble_Land
// - DoubleTrouble_Run
// - DoubleTrouble_Shoot
// - DoubleTrouble_Stall
// - SoleSurvivor_Run
// - SoleSurvivor_Jump
// - SoleSurvivor_Shoot
// - SoleSurvivor_Land

#region Double Dribble (there's Gemini Men)

stateMachine.add_state("SpawnClone", {
	tick: function(_substate, _timer) {
		clone = spawn_entity(x, y, depth, objGeminiClone);
		clone.image_xscale = image_xscale;
		clone.image_yscale = image_yscale;
		//clone.image_blend = c_green;
		clone.clone = self.id;
		clone.stateMachine.change_state("CloneDelay");
		
        stateMachine.change_state("DoubleTrouble_Jump");
	},
});
stateMachine.add_state("CloneDelay", {
	enter: function(_prevState) {
        visible = true;
		animator.play("idle");
		
		isFighting = true;
        hitmaskMaster = introCache.hitmaskMaster;
        gravEnabled = introCache.gravEnabled;
        grav = introCache.grav;
        collideWithSolids = introCache.collideWithSolids;
        
        ground = true;
		entity_check_ground();
	},
	tick: function(_substate, _timer) {
		if (_timer >= 60)
			stateMachine.change_state("DoubleTrouble_Jump");
	}
});
stateMachine.add_state("DoubleTrouble_Jump", {
	enter: function(_prevState) {
		animator.play("jump");
        yspeed.value = -7;
        xspeed.value = calculate_arc_speed(x, y, jumpToX, y, yspeed.value, grav);
        ground = false;
        image_xscale = sign_nonzero(xspeed.value);
	},
	tick: function(_substate, _timer) {
		if (isAlone) {
			var _yspeed = yspeed.value;
			stateMachine.change_state("SoleSurvivor_Jump");
			yspeed.value = _yspeed;
		} else if (ground) {
			stateMachine.change_state("DoubleTrouble_Land");
		}
	}
});
stateMachine.add_state("DoubleTrouble_Land", {
	enter: function(_prevState) {
		animator.play("idle");
        xspeed.value = 0;
	},
	tick: function(_substate, _timer) {
		if (_timer >= 5)
			stateMachine.change_state(isAlone ? "SoleSurvivor_Run" : "DoubleTrouble_Run");
	}
});
stateMachine.add_state("DoubleTrouble_Run", {
	enter: function(_prevState) {
		calibrate_direction_point(runToX);
		xspeed.value = 3 * image_xscale;
		animator.play("run");
        counterFlag = false;
	},
	tick: function(_substate, _timer) {
		if (isAlone)
			stateMachine.change_state("SoleSurvivor_Run");
		else if (counterFlag)
			stateMachine.change_state("DoubleTrouble_Shoot");
	},
	posttick: function(_substate, _timer) {
		if (sign(runToX - x) != image_xscale)
			stateMachine.change_state("DoubleTrouble_Jump");
	},
	leave: function(_newState) /*=>*/ { counterFlag = false; }
});
stateMachine.add_state("DoubleTrouble_Shoot", {
	enter: function(_prevState) {
		calibrate_direction_object(reticle.target);
		xspeed.value = 0;
		animator.play("shoot");
        shootFlag = false;
        
        with (clone)
			isStalled = true;
	},
	tick: function(_substate, _timer) {
		if (shootFlag) {
			self.create_projectile("bullet", 12, 2);
			shootFlag = false;
		}
		if (_timer >= 15)
			stateMachine.change_state(isAlone ? "SoleSurvivor_Run" : "DoubleTrouble_Run");
	},
	leave: function(_newState) {
		shootFlag = false;
		with (clone)
			isStalled = false;
	}
});

#endregion

#region Sole Survivor (only one Gemini Man)

stateMachine.add_state("SoleSurvivor_Run", {
	enter: function(_prevState) {
		xspeed.value = 1.5 * image_xscale;
        animator.play("run");
        animator.set_time_scale(0.75);
        counterFlag = false;
	},
	tick: function(_substate, _timer) {
		if (laserCounter <= 0)
			stateMachine.change_state("SoleSurvivor_Shoot");
		else if (counterFlag)
			stateMachine.change_state("SoleSurvivor_Jump");
	},
	posttick: function(_substate, _timer) {
		if (xcoll != 0) {
			xspeed.value = -xcoll;
			image_xscale = sign(xspeed.value);
        } else if (check_for_solids(x + (8 * image_xscale), y)) {
			xspeed.value *= -1;
			image_xscale = sign(xspeed.value);
        }
        
        laserCounter -= !instance_exists(objGeminiManLaser);
	},
	leave: function(_newState) /*=>*/ { counterFlag = false; }
});
stateMachine.add_state("SoleSurvivor_Jump", {
	enter: function(_prevState) {
		xspeed.value = 1.5 * image_xscale;
        yspeed.value = -5;
        animator.play("jump");
	},
	tick: function(_substate, _timer) {
		if (ground)
			stateMachine.change_state("SoleSurvivor_Land");
	},
	posttick: function(_substate, _timer) {
		if (check_for_solids(x + (8 * image_xscale), y))
			image_xscale *= -1;
	}
});
stateMachine.add_state("SoleSurvivor_Land", {
	enter: function(_prevState) {
		xspeed.value = 0;
        animator.play("idle");
        counterFlag = false;
	},
	tick: function(_substate, _timer) {
		if (laserCounter <= 0)
			stateMachine.change_state("SoleSurvivor_Shoot");
		else if (counterFlag)
			stateMachine.change_state("SoleSurvivor_Jump");
		else if (_timer >= 5)
			stateMachine.change_state("SoleSurvivor_Run");
	},
	posttick: function(_substate, _timer) /*=>*/ { laserCounter -= !instance_exists(objGeminiManLaser); },
	leave: function(_newState) /*=>*/ { counterFlag = false; }
});
stateMachine.add_state("SoleSurvivor_Shoot", {
	enter: function(_prevState) {
		xspeed.value = 0;
		animator.play("shoot");
        shootFlag = false;
        laserCounter = 120;
	},
	tick: function(_substate, _timer) {
		if (shootFlag) {
			self.create_projectile("laser", 12, 2);
			shootFlag = false;
		}
		if (_timer >= 15)
			stateMachine.change_state("SoleSurvivor_Run");
	},
	leave: function(_newState) /*=>*/ { shootFlag = false; }
});

#endregion