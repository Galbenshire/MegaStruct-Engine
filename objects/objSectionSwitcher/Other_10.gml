/// @description State Machine Init
// ======== The States ======== 
// ------ Main ------
// - _PreTransition
// - Transition
// - _PostTransition
// ------ Mods (before transition) ------
// - FixCameraIn
// - BossDoorOpen
// ------ Mods (after transition) ------
// - FixCameraOut
// - BossDoorClose

#region Main States

stateMachine.add_state("_PreTransition", {
	enter: function(_prevState) {
		global.switchingSections = true;
		queue_pause();
	},
	tick: function(_substate, _timer) {
		if (_substate == 0) {
			assert(instance_exists(playerInstance), "Did you forget to link the player to the section switcher?");
			assert(instance_exists(transitionInstance), "Did you forget to link the transition to the section switcher?");
			
			targetSection = transitionInstance.section;
			activate_game_objects(targetSection);
			
			x = gameViewRef.xView;
			y = gameViewRef.yView;
			objSystem.camera.active = false;
			
			playerXSpeedCache = playerInstance.xspeed.value;
			playerYSpeedCache = playerInstance.yspeed.value;
			playerInstance.refresh_palette();
			
			stateMachine.change_substate(1);
		} else if (global.paused) { // An extra tick frame due to instance activation/deactivation conflicts
			deactivate_game_objects(true, targetSection);
			stateMachine.change_state("Transition");
			stateMachine.push_state("FixCameraIn");
			stateMachine.push_state("BossDoorOpen");
		}
	}
});
stateMachine.add_state("Transition", {
	enter: function(_prevState) {
		var _directionDiv = transitionInstance.image_angle div 90;
        isVerticalTransition = bool(_directionDiv & 1);
		transitionXDir = (1 - _directionDiv) * !isVerticalTransition;
		transitionYDir = (_directionDiv - 2) * isVerticalTransition;
		
		var _scrollLength = isVerticalTransition ? GAME_HEIGHT : GAME_WIDTH,
			_scrollSpeed = _scrollLength / scrollDuration;
		screenScrollXSpeed = _scrollSpeed * transitionXDir;
		screenScrollYSpeed = _scrollSpeed * transitionYDir;
		
		var _targetX = isVerticalTransition ? playerInstance.x : bbox_horizontal(-transitionXDir, targetSection) + borderDistance * transitionXDir,
			_targetY = !isVerticalTransition ? playerInstance.y : bbox_vertical(-transitionYDir, targetSection) + borderDistance * transitionYDir;
		playerMoveXSpeed = (_targetX - playerInstance.x) / scrollDuration;
		playerMoveYSpeed = (_targetY - playerInstance.y) / scrollDuration;
		
		xspeed.value = screenScrollXSpeed;
		yspeed.value = screenScrollYSpeed;
		playerInstance.xspeed.value = playerMoveXSpeed;
		playerInstance.yspeed.value = playerMoveYSpeed;
		
		animatePlayer = array_contains(persistentAnimations, playerInstance.animator.currentAnimationName)
			&& !playerInstance.is_action_locked(PlayerAction.SPRITE_CHANGE);
	},
	resume: function(_prevState) {
		xspeed.value = screenScrollXSpeed;
		yspeed.value = screenScrollYSpeed;
		playerInstance.xspeed.value = playerMoveXSpeed;
		playerInstance.yspeed.value = playerMoveYSpeed;
	},
	tick: function(_substate, _timer) {
		if (_timer < scrollDuration) {
			event_user(1); // Move Camera
			event_user(2); // Move Player
		} else {
			stateMachine.change_state("_PostTransition");
		}
	}
});
stateMachine.add_state("_PostTransition", {
	enter: function(_prevState) {
		stateMachine.push_state("FixCameraOut");
		stateMachine.push_state("BossDoorClose");
	},
	tick: function(_substate, _timer) {
		if (_substate == 0) {
			global.section = targetSection;
			
			global.switchingSections = false; // Disable while we deactivate objects out of bounds
			deactivate_game_objects();
			activate_game_objects();
			global.switchingSections = true; // ...but re-enable for the next frame, to avoid any bugs
			
			stateMachine.change_substate(1);
		} else {
			objSystem.camera.active = true;
			playerInstance.xspeed.value = playerXSpeedCache;
			playerInstance.yspeed.value = playerYSpeedCache;
			
			instance_destroy();
		}
	}
});

#endregion

#region Modifiers (before Transition)

stateMachine.add_state("FixCameraIn", {
	enter: function(_prevState) {
        alignmentFixXDir = ((x < targetSection.left) - (x + GAME_WIDTH > targetSection.right)) * isVerticalTransition;
		alignmentFixYDir = ((y < targetSection.top) - (y + GAME_HEIGHT > targetSection.bottom)) * !isVerticalTransition;
		xspeed.value = alignmentFixSpeed * alignmentFixXDir;
		yspeed.value = alignmentFixSpeed * alignmentFixYDir;
		xstart = (alignmentFixXDir > 0) ? targetSection.left : (targetSection.right - GAME_WIDTH);
		ystart = (alignmentFixYDir > 0) ? targetSection.top : (targetSection.bottom - GAME_HEIGHT);
		
		if (alignmentFixXDir == 0 && alignmentFixYDir == 0)
			stateMachine.pop_state();
	},
	tick: function(_substate, _timer) {
		event_user(1); // Move Camera
		
		var _finished = isVerticalTransition
			? ((x - xstart) * alignmentFixXDir >= 0)
			: ((y - ystart) * alignmentFixYDir >= 0);
		if (_finished)
			stateMachine.pop_state();
	}
});
stateMachine.add_state("BossDoorOpen", {
	enter: function(_prevState) {
        if (instance_exists(bossDoor)) {
			var _targetX = isVerticalTransition ? playerInstance.x : bbox_horizontal(transitionXDir, bossDoor) + borderDistance * transitionXDir,
				_targetY = !isVerticalTransition ? playerInstance.y : bbox_vertical(transitionYDir, bossDoor) + borderDistance * transitionYDir;
			playerMoveXSpeed = (_targetX - playerInstance.x) / scrollDuration;
			playerMoveYSpeed = (_targetY - playerInstance.y) / scrollDuration;
        } else {
			stateMachine.pop_state();
        }
	},
	tick: function(_substate, _timer) {
		with (bossDoor)
			event_user(0);
		if (bossDoor.isOpen)
			stateMachine.pop_state();
	},
	leave: function(_newState) {
		with (bossDoor)
			doorOpener.clear_fractional();
	}
});

#endregion

#region Modifiers (after Transition)

stateMachine.add_state("FixCameraOut", {
	enter: function(_prevState) {
        var _prevSection = global.section;
		global.section = targetSection;
		objSystem.camera.active = true;
		objSystem.camera.stepEnd();
        alignmentFixXDir = ((x < gameViewRef.xView) - (x + GAME_WIDTH > gameViewRef.right_edge())) * isVerticalTransition;
		alignmentFixYDir = ((y < gameViewRef.yView) - (y + GAME_HEIGHT > gameViewRef.bottom_edge())) * !isVerticalTransition;
		objSystem.camera.active = false;
		global.section = _prevSection;
		
		xstart = gameViewRef.xView;
		ystart = gameViewRef.yView;
		xspeed.value = alignmentFixSpeed * alignmentFixXDir;
		yspeed.value = alignmentFixSpeed * alignmentFixYDir;
		gameViewRef.set_position(x, y);
		
		if (alignmentFixXDir == 0 && alignmentFixYDir == 0)
			stateMachine.pop_state();
	},
	tick: function(_substate, _timer) {
		event_user(1); // Move Camera
		
		var _finished = isVerticalTransition
			? ((x - xstart) * alignmentFixXDir >= 0)
			: ((y - ystart) * alignmentFixYDir >= 0);
		if (_finished)
			stateMachine.pop_state();
	}
});
stateMachine.add_state("BossDoorClose", {
	enter: function(_prevState) {
        if (!instance_exists(bossDoor))
			stateMachine.pop_state();
	},
	tick: function(_substate, _timer) {
		with (bossDoor)
			event_user(1);
		if (!bossDoor.isOpen)
			stateMachine.pop_state();
	},
	leave: function(_newState) {
		with (bossDoor)
			doorOpener.clear_fractional();
	}
});

#endregion