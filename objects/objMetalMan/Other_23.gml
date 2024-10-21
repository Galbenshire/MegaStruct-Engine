/// @description State Machine Init
event_inherited();

// === States ===
// - Idle
// - JumpUp_PreAttack
// - JumpUp_Attack
// - JumpOver

with (stateMachine.add("Idle")) {
	set_event("enter", function() {
        animator.play(position_meeting(x, y, objConveyorBeltArea) ? "walk" : "idle");
        xspeed.value = 0;
        jumpFlag = false;
	});
	set_event("tick", function() {
		var _centerX = game_view().center_x(),
			_directionToMiddleSelf = sign(x - _centerX),
			_directionToMiddleTarget = sign(reticle.x - _centerX);
		if (_directionToMiddleSelf == _directionToMiddleTarget) {
			stateMachine.change_state("JumpOver");
			return;
		}
		
		if (stateMachine.timer >= 180 || jumpFlag)
			stateMachine.change_state("JumpUp_PreAttack");
	});
	set_event("leave", function() {
		jumpFlag = false;
	});
}
with (stateMachine.add("JumpUp_PreAttack")) {
	set_event("enter", function() {
        animator.play("jump");
        yspeed.value = -choose(4, 5.66, 6.93);
	});
	set_event("tick", function() {
		if (yspeed.value >= 0)
			stateMachine.change_state("JumpUp_Attack");
	});
}
with (stateMachine.add("JumpUp_Attack")) {
	set_event("enter", function() {
        shootFlag = false;
	});
	set_event("tick", function() {
		if (stateMachine.timer mod 20 == 0)
			animator.play("blade_throw", true);
		
		if (shootFlag) {
			self.create_projectile("metal_blade", 8, 0);
			yspeed.value = min(0.4, yspeed.value);
			shootFlag = false;
		}
	});
	set_event("posttick", function() {
		if (ground && animator.is_animation_finished())
			stateMachine.change_state("Idle");
	});
	set_event("leave", function() {
		shootFlag = false;
	});
}
// ================================
with (stateMachine.add("JumpOver")) {
	set_event("enter", function() {
        animator.play("jump");
        yspeed.value = -6.93;
        
        var _centerX = game_view().center_x(),
			_directionToMiddle = sign(x - _centerX),
			_targetX = _centerX - distanceToMiddle * _directionToMiddle;
		xspeed.value = calculate_horizontal_jump_speed(_targetX - x, -yspeed.value, grav);
	});
	set_event("tick", function() {
		if (stateMachine.substate == 0 && yspeed.value >= 0) {
			animator.play("blade_throw");
			stateMachine.change_substate(1);
		}
		
		if (shootFlag) {
			self.create_projectile("metal_blade", 8, 0);
			shootFlag = false;
		}
	});
	set_event("posttick", function() {
		if (ground)
			stateMachine.change_state("Idle");
	});
	set_event("leave", function() {
		xspeed.value = 0;
		shootFlag = false;
	});
}
