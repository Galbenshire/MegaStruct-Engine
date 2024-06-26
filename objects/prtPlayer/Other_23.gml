/// @description State Machine Init
// ================================
stateMachine.add("_StandardGround", {
	tick: function() {
		var _canJump = inputs.is_pressed(InputActions.JUMP) || (jumpBufferTimer > 0 && inputs.is_held(InputActions.JUMP)),
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
		
		if (!ground) {
			stateMachine.change("Fall");
			coyoteTimer = COYOTE_FALL_BUFFER;
		}
	}
});
// --------------------------------
	stateMachine.add_child("_StandardGround", "Idle", {
		enter: function() {
			animator.play("idle");
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
			animator.play("sidestep");
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
			animator.play("walk");
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
			animator.play("brake");
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
			animator.play("jump");
			canMinJump = true;
			coyoteTimer = 0;
			jumpBufferTimer = 0;
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
			animator.play("fall");
		},
		tick: function() {
			stateMachine.inherit();
			if (stateMachine.has_just_changed())
				return;
			
			if (coyoteTimer > 0 && inputs.is_pressed(InputActions.JUMP))
				stateMachine.change("Jump");
		}
	});
// ================================
stateMachine.add("Slide", {
	enter: function() {
		isSliding = true;
		
		xspeed.value = slideSpeed * image_xscale;
		yspeed.clear_all();
		animator.play("slide");
		
		mask_index = maskSlide;
		
		// with (instance_create_depth(bbox_horizontal(-image_xscale), bbox_vertical(image_yscale) - 4 * image_yscale, depth, objSlideDust))
		// 	image_xscale = -other.image_xscale;
	},
	posttick: function() {
		if (player_try_climbing()) {
			stateMachine.change("Climb");
			return;
		}
		
		if (!ground) {
			mask_index = maskSlideExtended;
			ground = true;
			entity_check_ground();
			mask_index = maskSlide;
			
			if (ground)
				yspeed.clear_all();
		}
		
		var _freeSpaceAbove = !test_move_y(-slideMaskHeightDelta * gravDir),
			_jumpInput = inputs.is_pressed(InputActions.JUMP),
			_downJumpSlide = yDir == gravDir && options_data().downJumpSlide;
		if (ground && _freeSpaceAbove && _jumpInput && !_downJumpSlide) {
			stateMachine.change("Jump");
			return;
		}
		
		var _freeSpaceBelow = !ground && !test_move_y(slideMaskHeightDelta * gravDir);
		if (!ground) {
			move_and_collide_y(slideMaskHeightDelta * gravDir * (!_freeSpaceAbove && _freeSpaceBelow));
			stateMachine.change("Fall");
			return;
		}
		
		if (xDir == -image_xscale) {
			if (_freeSpaceAbove) {
				stateMachine.change("Idle");
				return;
			}
			
			image_xscale = xDir;
			xspeed.value = slideSpeed * image_xscale;
		}
		
		var _shouldEnd = xcoll != 0 || stateMachine.timer >= slideFrames;
		if (_shouldEnd && (_freeSpaceAbove || _freeSpaceBelow)) {
			move_and_collide_y(slideMaskHeightDelta * gravDir * (!_freeSpaceAbove && _freeSpaceBelow));
			stateMachine.change(xDir == image_xscale ? "Walk" : "Idle");
		}
	},
	leave: function() {
		isSliding = false;
		mask_index = maskNormal;
	}
});
// ================================
stateMachine.add("Climb", {
	enter: function() {
		x = bbox_x_center(ladderInstance);
		y = clamp(y, ladderInstance.bbox_top - 8 * (gravDir > 0), ladderInstance.bbox_bottom + 8 * (gravDir < 0));
		
		xspeed.clear_all();
		yspeed.clear_all();
		animator.play("climb");
		
		ground = false;
		groundInstance = noone;
		gravEnabled = false;
		isClimbing = true;
	},
	tick: function() {
		yspeed.value = climbSpeed * yDir * !isShooting;
		animator.set_time_scale(abs(yspeed.value) != 0);
		
		if (animator.timeScale.value == 0)
			animator.reset_frame_counter();
		
		if (yDir != -gravDir && inputs.is_pressed(InputActions.JUMP))
			stateMachine.change("Fall");
	},
	posttick: function() {
		// Hitting ground while climbing down
		if (sign(ycoll) == gravDir) {
			stateMachine.change("Idle", function() {
				stateMachine.run_current_event_function();
				ground = true;
				groundInstance = ycollInstance;
			});
			return;
		}
		
		// Reached the bottom of the ladder?
		var _reachedBottom = (gravDir >= 0) ? y > ladderInstance.bbox_bottom : y < ladderInstance.bbox_top;
		if (_reachedBottom) {
			stateMachine.change("Fall");
			return;
		}
		
		// Reached the top of the ladder?
		var _reachedTop = (gravDir >= 0) ? y < ladderInstance.bbox_top - 10 : y > ladderInstance.bbox_bottom + 10;
		if (_reachedTop) {
			var _shift = bbox_vertical(-gravDir, ladderInstance) - bbox_vertical(gravDir);
			move_and_collide_y(_shift);
			
			stateMachine.change("Idle");
			ground = true;
		}
	},
	leave: function() {
		isClimbing = false;
		ladderInstance = noone;
		gravEnabled = true;
		yspeed.clear_all();
	}
});
// ================================
stateMachine.add("Hurt", {
	enter: function() {
		isHurt = true;
		hitTimer = 0;
		iFrames = INFINITE_I_FRAMES;
		animator.play("hurt");
		
		xspeed.value = image_xscale * -0.5;
		yspeed.value = (-1.5 * gravDir) * (yspeed.value * gravDir <= 0);
        
        play_sfx(sfxPlayerHit);
	},
	tick: function() {
		if (stateMachine.timer >= 32)
			stateMachine.change(isSliding ? "Slide" : "Idle");
	},
	leave: function() {
		isHurt = false;
		iFrames = 60;
		hitTimer = 0;
	}
});
// ================================
stateMachine.add("Death", {
	enter: function() {
		canTakeDamage = false;
		if (!is_undefined(player)) {
			audio_stop_all();
			queue_pause();
			defer(DeferType.STEP, function(__) /*=>*/ { queue_unpause(); }, 30, true, true);
		}
	},
	tick: function() {
		if (stateMachine.timer < 1)
			return;
		
		var _explosion_params = {
			sprite_index: sprExplosion,
			animSpeed: 1/3,
			lifeDuration: 0
		};
		for (var i = 0; i < 16; i++) {
			with (instance_create_depth(x, y, depth, objGenericEffect, _explosion_params))
				set_velocity_vector(0.75 * (1 + floor(i / 8)), i * 45);
		}
		
		healthpoints = 0;
		play_sfx(sfxDeath);
		
		if (!is_undefined(player)) {
			objSystem.level.canPause = false;
			defer(DeferType.STEP, function(__) /*=>*/ { room_restart(); }, GAME_SPEED * 3, true, true);
		}
		
		instance_destroy();
	},
});