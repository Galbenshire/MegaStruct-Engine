/// @description State Machine Init
// === The States ===
// - StartStart
// - Intro
// - _StandardGround
//		- Idle
//		- Sidestep
//		- Walk
//		- Brake
// - _StandardAir
//		- Jump
//		- Fall
// - Slide
// - Climb
// - Hurt
// - Death

// ================================
stateMachine.add("StageStart", {
	enter: function() {
		isIntro = true;
		canTakeDamage = false;
		gravEnabled = false;
		visible = false;
		
		introLock.add_actions(PlayerAction.PHYSICS);
		introLock.activate();
		pauseLock.activate();
	},
	leave: function() {
		isIntro = false;
		canTakeDamage = true;
		gravEnabled = true;
		visible = true;
		
		introLock.deactivate();
		introLock.remove_actions(PlayerAction.PHYSICS);
		pauseLock.deactivate();
	}
});
// ================================
stateMachine.add("Intro", {
	enter: function() {
		isIntro = true;
		canTakeDamage = false;
		collideWithSolids = false;
		gravEnabled = false;
		interactWithWater = false;
		ignoreCamera = true;
		animator.play("teleport-idle");
		animator.update();
		
		introLock.activate();
		pauseLock.activate();
		
		y = game_view().top_edge(0);
	},
	tick: function() {
		if (animator.currentAnimationName == "teleport-idle") {
			y += 8;
			
			if (y >= ystart) {
				y = ystart;
				animator.play("teleport-in");
				play_sfx(sfxTeleportIn);
			}
		} else if (animator.is_animation_finished()) {
			stateMachine.change("Idle");
		}
	},
	leave: function() {
		isIntro = false;
		collideWithSolids = true;
		gravEnabled = true;
		canTakeDamage = true;
		ground = true;
		interactWithWater = true;
		ignoreCamera = false;
		
		introLock.deactivate();
		pauseLock.deactivate();
	}
});
// ================================
stateMachine.add("_StandardGround", {
	tick: function() {
		var _jumpInput = inputs.is_pressed(InputActions.JUMP)
			|| (jumpBufferTimer > 0 && inputs.is_held(InputActions.JUMP));
		if (_jumpInput) {
			var _downJumpSlide = yDir == gravDir && options_data().downJumpSlide,
				_canJump = !player_is_action_locked(PlayerAction.JUMP) && !_downJumpSlide;
			if (_canJump) {
				stateMachine.change("Jump");
				return;
			}
		}
		
		if (xDir != 0 && !player_is_action_locked(PlayerAction.TURN_GROUND))
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
			move_and_collide_y(gravDir);
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
			
			if (is_object_type(objIce, groundInstance))
				xspeed.value = approach(xspeed.value, 0, DEFAULT_ICE_DECEL_IDLE);
			else
				xspeed.value = 0;
			
			if (xDir != 0 && !player_is_action_locked(PlayerAction.MOVE_GROUND)) {
				var _canSidestep = (stepFrames > 0);
				if (stateMachine.is_previous_state("Walk"))
					_canSidestep &= (stateMachine.timer >= 2);
				stateMachine.change(_canSidestep ? "Sidestep" : "Walk");
			}
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
			
			if (xDir == 0 || player_is_action_locked(PlayerAction.MOVE_GROUND)) {
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
			
			if (player_is_action_locked(PlayerAction.MOVE_GROUND))
				stateMachine.change("Idle");
			else if (xDir == 0)
				stateMachine.change(brakeFrames > 0 ? "Brake" : "Idle");
			else if (is_object_type(objIce, groundInstance))
				xspeed.value = approach(xspeed.value, walkSpeed * xDir, DEFAULT_ICE_DECEL_WALK);
			else
				xspeed.value = walkSpeed * xDir;
		}
	});
// --------------------------------
	stateMachine.add_child("_StandardGround", "Brake", {
		enter: function() {
			animator.play("brake");
		},
		tick: function() {
			stateMachine.inherit();
			if (stateMachine.has_just_changed())
				return;
			
			if (player_is_action_locked(PlayerAction.MOVE_GROUND))
				stateMachine.change("Idle");
			else if (xDir != 0)
				stateMachine.change("Walk");
			else if (is_object_type(objIce, groundInstance))
				xspeed.value = approach(xspeed.value, 0, DEFAULT_ICE_DECEL_IDLE);
			else
				xspeed.value = brakeSpeed * image_xscale;
			
			if (stateMachine.timer >= brakeFrames && !stateMachine.has_just_changed())
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
		xspeed.value = airSpeed * xDir * !player_is_action_locked(PlayerAction.MOVE_AIR);
		
		if (xDir != 0 && !player_is_action_locked(PlayerAction.TURN_AIR))
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
		slideLock.activate();
		if (!isCharging)
			slideLock.add_actions(PlayerAction.CHARGE);
		
		xspeed.value = slideSpeed * image_xscale;
		yspeed.clear_all();
		animator.play("slide");
		
		mask_index = maskSlide;
		
		with (instance_create_depth(bbox_horizontal(-image_xscale), bbox_vertical(image_yscale) - 4 * image_yscale, depth, objSlideDust))
			image_xscale = -other.image_xscale;
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
		
		var _freeSpaceAbove = !test_move_y(-slideMaskHeightDelta * gravDir);
		if (ground && _freeSpaceAbove && inputs.is_pressed(InputActions.JUMP)) {
			var _downJumpSlide = yDir == gravDir && options_data().downJumpSlide,
				_canJump = !player_is_action_locked(PlayerAction.JUMP) && !_downJumpSlide;
			if (_canJump) {
				stateMachine.change("Jump");
				return;
			}
		}
		
		var _freeSpaceBelow = !ground && !test_move_y(slideMaskHeightDelta * gravDir);
		if (!ground) {
			move_and_collide_y(slideMaskHeightDelta * gravDir * (!_freeSpaceAbove && _freeSpaceBelow));
			stateMachine.change("Fall");
			coyoteTimer = COYOTE_FALL_BUFFER;
			return;
		}
		
		if (xDir == -image_xscale && !player_is_action_locked(PlayerAction.TURN_GROUND)) {
			if (_freeSpaceAbove) {
				stateMachine.change("Idle");
				return;
			}
			
			image_xscale = xDir;
			xspeed.value = slideSpeed * image_xscale;
		}
		
		var _shouldEnd = xcoll != 0 || stateMachine.timer >= slideFrames || player_is_action_locked(PlayerAction.SLIDE);
		if (_shouldEnd && (_freeSpaceAbove || _freeSpaceBelow)) {
			move_and_collide_y(slideMaskHeightDelta * gravDir * (!_freeSpaceAbove && _freeSpaceBelow));
			stateMachine.change(xDir == image_xscale ? "Walk" : "Idle");
		}
	},
	leave: function() {
		isSliding = false;
		slideLock.deactivate();
		slideLock.remove_actions(PlayerAction.CHARGE);
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
		yspeed.value = climbSpeed * yDir * !isShooting * !player_is_action_locked(PlayerAction.CLIMB);
		animator.set_time_scale(abs(yspeed.value) != 0);
		
		if (animator.timeScale.value == 0)
			animator.reset_frame_counter();
		
		if (yDir != -gravDir && inputs.is_pressed(InputActions.JUMP) && !player_is_action_locked(PlayerAction.JUMP))
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
		
		shootStandStillLock.deactivate();
		hitstunLock.activate();
		if (!isCharging)
			hitstunLock.add_actions(PlayerAction.CHARGE);
		
		if (!player_is_action_locked(PlayerAction.MOVE)) {
			xspeed.value = image_xscale * -0.5;
			yspeed.value = (-1.5 * gravDir) * (yspeed.value * gravDir <= 0);
		}
        
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
		hitstunLock.deactivate();
		hitstunLock.remove_actions(PlayerAction.CHARGE);
	}
});
// ================================
stateMachine.add("Death", {
	enter: function() {
		canTakeDamage = false;
		canDieToPits = false;
		
		if (!is_undefined(playerUser)) {
			audio_stop_all();
			
			if (!diedToAPit) {
				queue_pause();
				defer(DeferType.STEP, function(__) /*=>*/ { queue_unpause(); }, 30, true, true);
			}
		}
	},
	tick: function() {
		if (stateMachine.timer < 1)
			return;
		
		if (!diedToAPit) {
			var _explosion_params = {
				sprite_index: sprExplosion,
				animSpeed: 1/3,
				lifeDuration: 0
			};
			for (var i = 0; i < 16; i++) {
				with (instance_create_depth(x, y, depth, objGenericEffect, _explosion_params))
					set_velocity_vector(0.75 * (1 + floor(i / 8)), i * 45);
			}
		}
		
		healthpoints = 0;
		lifeState = LifeState.DEAD_ONSCREEN;
		play_sfx(sfxDeath);
		
		if (!is_undefined(playerUser)) {
			playerUser.hudElement.healthpoints = healthpoints;
			pauseLock.activate();
			defer(DeferType.STEP, function(__) /*=>*/ { go_to_room(objSystem.level.checkpoint.room); }, GAME_SPEED * 3, true, true);
		}
		
		instance_destroy();
	}
});