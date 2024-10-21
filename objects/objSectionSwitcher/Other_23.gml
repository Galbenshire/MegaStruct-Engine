/// @description State Machine Init
with (stateMachine.add("_DeferPause")) {
	set_event("enter", function() {
		global.switchingSections = true;
		queue_pause();
	});
	set_event("tick", function() {
		if (global.paused)
			stateMachine.change_state("Init");
	});
}
with (stateMachine.add("Init")) {
	set_event("enter", function() {
		assert(instance_exists(playerInstance), "Did you forget to link the player to the section switcher?");
        assert(instance_exists(transitionInstance), "Did you forget to link the transition to the section switcher?");
        targetSection = transitionInstance.section;
        
        // Calculate the direction of the transition
        var _directionDiv = transitionInstance.image_angle div 90;
        isVerticalTransition = bool(_directionDiv & 1);
		transitionXDir = (1 - _directionDiv) * !isVerticalTransition;
		transitionYDir = (_directionDiv - 2) * isVerticalTransition;
		
		// Calculate screen scrolling parameters
		var _scrollLength = isVerticalTransition ? GAME_HEIGHT : GAME_WIDTH,
			_scrollSpeed = _scrollLength / scrollDuration;
		screenScrollXSpeed = _scrollSpeed * transitionXDir;
		screenScrollYSpeed = _scrollSpeed * transitionYDir;
		
		// Calculate player movement parameters
		var _targetX = isVerticalTransition ? playerInstance.x : bbox_horizontal(-transitionXDir, targetSection) + borderDistance * transitionXDir,
			_targetY = !isVerticalTransition ? playerInstance.y : bbox_vertical(-transitionYDir, targetSection) + borderDistance * transitionYDir;
		playerMoveXSpeed = (_targetX - playerInstance.x) / scrollDuration;
		playerMoveYSpeed = (_targetY - playerInstance.y) / scrollDuration;
		
		// Activate objects in the new section
		activate_game_objects(targetSection);
		
		// Move the switcher to the camera position (for convienience)
		// (and also disable the camera)
		x = gameViewRef.xView;
		y = gameViewRef.yView;
		objSystem.camera.active = false;
		
		// Reset player palette
		playerInstance.refresh_palette();
	});
	set_event("tick", function() {
		// Deactivate objects not visible during screen transitions
        deactivate_game_objects(true, targetSection);
        
        // Check if a misalignment needs to be fixed
        alignmentFixXDir = ((x < targetSection.left) - (x + GAME_WIDTH > targetSection.right)) * isVerticalTransition;
		alignmentFixYDir = ((y < targetSection.top) - (y + GAME_HEIGHT > targetSection.bottom)) * !isVerticalTransition;
		
		if (instance_exists(bossDoor))
			stateMachine.change_state("OpenDoor");
		else if (alignmentFixXDir != 0 || alignmentFixYDir != 0)
			stateMachine.change_state("FixAlignmentToSection");
		else
			stateMachine.change_state("ToNewSection");
	});
	set_event("leave", function() {
		playerXSpeedCache = playerInstance.xspeed.value;
		playerYSpeedCache = playerInstance.yspeed.value;
	});
}
with (stateMachine.add("OpenDoor")) {
	set_event("tick", function() {
		with (bossDoor)
			event_user(0);
		
		if (bossDoor.isOpen) {
			if (alignmentFixXDir != 0 || alignmentFixYDir != 0)
				stateMachine.change_state("FixAlignmentToSection");
			else
				stateMachine.change_state("ToNewSection");
		}
	});
	set_event("leave", function() {
		bossDoor.doorOpener.clear_fractional();
		
		// Recalculate player movement parameters
		var _targetX = isVerticalTransition ? playerInstance.x : bbox_horizontal(transitionXDir, bossDoor) + borderDistance * transitionXDir,
			_targetY = !isVerticalTransition ? playerInstance.y : bbox_vertical(transitionYDir, bossDoor) + borderDistance * transitionYDir;
		playerMoveXSpeed = (_targetX - playerInstance.x) / scrollDuration;
		playerMoveYSpeed = (_targetY - playerInstance.y) / scrollDuration;
	});
}
with (stateMachine.add("FixAlignmentToSection")) {
	set_event("enter", function() {
		xspeed.value = alignmentFixSpeed * alignmentFixXDir;
		yspeed.value = alignmentFixSpeed * alignmentFixYDir;
	});
	set_event("tick", function() {
		event_user(0);
		
		var _finished = isVerticalTransition
			? (alignmentFixXDir > 0 && x >= targetSection.left) || (alignmentFixXDir < 0 && x + GAME_WIDTH <= targetSection.right)
			: (alignmentFixYDir > 0 && y >= targetSection.top) || (alignmentFixYDir < 0 && y + GAME_HEIGHT <= targetSection.bottom);
		
		if (_finished)
			stateMachine.change_state("ToNewSection");
	});
	set_event("leave", function() {
		if (isVerticalTransition)
			x = clamp(x, targetSection.left, targetSection.right - GAME_WIDTH);
		else
			y = clamp(y, targetSection.top, targetSection.bottom - GAME_HEIGHT);
	});
}
with (stateMachine.add("ToNewSection")) {
	set_event("enter", function() {
		xspeed.value = screenScrollXSpeed;
		yspeed.value = screenScrollYSpeed;
		playerInstance.xspeed.value = playerMoveXSpeed;
		playerInstance.yspeed.value = playerMoveYSpeed;
		
		animatePlayer = array_contains(persistentAnimations, playerInstance.animator.currentAnimationName)
			&& !playerInstance.is_action_locked(PlayerAction.SPRITE_CHANGE);
	});
	set_event("tick", function() {
		if (stateMachine.timer < scrollDuration) {
			event_user(0);
			event_user(1);
			return;
		}
		
		global.section = targetSection;
		
		// Check if a misalignment needs to be fixed
		objSystem.camera.active = true;
		objSystem.camera.stepEnd();
        alignmentFixXDir = ((x < gameViewRef.xView) - (x + GAME_WIDTH > gameViewRef.right_edge())) * isVerticalTransition;
		alignmentFixYDir = ((y < gameViewRef.yView) - (y + GAME_HEIGHT > gameViewRef.bottom_edge())) * !isVerticalTransition;
		objSystem.camera.active = false;
		xstart = gameViewRef.xView;
		ystart = gameViewRef.yView;
		gameViewRef.set_position(x, y);
		
		if (instance_exists(bossDoor))
			stateMachine.change_state("CloseDoor");
		else if (alignmentFixXDir != 0 || alignmentFixYDir != 0)
			stateMachine.change_state("FixAlignmentToCamera");
		else
			stateMachine.change_state("_End");
	});
	set_event("leave", function() {
		xspeed.value = 0;
		yspeed.value = 0;
		animatePlayer = false;
	});
}
with (stateMachine.add("CloseDoor")) {
	set_event("tick", function() {
		with (bossDoor)
			event_user(1);
		
		if (!bossDoor.isOpen) {
			if (alignmentFixXDir != 0 || alignmentFixYDir != 0)
				stateMachine.change_state("FixAlignmentToCamera");
			else
				stateMachine.change_state("_End");
		}
	});
	set_event("leave", function() /*=>*/ { bossDoor.doorOpener.clear_fractional(); });
}
with (stateMachine.add("FixAlignmentToCamera")) {
	set_event("enter", function() {
		xspeed.value = alignmentFixSpeed * alignmentFixXDir;
		yspeed.value = alignmentFixSpeed * alignmentFixYDir;
	});
	set_event("tick", function() {
		event_user(0);
		
		var _finished = isVerticalTransition
			? (alignmentFixXDir > 0 && x >= xstart) || (alignmentFixXDir < 0 && x <= xstart)
			: (alignmentFixYDir > 0 && y >= ystart) || (alignmentFixYDir < 0 && y <= ystart);
		
		if (_finished)
			stateMachine.change_state("_End");
	});
}
with (stateMachine.add("_End")) {
	set_event("enter", function() {
		global.section = targetSection;
		global.switchingSections = false;
		deactivate_game_objects();
	});
	set_event("tick", function() {
		playerInstance.xspeed.value = playerXSpeedCache;
		playerInstance.yspeed.value = playerYSpeedCache;
		objSystem.camera.active = true;
		
		activate_game_objects();
		queue_unpause();
		instance_destroy();
	});
}

stateMachine.change_state("_DeferPause");