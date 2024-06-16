/// @description State Machine Init
// ================================
stateMachine.add("_StandardGround", {
	tick: function() {
		var _canJump = inputs.is_pressed(InputActions.JUMP),
			_downJumpSlide = options_data().downJumpSlide && yDir == gravDir;
		
		if (_canJump && !_downJumpSlide) {
			stateMachine.change("Jump");
			return;
		}
		
		if (xDir != 0)
			image_xscale = xDir;
	},
	posttick: function() {
		if (player_try_climbing()) {
			stateMachine.change("Climb");
			return;
		}
		
		if (player_try_sliding()) {
			stateMachine.change("Slide");
			return;
		}
		
		if (!ground)
			stateMachine.change("Fall");
	}
});
// --------------------------------
	stateMachine.add_child("_StandardGround", "Idle", {
		enter: function() {
			//animator.play("idle");
		},
		tick: function() {
			stateMachine.inherit();
			if (stateMachine.has_just_changed())
				return;
			
			xspeed.value = 0;
			
			if (xDir != 0)
				stateMachine.change(stepFrames > 0 ? "Sidestep" : "Walk");
		}
	});
// --------------------------------
	stateMachine.add_child("_StandardGround", "Sidestep", {
		enter: function() {
			move_and_collide_x(xDir);
			move_and_collide_y(gravDir);
			//animator.play("sidestep");
		},
		tick: function() {
			stateMachine.inherit();
			if (stateMachine.has_just_changed())
				return;
			
			if (xDir == 0) {
				stateMachine.change("Idle");
				return;
			}
			
			if (stateMachine.timer >= stepFrames)
				stateMachine.change("Walk");
		}
	});
// --------------------------------
	stateMachine.add_child("_StandardGround", "Walk", {
		enter: function() {
			//animator.play("walk");
		},
		tick: function() {
			stateMachine.inherit();
			if (stateMachine.has_just_changed())
				return;
			
			xspeed.value = walkSpeed * xDir;
			
			if (xDir == 0)
				stateMachine.change(brakeFrames > 0 ? "Brake" : "Idle");
		}
	});
// --------------------------------
	stateMachine.add_child("_StandardGround", "Brake", {
		enter: function() {
			xspeed.value = brakeSpeed * image_xscale;
			//animator.play("brake");
		},
		tick: function() {
			stateMachine.inherit();
			if (stateMachine.has_just_changed())
				return;
			
			if (xDir != 0) {
				stateMachine.change("Walk");
				return;
			}
			
			if (stateMachine.timer >= brakeFrames)
				stateMachine.change("Idle");
		}
	});
// ================================
stateMachine.add("_StandardAir", {
	enter: function() {
		ground = false;
		groundInstance = noone;
	},
	tick: function() {
		xspeed.value = airSpeed * xDir;
		
		if (xDir != 0)
			image_xscale = xDir;
	},
	posttick: function() {
		if (player_try_climbing()) {
			stateMachine.change("Climb");
			return;
		}
		
		if (ground) {
			stateMachine.change(xDir == 0 ? "Idle" : "Walk");
			play_sfx(sfxLand);
		}
	}
});
// --------------------------------
	stateMachine.add_child("_StandardAir", "Jump", {
		enter: function() {
			stateMachine.inherit();
			yspeed.value = jumpSpeed * -gravDir;
			//animator.play("jump");
			canMinJump = true;
		},
		tick: function() {
			stateMachine.inherit();
			if (stateMachine.has_just_changed())
				return;
			
			if (canMinJump && yspeed.value * gravDir < -minJumpThreshold && !inputs.is_held(InputActions.JUMP)) {
				yspeed.value = -minJumpCutoff;
				canMinJump = false;
			}
			
			if (yspeed.value * gravDir >= 0)
				stateMachine.change("Fall");
		}
	});
// --------------------------------
	stateMachine.add_child("_StandardAir", "Fall", {
		enter: function() {
			stateMachine.inherit();
			//animator.play("fall");
		}
	});