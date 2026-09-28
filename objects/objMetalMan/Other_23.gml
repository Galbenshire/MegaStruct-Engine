/// @description State Machine Init
event_inherited();

// === States ===
// - Idle
// - JumpUp_PreAttack
// - JumpUp_Attack
// - JumpOver

stateMachine.add_state("Idle", {
	enter: function(_prevState) {
        animator.play(position_meeting(x, y, objConveyorBeltArea) ? "walk" : "idle");
        xspeed.value = 0;
        jumpFlag = false;
	},
	tick: function(_substate, _timer) {
		var _centerX = game_view().center_x(),
			_directionToMiddleSelf = sign(x - _centerX),
			_directionToMiddleTarget = sign(reticle.x - _centerX);
		if (_directionToMiddleSelf == _directionToMiddleTarget) {
			stateMachine.change_state("JumpOver");
			return;
		}
		
		if (_timer >= 180 || jumpFlag)
			stateMachine.change_state("JumpUp_PreAttack");
	},
	leave: function(_newState) /*=>*/ { jumpFlag = false; }
});
stateMachine.add_state("JumpUp_PreAttack", {
	enter: function(_prevState) {
        animator.play("jump");
        yspeed.value = -choose(4, 5.66, 6.93);
	},
	tick: function(_substate, _timer) {
		if (yspeed.value >= 0)
			stateMachine.change_state("JumpUp_Attack");
	}
});
stateMachine.add_state("JumpUp_Attack", {
	enter: function(_prevState) /*=>*/ { shootFlag = false; },
	tick: function(_substate, _timer) {
		if (_timer mod 20 == 0)
			animator.play("blade_throw", true);
		
		if (shootFlag) {
			self.create_projectile("metal_blade", 8, 0);
			yspeed.value = min(0.4, yspeed.value);
			shootFlag = false;
		}
	},
	posttick: function(_substate, _timer) {
		if (ground && animator.is_animation_finished())
			stateMachine.change_state("Idle");
	},
	leave: function(_newState) /*=>*/ { shootFlag = false; }
});
stateMachine.add_state("JumpOver", {
	enter: function(_prevState) {
        animator.play("jump");
        yspeed.value = -6.93;
        
        var _centerX = game_view().center_x(),
			_directionToMiddle = sign(x - _centerX),
			_targetX = _centerX - distanceToMiddle * _directionToMiddle;
		xspeed.value = calculate_horizontal_jump_speed(_targetX - x, -yspeed.value, grav);
	},
	tick: function(_substate, _timer) {
		if (_substate == 0 && yspeed.value >= 0) {
			animator.play("blade_throw");
			stateMachine.set_substate(1);
		}
		if (shootFlag) {
			self.create_projectile("metal_blade", 8, 0);
			shootFlag = false;
		}
	},
	posttick: function(_substate, _timer) {
		if (ground)
			stateMachine.change_state("Idle");
	},
	leave: function(_newState) {
		xspeed.value = 0;
		shootFlag = false;
	}
});