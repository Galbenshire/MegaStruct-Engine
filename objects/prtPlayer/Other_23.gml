/// @description State Machine Init
/// @init

// === The States ===
// -- Standard Movement --
// - StandardGround
// - StandardAir


#region Standard Movement

stateMachine.add_state("StandardGround", {
	init: function(_stateData) /*=>*/ { _stateData.quickTurnTimer = 0; },
	enter: function(_prevState, _payload, _stateData) {
		_stateData.quickTurnTimer = 0;
		slideBoostActive = false;
		jumpedOffLadder = false;
		midairJumps = 0;
		
		if (struct_exists(_payload, "substate"))
			stateMachine.set_substate(_payload.substate);
	},
	resume: function(_prevState) /*=>*/ { stateMachine.set_substate(0); },
	tick: function(_substate, _timer) {
		if (self.check_input_jump() && !self.check_input_down_jump_slide()) {
			stateMachine.change_state("Jump");
			return;
		}
		if (xDir != 0 && !self.is_action_locked(PlayerAction.TURN_GROUND))
			image_xscale = xDir;
		
		var _isOnIce = is_object_type(objIce, groundInstance);
		
		switch (_substate) {
			case SUBSTATE_GROUND_IDLE:
				animator.play("idle");
				if (_isOnIce)
					xspeed.approach_value(0, DEFAULT_ICE_DECEL_IDLE);
				else
					xspeed.value = 0;
				break;
			case SUBSTATE_GROUND_SIDESTEP:
				if (_timer == 0) {
					move_and_collide_x(xDir);
					move_and_collide_y(gravDir);
				}
				animator.play("sidestep");
				if (_isOnIce)
					xspeed.approach_value(0, DEFAULT_ICE_DECEL_IDLE);
				else
					xspeed.value = 0;
				break;
			case SUBSTATE_GROUND_BRAKE:
				animator.play("brake");
				if (_isOnIce)
					xspeed.approach_value(0, DEFAULT_ICE_DECEL_IDLE);
				else
					xspeed.value = brakeSpeed * image_xscale;
				break;
			case SUBSTATE_GROUND_WALK:
				animator.play("walk");
				if (_isOnIce)
					xspeed.approach_value(walkSpeed * xDir, DEFAULT_ICE_DECEL_WALK);
				else
					xspeed.value = walkSpeed * xDir;
				break;
		}
	},
	posttick: function(_substate, _timer, _stateData) {
		if (self.try_climbing()) {
			stateMachine.change_state("Climb");
			return;
		}
		if (!ground) {
			move_and_collide_y(gravDir);
			stateMachine.change_state("StandardAir");
			coyoteTimer = COYOTE_FALL_BUFFER;
			return;
		}
		if (self.try_sliding()) {
			stateMachine.change_state("Slide");
			return;
		}
		
		if (_substate == SUBSTATE_GROUND_IDLE)
			_stateData.quickTurnTimer--;
		else if (_substate == SUBSTATE_GROUND_WALK)
			_stateData.quickTurnTimer = QUICK_TURN_BUFFER;
		
		var _isMoveGroundLocked = self.is_action_locked(PlayerAction.MOVE_GROUND);
		
		switch (_substate) {
			case SUBSTATE_GROUND_IDLE:
				if (xDir != 0 && !_isMoveGroundLocked) {
					var _canSidestep = (stepFrames > 0) && (_stateData.quickTurnTimer < 0);
					stateMachine.set_substate(_canSidestep ? SUBSTATE_GROUND_SIDESTEP : SUBSTATE_GROUND_WALK);
				}
				break;
			case SUBSTATE_GROUND_SIDESTEP:
				if (xDir == 0 || _isMoveGroundLocked)
					stateMachine.set_substate(SUBSTATE_GROUND_IDLE);
				else if (_timer >= stepFrames)
					stateMachine.set_substate(SUBSTATE_GROUND_WALK);
				break;
			case SUBSTATE_GROUND_BRAKE:
				if (_isMoveGroundLocked)
					stateMachine.set_substate(SUBSTATE_GROUND_IDLE);
				else if (xDir != 0)
					stateMachine.set_substate(SUBSTATE_GROUND_WALK);
				else if (_timer >= brakeFrames)
					stateMachine.set_substate(SUBSTATE_GROUND_IDLE);
				break;
			case SUBSTATE_GROUND_WALK:
				if (_isMoveGroundLocked)
					stateMachine.set_substate(SUBSTATE_GROUND_IDLE);
				else if (xDir == 0)
					stateMachine.set_substate(brakeFrames > 0 ? SUBSTATE_GROUND_BRAKE : SUBSTATE_GROUND_IDLE);
				break;
		}
	}
});
stateMachine.add_state("StandardAir", {
	enter: function(_prevState) {
		ground = false;
		groundInstance = noone;
	},
	resume: function(_prevState) {
		if (ground)
			stateMachine.change_state("StandardGround");
	},
	tick: function(_substate, _timer) {
		xspeed.value = airSpeed * xDir * !self.is_action_locked(PlayerAction.MOVE_AIR);
		if (xDir != 0 && !self.is_action_locked(PlayerAction.TURN_AIR))
			image_xscale = xDir;
		
		var _relativeYSpeed = yspeed.value * gravDir;
		animator.play((_relativeYSpeed >= 0) ? "fall" : "jump");
		
		var _canJump = inputs.is_pressed(InputActions.JUMP)
			&& (coyoteTimer > 0 || midairJumps < maxMidairJumps)
			&& !self.is_action_locked(PlayerAction.JUMP);
		if (_canJump) {
			stateMachine.change_state("Jump", { isMidairJump: coyoteTimer <= 0 });
			return;
		}
		
		if (_substate == SUBSTATE_AIR_JUMP) { // Jumping
			if (canMinJump && _relativeYSpeed < -minJumpThreshold && !inputs.is_held(InputActions.JUMP)) {
				yspeed.value = -minJumpCutoff;
				canMinJump = false;
			}
			if (_relativeYSpeed >= 0)
				stateMachine.set_substate(SUBSTATE_AIR_FALL);
		}
	},
	posttick: function(_substate, _timer) {
		if (self.try_climbing()) {
			stateMachine.change_state("Climb");
			return;
		}
		if (ground) {
			var _groundSubstate = (xDir == 0) ? SUBSTATE_GROUND_IDLE : SUBSTATE_GROUND_WALK;
			stateMachine.change_state("StandardGround", { substate: _groundSubstate });
			play_sfx(sfxLand);
		}
	}
});

#endregion

#region Specialised Movement

stateMachine.add_state("Jump", {
	enter: function(_prevState, _payload) {
		var _speed = _payload[$ "speed"] ?? jumpSpeed,
			_canMinJump = _payload[$ "canMinJump"] ?? true,
			_isMidairJump = _payload[$ "isMidairJump"] ?? false;
		
		yspeed.value = _speed * -gravDir;
		canMinJump = _canMinJump;
		coyoteTimer = 0;
		jumpBufferTimer = 0;
		animator.play("jump");
		
		if (_isMidairJump) {
			midairJumps++;
			slideBoostActive = false;
			play_sfx(sfxBalladeShoot);
			
			for (var i = -1; i <= 1; i += 2) {
				with (instance_create_depth(x + 4 * i, bbox_vertical(gravDir) - 2 * image_yscale, depth, objSlideDust)) {
					image_xscale = i;
					xspeed.value = i;
				}
			}
		}
		
		stateMachine.change_state("StandardAir");
		stateMachine.change_substate(SUBSTATE_AIR_JUMP);
	}
});
stateMachine.add_state("Slide", {
	enter: function(_prevState) {
		mask_index = maskSlide;
		isSliding = true;
		slideLock.activate();
		if (!isCharging)
			slideLock.add_actions(PlayerAction.CHARGE);
		
		xspeed.value = slideSpeed * image_xscale;
		yspeed.clear_all();
		animator.play("slide");
		
		with (instance_create_depth(bbox_horizontal(-image_xscale), bbox_vertical(image_yscale) - 4 * image_yscale, depth, objSlideDust))
			image_xscale = -other.image_xscale;
	},
	resume: function(_prevState) {
		if (!isSliding) {
			stateMachine.change_state(ground ? "StandardGround" : "StandardAir");
			return;
		}
		
		mask_index = maskSlide;
		animator.play("slide");
		xspeed.value = slideSpeed * image_xscale;
		slideLock.remove_actions(PlayerAction.MOVE_FULL);
	},
	tick: function(_substate, _timer) /*=>*/ { xspeed.value = slideSpeed * image_xscale; },
	posttick: function(_substate, _timer) {
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
		if (_freeSpaceAbove && ground && inputs.is_pressed(InputActions.JUMP)) {
			if (!self.is_action_locked(PlayerAction.JUMP) && !self.check_input_down_jump_slide()) {
				slideBoostActive = slideBoostEnabled;
				stateMachine.change_state("Jump");
				return;
			}
		}
		
		var _freeSpaceBelow = !ground && !test_move_y(slideMaskHeightDelta * gravDir);
		if (!ground) {
			var _nudge = (!_freeSpaceAbove && _freeSpaceBelow) ? slideMaskHeightDelta * gravDir : gravDir;
			move_and_collide_y(_nudge);
			stateMachine.change_state("StandardAir");
			coyoteTimer = COYOTE_FALL_BUFFER;
			return;
		}
		
		if (xDir == -image_xscale && !self.is_action_locked(PlayerAction.TURN_GROUND)) {
			if (_freeSpaceAbove) {
				stateMachine.change_state("StandardGround");
				return;
			}
			image_xscale = xDir;
		}
		
		var _shouldEnd = xcoll != 0 || _timer >= slideFrames || self.is_action_locked(PlayerAction.SLIDE);
		if (_shouldEnd && (_freeSpaceAbove || _freeSpaceBelow)) {
			move_and_collide_y(slideMaskHeightDelta * gravDir * (!_freeSpaceAbove && _freeSpaceBelow));
			
			var _groundSubstate = (xDir == image_xscale)
				? SUBSTATE_GROUND_WALK
				: (brakeFrames > 0 ? SUBSTATE_GROUND_BRAKE : SUBSTATE_GROUND_IDLE);
			stateMachine.change_state("StandardGround", { substate: _groundSubstate });
		}
	},
	pause: function(_newState) {
		var _freeSpaceAbove = !test_move_y(-slideMaskHeightDelta * gravDir),
			_freeSpaceBelow = !ground && !test_move_y(slideMaskHeightDelta * gravDir);
		if (_freeSpaceAbove || _freeSpaceBelow) {
			move_and_collide_y(slideMaskHeightDelta * gravDir * (!_freeSpaceAbove && _freeSpaceBelow));
			isSliding = false;
			slideLock.deactivate();
			mask_index = maskNormal;
		} else {
			slideLock.add_actions(PlayerAction.MOVE_FULL);
			mask_index = maskSlideExtended;
		}
	},
	leave: function(_newState) {
		isSliding = false;
		slideLock.deactivate();
		slideLock.remove_actions(PlayerAction.CHARGE, PlayerAction.MOVE_FULL);
		mask_index = maskNormal;
		entity_check_ground();
	}
});
stateMachine.add_state("Climb", {
	enter: function(_prevState) {
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
		jumpedOffLadder = false;
	},
	resume: function(_prevState) /*=>*/ { stateMachine.change_state(ground ? "StandardGround" : "StandardAir"); },
	tick: function(_substate, _timer) {
		if (!instance_exists(ladderInstance)) {
			stateMachine.change_state("StandardAir");
			return;
		}
		
		yspeed.value = climbSpeed * yDir * !isShooting * !self.is_action_locked(PlayerAction.CLIMB);
		
		var _ladderTopDistance = (bbox_vertical(-gravDir, ladderInstance) - y) * gravDir;
		if (_ladderTopDistance > 4) {
			animator.play("climb-top");
		} else {
			animator.play("climb");
			animator.set_time_scale(abs(yspeed.value) != 0);
			if (animator.timeScale == 0)
				animator.reset_frame();
		}
	},
	posttick: function(_substate, _timer) {
		// Have we pressed the jump button?
		if (inputs.is_pressed(InputActions.JUMP) && !self.is_action_locked(PlayerAction.JUMP)) {
			if (climbJumpEnabled && yDir != gravDir) {
				jumpedOffLadder = true;
				stateMachine.change_state("Jump");
				return;
			} else if (yDir != -gravDir) {
				stateMachine.change_state("StandardAir");
				return;
			}
		}
		
		// Hitting ground while climbing down?
		if (sign(ycoll) == gravDir) {
			stateMachine.change_state("StandardGround");
			ground = true;
			groundInstance = ycollInstance;
			return;
		}
		
		// Reached the bottom of the ladder?
		var _reachedBottom = (gravDir >= 0) ? y > ladderInstance.bbox_bottom : y < ladderInstance.bbox_top;
		if (_reachedBottom) {
			stateMachine.change_state("StandardAir");
			return;
		}
		
		// Reached the top of the ladder?
		var _reachedTop = (gravDir >= 0) ? y < ladderInstance.bbox_top - 10 : y > ladderInstance.bbox_bottom + 10;
		if (_reachedTop) {
			var _shift = bbox_vertical(-gravDir, ladderInstance) - bbox_vertical(gravDir);
			move_and_collide_y(_shift);
			
			stateMachine.change_state("StandardGround");
			ground = true;
			entity_check_ground();
		}
	},
	pause: function(_newState, _stateData) /*=>*/ { _stateData.eventMap.leave(_newState, _stateData); },
	leave: function(_newState) {
		isClimbing = false;
		ladderInstance = noone;
		gravEnabled = true;
		yspeed.clear_all();
	}
});

#endregion

#region Off, Ouch, Owie

stateMachine.add_state("Hurt", {
	init: function(_stateData) /*=>*/ { _stateData.skipIFrames = false; },
	enter: function(_prevState, _payload, _stateData) {
		_stateData.skipIFrames = _payload[$ "skipIFrames"] ?? false;
		if (!_stateData.skipIFrames) {
			isHurt = true;
			hitTimer = 0;
			iFrames = 999;
			iFrameFlashStyle = IFrameFlashType.HITSPARK;
		}
		
		play_sfx(sfxPlayerHit);
		animator.play("hurt");
		shootStandStillLock.deactivate();
		hitstunLock.activate();
		if (!isCharging)
			hitstunLock.add_actions(PlayerAction.CHARGE);
		
		var _moveLocked = self.is_action_locked(PlayerAction.MOVE_FULL),
			_gravLocked = self.is_action_locked(PlayerAction.GRAVITY);
		var _factorX = 0.5 * !_moveLocked,
			_factorY = (yspeed.value * gravDir <= 0) * !_moveLocked * !_gravLocked * gravEnabled;
		xspeed.value = -image_xscale * _factorX;
		yspeed.value = (-1.5 * gravDir) * _factorY;
	},
	tick: function(_substate, _timer) {
		if (ground)
			xspeed.value *= !self.is_action_locked(PlayerAction.MOVE_GROUND);
		else
			xspeed.value *= !self.is_action_locked(PlayerAction.MOVE_AIR);
		
		if (_timer >= 32)
			stateMachine.pop_state();
	},
	leave: function(_newState, _stateData) {
		if (!_stateData.skipIFrames)
			iFrames = 60;
		iFrameFlashStyle = IFrameFlashType.FLICKER;
		hitTimer = 0;
		hitstunLock.deactivate();
		hitstunLock.remove_actions(PlayerAction.CHARGE);
		isHurt = false;
	}
});
stateMachine.add_state("Death", {
	init: function(_stateData) /*=>*/ { _stateData.diedToPit = false; },
	enter: function(_prevState, _payload, _stateData) {
		_stateData.diedToPit = _payload[$ "diedToPit"] ?? false;
		hitmaskMaster = 0;
		canDieToPits = false;
		iFrames = 0;
		
		if (self.is_user_controlled()) {
			stop_music();
			audio_stop_all();
			pauseLock.activate();
			if (!_stateData.diedToPit)
				global.hitStunTimer = 30;
		}
	},
	tick: function(_substate, _timer, _stateData) {
		if (_timer < 1)
			return;
		
		if (!_stateData.diedToPit)
			player_death_explosion(x, y, depth);
		
		healthpoints = 0;
		hudElement.healthpoints = 0;
		lifeState = LifeState.DEAD_ONSCREEN;
		entity_clear_hitboxes();
		play_sfx(sfxDeath);
		
		if (self.is_user_controlled())
			defer(DeferType.STEP, function(__) /*=>*/ { go_to_room(objSystem.level.checkpoint[CheckpointData.room]); }, GAME_SPEED * 3, true, true);
		
		instance_destroy();
	}
});

#endregion

#region Misc.

stateMachine.add_state("Inactive", {
	enter: function(_prevState) {
		isIntro = true;
		hitmaskMaster = 0;
		gravEnabled = false;
		visible = false;
		
		introLock.add_actions(PlayerAction.PHYSICS);
		introLock.activate();
		pauseLock.activate();
	},
	leave: function(_newState) {
		isIntro = false;
		hitmaskMaster = HitMask.FULL;
		gravEnabled = true;
		visible = true;
		
		introLock.deactivate();
		introLock.remove_actions(PlayerAction.PHYSICS);
		pauseLock.deactivate();
	}
});
stateMachine.add_state("Intro", {
	enter: function(_prevState) {
		isIntro = true;
		hitmaskMaster = 0;
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
	tick: function(_substate, _timer) {
		if (_substate == 0) {
			y += 8;
			
			if (y >= ystart) {
				y = ystart;
				animator.play("teleport-in");
				stateMachine.change_substate(1);
				play_sfx(sfxTeleportIn);
			}
		} else if (animator.is_animation_finished()) {
			stateMachine.change_state("StandardGround");
		}
	},
	leave: function(_newState) {
		isIntro = false;
		collideWithSolids = true;
		gravEnabled = true;
		hitmaskMaster = HitMask.FULL;
		ground = true;
		interactWithWater = true;
		ignoreCamera = false;
		
		introLock.deactivate();
		pauseLock.deactivate();
	}
});
stateMachine.add_state("Debug_FreeMovement", {
	enter: function(_prevState) {
		isFreeMovement = true;
		gravEnabled = false;
		collideWithSolids = false;
		hitmaskMaster = 0;
		interactWithWater = false;
		xspeed.clear_all();
		yspeed.clear_all();
		freeMovementLock.activate();
		play_sfx(sfxYasichi);
	},
	tick: function(_substate, _timer) {
		var _spd = 2 + (2 * inputs.is_held(InputActions.SHOOT)) + (6 * inputs.is_held(InputActions.SLIDE));
		
		x += _spd * (inputs.is_held(InputActions.RIGHT) - inputs.is_held(InputActions.LEFT));
		y += _spd * (inputs.is_held(InputActions.DOWN) - inputs.is_held(InputActions.UP));
		image_alpha = (_timer mod 80) / 80;
		
		var _cellDir = inputs.is_pressed(InputActions.WEAPON_SWITCH_RIGHT) - inputs.is_pressed(InputActions.WEAPON_SWITCH_LEFT);
		if (_cellDir != 0) {
			if (inputs.is_held(InputActions.SLIDE))
				skinSprite = modf(skinSprite + _cellDir, PlayerSpriteType.COUNT);
			else
				skinIndex += _cellDir;
		}
		
		if (_timer mod 4 == 0) {
			with (instance_create_depth(x + irandom_range(-16, 16), y + irandom_range(-16, 16), depth - 1, objGenericEffect)) {
				sprite_index = sprShine;
				image_xscale = choose(-1, 1);
				image_yscale = choose(-1, 1);
				animSpeed = 0.2;
				destroyOnAnimEnd = true;
			}
		}
	},
	leave: function(_newState) {
		image_alpha = 1;
		isFreeMovement = false;
		gravEnabled = true;
		collideWithSolids = true;
		hitmaskMaster = HitMask.FULL;
		interactWithWater = true;
		freeMovementLock.deactivate();
		play_sfx(sfxYasichi);
	}
});

#endregion