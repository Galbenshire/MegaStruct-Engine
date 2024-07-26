/// @description State Machine Init
event_inherited();

// === States ===
// - Idle
// - JumpUp_PreAttack
// - JumpUp_Attack
// - JumpOver

// ================================
stateMachine.add("Idle", {
	enter: function() {
        animator.play(position_meeting(x, y, objConveyorBeltArea) ? "walk" : "idle");
        xspeed.value = 0;
        jumpFlag = false;
	},
	tick: function() {
		var _centerX = game_view().center_x(),
			_directionToMiddleSelf = sign(x - _centerX),
			_directionToMiddleTarget = sign(reticle.x - _centerX);
		if (_directionToMiddleSelf == _directionToMiddleTarget) {
			stateMachine.change("JumpOver");
			return;
		}
		
		if (stateMachine.timer >= 180 || jumpFlag)
			stateMachine.change("JumpUp_PreAttack");
	},
	leave: function() {
		jumpFlag = false;
	}
});
// ================================
stateMachine.add("JumpUp_PreAttack", {
	enter: function() {
        animator.play("jump");
        yspeed.value = -choose(4, 5.66, 6.93);
	},
	tick: function() {
		if (yspeed.value >= 0)
			stateMachine.change("JumpUp_Attack");
	},
});
// ================================
stateMachine.add("JumpUp_Attack", {
	enter: function() {
        shootFlag = false;
	},
	tick: function() {
		if (stateMachine.timer mod 20 == 0)
			animator.play("blade_throw", true);
		
		if (shootFlag) {
			with (spawn_entity(x + 8 * image_xscale, y, depth, objGenericEnemyBullet)) {
				sprite_index = sprMetalBlade;
				owner = other.id;
				animSpeed = 0.35;
				contactDamage = 3;
				xspeed.value = 4 * other.image_xscale;
				set_velocity_vector(4, point_direction(x, y, reticle.x, reticle.y));
			}
			
			play_sfx(sfxMetalBlade);
			yspeed.value = min(0.4, yspeed.value);
			shootFlag = false;
		}
	},
	posttick: function() {
		if (ground && animator.is_animation_finished())
			stateMachine.change("Idle");
	},
	leave: function() {
		shootFlag = false;
	}
});
// ================================
stateMachine.add("JumpOver", {
	enter: function() {
        animator.play("jump");
        yspeed.value = -6.93;
        
        var _centerX = game_view().center_x(),
			_directionToMiddle = sign(x - _centerX),
			_targetX = _centerX - distanceToMiddle * _directionToMiddle;
		xspeed.value = calculate_horizontal_jump_speed(_targetX - x, -yspeed.value, grav);
	},
	tick: function() {
		if (stateMachine.substate == 0 && yspeed.value >= 0) {
			animator.play("blade_throw");
			stateMachine.change_substate(1);
		}
		
		if (shootFlag) {
			with (spawn_entity(x + 8 * image_xscale, y, depth, objGenericEnemyBullet)) {
				sprite_index = sprMetalBlade;
				owner = other.id;
				animSpeed = 0.35;
				contactDamage = 3;
				xspeed.value = 4 * other.image_xscale;
				set_velocity_vector(4, point_direction(x, y, reticle.x, reticle.y));
			}
			
			play_sfx(sfxMetalBlade);
			shootFlag = false;
		}
	},
	posttick: function() {
		if (ground)
			stateMachine.change("Idle");
	},
	leave: function() {
		xspeed.value = 0;
		shootFlag = false;
	}
});