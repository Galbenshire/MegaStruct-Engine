/// @description State Machine Init
// === The States ===
// - Inactive
// - Intro
// - Idle
// - Sidestep
// - Walk
// - Brake
// - Jump
// - Fall
// - Slide
// - Climb
// - Hurt
// - Death
// - Debug_FreeMovement

with (stateMachine.add("Inactive")) {
	set_event("enter", function() {
		isIntro = true;
		canTakeDamage = false;
		gravEnabled = false;
		visible = false;
		
		introLock.add_actions(PlayerAction.PHYSICS);
		introLock.activate();
		pauseLock.activate();
	});
	set_event("leave", function() {
		isIntro = false;
		canTakeDamage = true;
		gravEnabled = true;
		visible = true;
		
		introLock.deactivate();
		introLock.remove_actions(PlayerAction.PHYSICS);
		pauseLock.deactivate();
	});
}
with (stateMachine.add("Intro")) {
	set_event("enter", function() {
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
	});
	set_event("tick", function() {
		if (stateMachine.substate == 0) {
			y += 8;
			
			if (y >= ystart) {
				y = ystart;
				animator.play("teleport-in");
				stateMachine.change_substate(1);
				play_sfx(sfxTeleportIn);
			}
		} else if (animator.is_animation_finished()) {
			stateMachine.change_state("Idle");
		}
	});
	set_event("leave", function() {
		isIntro = false;
		collideWithSolids = true;
		gravEnabled = true;
		canTakeDamage = true;
		ground = true;
		interactWithWater = true;
		ignoreCamera = false;
		
		introLock.deactivate();
		pauseLock.deactivate();
	});
}
with (stateMachine.add("Idle")) {
	set_event("enter", function() {
		self.common_state_ground("enter");
		animator.play("idle");
	});
	set_event("tick", function() {
		if (self.common_state_ground("tick"))
			return;
		
		if (xDir != 0 && !self.is_action_locked(PlayerAction.MOVE_GROUND)) {
			var _canSidestep = (stepFrames > 0);
			if (stateMachine.get_previous_state() == "Walk")
				_canSidestep &= (stateMachine.timer >= QUICK_TURN_BUFFER);
			stateMachine.change_state(_canSidestep ? "Sidestep" : "Walk");
		}
	});
	set_event("posttick", function() {
		if (self.common_state_ground("posttick"))
			return;
		
		if (is_object_type(objIce, groundInstance))
			xspeed.value = approach(xspeed.value, 0, DEFAULT_ICE_DECEL_IDLE);
		else
			xspeed.value = 0;
	});
}
with (stateMachine.add("Sidestep")) {
	set_event("enter", function() {
		self.common_state_ground("enter");
		move_and_collide_x(xDir);
		move_and_collide_y(gravDir);
		animator.play("sidestep");
	});
	set_event("tick", function() {
		if (self.common_state_ground("tick"))
			return;
		
		if (xDir == 0 || self.is_action_locked(PlayerAction.MOVE_GROUND))
			stateMachine.change_state("Idle");
		else if (stateMachine.timer >= stepFrames)
			stateMachine.change_state("Walk");
	});
	set_event("posttick", function() /*=>*/ { self.common_state_ground("posttick"); });
}
with (stateMachine.add("Walk")) {
	set_event("enter", function() {
		self.common_state_ground("enter");
		animator.play("walk");
	});
	set_event("tick", function() {
		if (self.common_state_ground("tick"))
			return;
		
		if (self.is_action_locked(PlayerAction.MOVE_GROUND))
			stateMachine.change_state("Idle");
		else if (xDir == 0)
			stateMachine.change_state(brakeFrames > 0 ? "Brake" : "Idle");
	});
	set_event("posttick", function() {
		if (self.common_state_ground("posttick"))
			return;
		
		if (is_object_type(objIce, groundInstance))
			xspeed.value = approach(xspeed.value, walkSpeed * xDir, DEFAULT_ICE_DECEL_WALK);
		else
			xspeed.value = walkSpeed * xDir;
	});
}
with (stateMachine.add("Brake")) {
	set_event("enter", function() {
		self.common_state_ground("enter");
		animator.play("brake");
	});
	set_event("tick", function() {
		if (self.common_state_ground("tick"))
			return;
		
		if (self.is_action_locked(PlayerAction.MOVE_GROUND))
			stateMachine.change_state("Idle");
		else if (xDir == 0)
			stateMachine.change_state(brakeFrames > 0 ? "Brake" : "Idle");
	});
	set_event("posttick", function() {
		if (self.common_state_ground("posttick"))
			return;
		
		if (is_object_type(objIce, groundInstance))
			xspeed.value = approach(xspeed.value, 0, DEFAULT_ICE_DECEL_IDLE);
		else
			xspeed.value = brakeSpeed * xDir;
	});
}
with (stateMachine.add("Jump")) {
	set_event("enter", function() {
		self.common_state_air("enter");
		yspeed.value = jumpSpeed * -gravDir;
		animator.play("jump");
		canMinJump = true;
		coyoteTimer = 0;
		jumpBufferTimer = 0;
	});
	set_event("tick", function() {
		if (self.common_state_air("tick"))
			return;
		
		if (canMinJump && yspeed.value * gravDir < -minJumpThreshold && !inputs.is_held(InputActions.JUMP)) {
			yspeed.value = -minJumpCutoff;
			canMinJump = false;
		}
		
		if (yspeed.value * gravDir >= 0)
			stateMachine.change_state("Fall");
	});
	set_event("posttick", function() /*=>*/ { self.common_state_air("posttick"); });
}
with (stateMachine.add("Fall")) {
	set_event("enter", function() {
		self.common_state_air("enter");
		animator.play("fall");
	});
	set_event("tick", function() {
		if (self.common_state_air("tick"))
			return;
		
		var _canJump = inputs.is_pressed(InputActions.JUMP) && (coyoteTimer > 0 || midairJumps < maxMidairJumps);
		if (!_canJump)
			return;
		
		if (coyoteTimer <= 0) {
			midairJumps++;
			slideBoostActive = false;
			play_sfx(sfxBalladeShoot);
			
			for (var i = -1; i <= 1; i += 2) {
				with (instance_create_depth(x + 4 * i, bbox_vertical(gravDir) - 2 * image_yscale, depth, objGenericEffect)) {
					sprite_index = sprSlideDust;
					image_xscale = i;
					animSpeed = 0.2;
					destroyOnAnimEnd = true;
					xspeed.value = i;
				}
			}
		}
		stateMachine.change_state("Jump");
	});
	set_event("posttick", function() /*=>*/ { self.common_state_air("posttick"); });
}
with (stateMachine.add("Slide")) {
	set_event("enter", function() {
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
	});
	set_event("posttick", function() {
		if (self.try_climbing()) {
			stateMachine.change_state("Climb");
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
			if (!self.is_action_locked(PlayerAction.JUMP) && !self.check_input_down_jump_slide()) {
				slideBoostActive = canSlideBoost;
				stateMachine.change_state("Jump");
				return;
			}
		}
		
		var _freeSpaceBelow = !ground && !test_move_y(slideMaskHeightDelta * gravDir);
		if (!ground) {
			move_and_collide_y(slideMaskHeightDelta * gravDir * (!_freeSpaceAbove && _freeSpaceBelow));
			stateMachine.change_state("Fall");
			coyoteTimer = COYOTE_FALL_BUFFER;
			return;
		}
		
		if (xDir == -image_xscale && !self.is_action_locked(PlayerAction.TURN_GROUND)) {
			if (_freeSpaceAbove) {
				stateMachine.change_state("Idle");
				return;
			}
			
			image_xscale = xDir;
			xspeed.value = slideSpeed * image_xscale;
		}
		
		var _shouldEnd = xcoll != 0 || stateMachine.timer >= slideFrames || self.is_action_locked(PlayerAction.SLIDE);
		if (_shouldEnd && (_freeSpaceAbove || _freeSpaceBelow)) {
			move_and_collide_y(slideMaskHeightDelta * gravDir * (!_freeSpaceAbove && _freeSpaceBelow));
			stateMachine.change_state(xDir == image_xscale ? "Walk" : (brakeFrames > 0 ? "Brake" : "Idle"));
		}
	});
	set_event("leave", function() {
		isSliding = false;
		slideLock.deactivate();
		slideLock.remove_actions(PlayerAction.CHARGE);
		mask_index = maskNormal;
	});
}
with (stateMachine.add("Climb")) {
	set_event("enter", function() {
		x = bbox_x_center(ladderInstance);
		y = clamp(y, ladderInstance.bbox_top - 8 * (gravDir > 0), ladderInstance.bbox_bottom + 8 * (gravDir < 0));
		
		xspeed.clear_all();
		yspeed.clear_all();
		animator.play("climb");
		
		ground = false;
		groundInstance = noone;
		gravEnabled = false;
		isClimbing = true;
		slideBoostActive = false;
		midairJumps = 0;
	});
	set_event("tick", function() {
		if (!instance_exists(ladderInstance)) {
			stateMachine.change_state("Fall");
			return;
		}
		
		yspeed.value = climbSpeed * yDir * !isShooting * !self.is_action_locked(PlayerAction.CLIMB);
		
		animator.set_time_scale(abs(yspeed.value) != 0);
		if (animator.timeScale.value == 0)
			animator.reset_frame_counter();
		
		// Hop off the ladder if we press jump
		if (yDir != -gravDir && inputs.is_pressed(InputActions.JUMP) && !self.is_action_locked(PlayerAction.JUMP))
			stateMachine.change_state("Fall");
	});
	set_event("posttick", function() {
		// Hitting ground while climbing down
		if (sign(ycoll) == gravDir) {
			stateMachine.change_state("Idle", function() {
				stateMachine.run_current_event_function();
				ground = true;
				groundInstance = ycollInstance;
			});
			return;
		}
		
		// Reached the bottom of the ladder?
		var _reachedBottom = (gravDir >= 0) ? y > ladderInstance.bbox_bottom : y < ladderInstance.bbox_top;
		if (_reachedBottom) {
			stateMachine.change_state("Fall");
			return;
		}
		
		// Reached the top of the ladder?
		var _reachedTop = (gravDir >= 0) ? y < ladderInstance.bbox_top - 10 : y > ladderInstance.bbox_bottom + 10;
		if (_reachedTop) {
			var _shift = bbox_vertical(-gravDir, ladderInstance) - bbox_vertical(gravDir);
			move_and_collide_y(_shift);
			
			stateMachine.change_state("Idle");
			ground = true;
		}
	});
	set_event("leave", function() {
		isClimbing = false;
		ladderInstance = noone;
		gravEnabled = true;
		yspeed.clear_all();
	});
}
with (stateMachine.add("Hurt")) {
	set_event("enter", function() {
		isHurt = true;
		hitTimer = 0;
		iFrames = INFINITE_I_FRAMES;
		animator.play("hurt");
		
		shootStandStillLock.deactivate();
		hitstunLock.activate();
		if (!isCharging)
			hitstunLock.add_actions(PlayerAction.CHARGE);
		
		if (!self.is_action_locked(PlayerAction.MOVE)) {
			xspeed.value = image_xscale * -0.5;
			yspeed.value = (-1.5 * gravDir) * (yspeed.value * gravDir <= 0);
		}
        
        play_sfx(sfxPlayerHit);
	});
	set_event("tick", function() {
		if (stateMachine.timer >= 32)
			stateMachine.change_state(isSliding ? "Slide" : "Idle");
	});
	set_event("leave", function() {
		isHurt = false;
		iFrames = 60;
		hitTimer = 0;
		hitstunLock.deactivate();
		hitstunLock.remove_actions(PlayerAction.CHARGE);
	});
}
with (stateMachine.add("Death")) {
	set_event("enter", function() {
		canTakeDamage = false;
		canDieToPits = false;
		
		if (self.is_user_controlled()) {
			audio_stop_all();
			
			if (!diedToAPit) {
				queue_pause();
				defer(DeferType.STEP, function(__) /*=>*/ { queue_unpause(); }, 30, true, true);
			}
		}
	});
	set_event("tick", function() {
		if (stateMachine.timer < 1)
			return;
		
		if (!diedToAPit)
			player_death_explosion(x, y, depth);
		
		healthpoints = 0;
		lifeState = LifeState.DEAD_ONSCREEN;
		play_sfx(sfxDeath);
		
		if (self.is_user_controlled()) {
			self.update_hud_health(0);
			pauseLock.activate();
			defer(DeferType.STEP, function(__) /*=>*/ { go_to_room(objSystem.level.checkpoint[CheckpointData.room]); }, GAME_SPEED * 3, true, true);
		}
		
		instance_destroy();
	});
	set_event("leave", function() {
		isHurt = false;
		iFrames = 60;
		hitTimer = 0;
		hitstunLock.deactivate();
		hitstunLock.remove_actions(PlayerAction.CHARGE);
	});
}
with (stateMachine.add("Debug_FreeMovement")) {
	set_event("enter", function() {
		isFreeMovement = true;
		gravEnabled = false;
		collideWithSolids = false;
		canTakeDamage = false;
		interactWithWater = false;
		xspeed.clear_all();
		yspeed.clear_all();
		freeMovementLock.activate();
		play_sfx(sfxYasichi);
	});
	set_event("tick", function() {
		var _spd = 2 + (2 * inputs.is_held(InputActions.SHOOT)) + (6 * inputs.is_held(InputActions.SLIDE));
		
		x += _spd * xDir;
		y += _spd * yDir;
		image_alpha = (stateMachine.timer mod 80) / 80;
		
		var _cellDir = inputs.is_pressed(InputActions.WEAPON_SWITCH_RIGHT) - inputs.is_pressed(InputActions.WEAPON_SWITCH_LEFT);
		if (_cellDir != 0) {
			if (inputs.is_held(InputActions.SHOOT))
				skinPage = modf(skinPage + _cellDir, PlayerSpritesheetPage.COUNT);
			else if (inputs.is_held(InputActions.SLIDE))
				skinCellY = modf(skinCellY + _cellDir, global.spriteAtlas_Player.rows);
			else
				skinCellX = modf(skinCellX + _cellDir, global.spriteAtlas_Player.columns);
		}
		
		if (stateMachine.timer mod 4 == 0) {
			with (instance_create_depth(x + irandom_range(-16, 16), y + irandom_range(-16, 16), depth - 1, objGenericEffect)) {
				sprite_index = sprShine;
				image_xscale = choose(-1, 1);
				image_yscale = choose(-1, 1);
				animSpeed = 0.2;
				destroyOnAnimEnd = true;
			}
		}
	});
	set_event("leave", function() {
		image_alpha = 1;
		isFreeMovement = false;
		gravEnabled = true;
		collideWithSolids = true;
		canTakeDamage = true;
		interactWithWater = true;
		freeMovementLock.deactivate();
		play_sfx(sfxYasichi);
	});
}