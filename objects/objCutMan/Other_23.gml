/// @description State Machine Init
event_inherited();

// === States ===
// - Run
// - Jump
// - CutterPose
// - ThrowCutter
// - Hurt

// ================================
stateMachine.add("Run", {
	enter: function() {
        animator.play("walk");
        xspeed.value = 1.125 * image_xscale;
	},
	tick: function() {
		animator.play(ground ? "walk" : "jump");
		
		if (!ground)
			return;
		
		if (reticle.distance_to_target_x() <= 48) {
			if (cutterExists || airThrowTimer > 0) {
				stateMachine.change("Jump");
				xspeed.value = calculate_horizontal_jump_speed(reticle.x - x, yspeed.value, grav);
			} else {
				stateMachine.change((random(1) < 0.375) ? "CutterPose" : "ThrowCutter");
				xspeed.value = 0;
			}
			return;
		}
		
		if (test_move_x(8 * image_xscale)) // Wall Ahead?
			stateMachine.change("Jump");
	},
});
// ================================
stateMachine.add("Jump", {
	enter: function() {
        animator.play("jump");
        yspeed.value = -6;
        moveSpeed = xspeed.value;
        canThrowInAir = !cutterExists && airThrowTimer > 0;
	},
	tick: function() {
		xspeed.value = moveSpeed;
	},
	posttick: function() {
		if (canThrowInAir && yspeed.value >= 0)
			stateMachine.change("ThrowCutter");
		
		if (ground)
			stateMachine.change("Run");
	},
});
// ================================
stateMachine.add("CutterPose", {
	enter: function() {
        animator.play("cutter_pose");
        xspeed.value = 0;
	},
	tick: function() {
		if (stateMachine.timer >= 68) {
			stateMachine.change("ThrowCutter");
			animator.set_time_scale(2);
		}
	}
});
// ================================
stateMachine.add("ThrowCutter", {
	enter: function() {
        animator.play("cutter_throw");
	},
	tick: function() {
		xspeed.value *= !ground;
		
		if (stateMachine.substate == 0) {
			if (shootFlag) {
				cutterInstance = spawn_entity(x, y, depth, objCutManCutter);
				cutterInstance.xspeed.value = 3 * image_xscale;
				cutterInstance.owner = self;
				set_velocity_vector(3, point_direction(x, y, reticle.x, reticle.y), cutterInstance);
				cutterExists = true;
				
				stateMachine.substate++;
				stateMachine.timer = 0;
				airThrowTimer = 20;
				shootFlag = false;
			}
		} else if (stateMachine.timer >= 18) {
			stateMachine.change("Run");
		}
	},
	leave: function() {
		shootFlag = false;
	}
});

// ================================
stateMachine.add("Hurt", {
	enter: function() {
        animator.play("hurt");
        xspeed.value = image_xscale * -0.5;
		yspeed.value = -1.5 * gravDir;
	},
	tick: function() {
		if (stateMachine.timer >= 30) {
			if (instance_exists(cutterInstance)) {
				stateMachine.change("Run");
			} else {
				var _wasPosing = stateMachine.is_previous_state("CutterPose");
				stateMachine.change(_wasPosing || (random(1) < 0.33) ? "ThrowCutter" : "CutterPose");
			}
		}
	}
});