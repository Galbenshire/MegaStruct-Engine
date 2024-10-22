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

// == Double Dribble (there's Gemini Men) ==

with (stateMachine.add("SpawnClone")) {
	set_event("tick", function() {
		clone = spawn_entity(x, y, depth, objGeminiClone);
		clone.image_xscale = image_xscale;
		clone.image_yscale = image_yscale;
		//clone.image_blend = c_green;
		clone.clone = self.id;
		clone.stateMachine.change_state("CloneDelay");
		
        stateMachine.change_state("DoubleTrouble_Jump");
	});
}
with (stateMachine.add("CloneDelay")) {
	set_event("enter", function() /*=>*/ {
		visible = true;
		animator.play("idle");
		
		isFighting = true;
        canTakeDamage = introCache.canTakeDamage;
        canDealDamage = introCache.canDealDamage;
        gravEnabled = introCache.gravEnabled;
        grav = introCache.grav;
        collideWithSolids = introCache.collideWithSolids;
        
        ground = true;
		entity_check_ground();
	});
	set_event("tick", function() {
        if (stateMachine.timer >= 60)
        	stateMachine.change_state("DoubleTrouble_Jump");
	});
}
with (stateMachine.add("DoubleTrouble_Jump")) {
	set_event("enter", function() {
        animator.play("jump");
        yspeed.value = -7;
        xspeed.value = calculate_arc_speed(x, y, jumpToX, y, yspeed.value, grav);
        ground = false;
        image_xscale = sign_nonzero(xspeed.value);
	});
	set_event("tick", function() {
		if (isAlone) {
			var _yspeed = yspeed.value;
			stateMachine.change_state("SoleSurvivor_Jump");
			yspeed.value = _yspeed;
		} else if (ground) {
			stateMachine.change_state("DoubleTrouble_Land");
		}
	});
}
with (stateMachine.add("DoubleTrouble_Land")) {
	set_event("enter", function() {
        animator.play("idle");
        xspeed.value = 0;
	});
	set_event("tick", function() {
		if (stateMachine.timer >= 5)
			stateMachine.change_state(isAlone ? "SoleSurvivor_Run" : "DoubleTrouble_Run");
	});
}
with (stateMachine.add("DoubleTrouble_Run")) {
	set_event("enter", function() {
        calibrate_direction_point(runToX);
		xspeed.value = 3 * image_xscale;
		animator.play("run");
        counterFlag = false;
	});
	set_event("tick", function() {
		if (isAlone) {
			stateMachine.change_state("SoleSurvivor_Run");
		} else if (counterFlag) {
			stateMachine.change_state("DoubleTrouble_Shoot");
			with (clone)
				isStalled = true;
		}
	});
	set_event("posttick", function() {
		if (isAlone)
			stateMachine.change_state("SoleSurvivor_Run");
		else if (sign(runToX - x) != image_xscale)
			stateMachine.change_state("DoubleTrouble_Jump");
	});
	set_event("leave", function() /*=>*/ { counterFlag = false; });
}
with (stateMachine.add("DoubleTrouble_Shoot")) {
	set_event("enter", function() {
        calibrate_direction_object(reticle.target);
		xspeed.value = 0;
		animator.play("shoot");
        shootFlag = false;
	});
	set_event("tick", function() {
		if (shootFlag) {
			self.create_projectile("bullet", 12, 2);
			shootFlag = false;
		}
		if (stateMachine.timer >= 15) {
			stateMachine.change_state(isAlone ? "SoleSurvivor_Run" : "DoubleTrouble_Run");
			with (clone)
				isStalled = false;
		}
	});
	set_event("leave", function() /*=>*/ { shootFlag = false; });
}

// == Sole Survivor (only one Gemini Man) ==

with (stateMachine.add("SoleSurvivor_Run")) {
	set_event("enter", function() {
        xspeed.value = 1.5 * image_xscale;
        animator.play("run");
        animator.set_time_scale(0.75);
        counterFlag = false;
	});
	set_event("tick", function() {
		if (laserCounter <= 0)
			stateMachine.change_state("SoleSurvivor_Shoot");
		else if (counterFlag)
			stateMachine.change_state("SoleSurvivor_Jump");
	});
	set_event("posttick", function() {
        if (xcoll != 0) {
			xspeed.value = -xcoll;
			image_xscale = sign(xspeed.value);
        } else if (check_for_solids(x + (8 * image_xscale), y)) {
			xspeed.value *= -1;
			image_xscale = sign(xspeed.value);
        }
        
        laserCounter -= !instance_exists(objGeminiManLaser);
	});
	set_event("leave", function() /*=>*/ { counterFlag = false; });
}
with (stateMachine.add("SoleSurvivor_Jump")) {
	set_event("enter", function() {
        xspeed.value = 1.5 * image_xscale;
        yspeed.value = -5;
        animator.play("jump");
	});
	set_event("tick", function() {
		if (ground)
			stateMachine.change_state("SoleSurvivor_Land");
	});
	set_event("posttick", function() {
		if (check_for_solids(x + (8 * image_xscale), y))
			image_xscale *= -1;
	});
}
with (stateMachine.add("SoleSurvivor_Land")) {
	set_event("enter", function() {
        xspeed.value = 0;
        animator.play("idle");
        counterFlag = false;
	});
	set_event("tick", function() {
		if (laserCounter <= 0)
			stateMachine.change_state("SoleSurvivor_Shoot");
		else if (counterFlag)
			stateMachine.change_state("SoleSurvivor_Jump");
		else if (stateMachine.timer >= 5)
			stateMachine.change_state("SoleSurvivor_Run");
	});
	set_event("posttick", function() /*=>*/ { laserCounter -= !instance_exists(objGeminiManLaser); });
	set_event("leave", function() /*=>*/ { counterFlag = false; });
}
with (stateMachine.add("SoleSurvivor_Shoot")) {
	set_event("enter", function() {
		xspeed.value = 0;
		animator.play("shoot");
        shootFlag = false;
        laserCounter = 120;
	});
	set_event("tick", function() {
		if (shootFlag) {
			self.create_projectile("laser", 12, 2);
			shootFlag = false;
		}
		if (stateMachine.timer >= 15)
			stateMachine.change_state("SoleSurvivor_Run");
	});
	set_event("leave", function() /*=>*/ { shootFlag = false; });
}