/// @description State Machine Init
event_inherited();

// === States ===
// - Run
// - Jump
// - CutterPose
// - ThrowCutter
// - Hurt

with (stateMachine.add("Run")) {
	set_event("enter", function() {
        animator.play("walk");
        xspeed.value = 1.125 * image_xscale;
	});
	set_event("tick", function() {
		animator.play(ground ? "walk" : "jump");
		
		if (!ground)
			return;
		
		if (reticle.distance_to_target_x() <= 48) {
			if (cutterExists || airThrowTimer > 0) {
				stateMachine.change_state("Jump");
				xspeed.value = calculate_horizontal_jump_speed(reticle.x - x, yspeed.value, grav);
			} else {
				stateMachine.change_state((random(1) < 0.375) ? "CutterPose" : "ThrowCutter");
				xspeed.value = 0;
			}
			return;
		}
		
		if (test_move_x(8 * image_xscale)) // Wall Ahead?
			stateMachine.change_state("Jump");
	});
}
with (stateMachine.add("Jump")) {
	set_event("enter", function() {
        animator.play("jump");
        yspeed.value = -6;
        moveSpeed = xspeed.value;
        canThrowInAir = !cutterExists && airThrowTimer > 0;
	});
	set_event("tick", function() {
		xspeed.value = moveSpeed;
	});
	set_event("posttick", function() {
		if (canThrowInAir && yspeed.value >= 0)
			stateMachine.change_state("ThrowCutter");
		
		if (ground)
			stateMachine.change_state("Run");
	});
}
// ================================
with (stateMachine.add("CutterPose")) {
	set_event("enter", function() {
        animator.play("cutter-pose");
        xspeed.value = 0;
	});
	set_event("tick", function() {
		if (stateMachine.timer >= 68) {
			stateMachine.change_state("ThrowCutter");
			animator.set_time_scale(2);
		}
	});
}
// ================================
with (stateMachine.add("ThrowCutter")) {
	set_event("enter", function() {
        animator.play("cutter-throw");
	});
	set_event("tick", function() {
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
			stateMachine.change_state("Run");
		}
	});
	set_event("leave", function() {
		shootFlag = false;
	});
}
with (stateMachine.add("Hurt")) {
	set_event("enter", function() {
        animator.play("hurt");
        xspeed.value = image_xscale * -0.5;
		yspeed.value = -1.5 * gravDir;
	});
	set_event("tick", function() {
		if (stateMachine.timer >= 30) {
			if (instance_exists(cutterInstance)) {
				stateMachine.change_state("Run");
			} else {
				var _wasPosing = stateMachine.get_previous_state() == "CutterPose";
				stateMachine.change_state(_wasPosing || (random(1) < 0.33) ? "ThrowCutter" : "CutterPose");
			}
		}
	});
}