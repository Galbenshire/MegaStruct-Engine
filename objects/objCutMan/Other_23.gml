/// @description State Machine Init
event_inherited();

// === States ===
// - Run
// - Jump
// - CutterPose
// - ThrowCutter
// - Hurt

stateMachine.add_state("Run", {
	enter: function(_prevState) {
        animator.play("walk");
        xspeed = 1.125 * image_xscale;
	},
	tick: function(_substate, _timer) {
		animator.play(ground ? "walk" : "jump");
		
		if (!ground)
			return;
		
		if (reticle.distance_to_target_x() <= 48) {
			if (cutterExists || airThrowTimer > 0) {
				stateMachine.change_state("Jump");
				xspeed = calculate_horizontal_jump_speed(reticle.x - x, yspeed, grav);
			} else {
				stateMachine.change_state((random(1) < 0.375) ? "CutterPose" : "ThrowCutter");
				xspeed = 0;
			}
			return;
		}
		
		if (test_move_x(8 * image_xscale)) // Wall Ahead?
			stateMachine.change_state("Jump");
	}
});
stateMachine.add_state("Jump", {
	enter: function(_prevState) {
        animator.play("jump");
        yspeed = -6;
        moveSpeed = xspeed;
        canThrowInAir = !cutterExists && airThrowTimer > 0;
	},
	tick: function(_substate, _timer) /*=>*/ { xspeed = moveSpeed; },
	posttick: function(_substate, _timer) {
		if (canThrowInAir && yspeed >= 0)
			stateMachine.change_state("ThrowCutter");
		else if (ground)
			stateMachine.change_state("Run");
	}
});
stateMachine.add_state("CutterPose", {
	enter: function(_prevState) {
        animator.play("cutter-pose");
        xspeed = 0;
	},
	tick: function(_substate, _timer) {
		if (_timer >= 68) {
			stateMachine.change_state("ThrowCutter");
			animator.set_time_scale(2);
		}
	},
	leave: function(_newState) {
		if (_newState == "Hurt")
			cutterRetaliate = true;
	}
});
stateMachine.add_state("ThrowCutter", {
	enter: function(_prevState) {
        animator.play("cutter-throw");
	},
	tick: function(_substate, _timer) {
		xspeed *= !ground;
		
		if (_substate == 0) {
			if (shootFlag) {
				cutterInstance = self.perform_action("cutter");
				cutterExists = true;
				stateMachine.change_substate(1);
				airThrowTimer = 20;
				shootFlag = false;
			}
		} else if (_timer >= 18) {
			stateMachine.change_state("Run");
		}
	},
	leave: function(_newState) /*=>*/ { shootFlag = false; }
});
stateMachine.add_state("Hurt", {
	enter: function(_prevState) {
        animator.play("hurt");
        xspeed = image_xscale * -0.5;
		yspeed = -1.5 * gravDir;
	},
	tick: function(_substate, _timer) {
		if (_timer >= 30) {
			if (instance_exists(cutterInstance)) {
				stateMachine.change_state("Run");
			} else {
				stateMachine.change_state(cutterRetaliate || (random(1) < 0.33) ? "ThrowCutter" : "CutterPose");
			}
		}
	},
	leave: function(_newState) /*=>*/ { cutterRetaliate = false; }
});