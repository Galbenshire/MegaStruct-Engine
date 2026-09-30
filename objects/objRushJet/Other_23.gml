/// @description State Machine Init
stateMachine.add_state("TeleportIn", {
	enter: function() {
		sprite_index = sprRushTeleport;
		y = game_view().center_y(false) - ((GAME_HEIGHT / 2) * gravDir);
		collideWithSolids = false;
		solidType = SolidType.NOT_SOLID;
		yspeed = teleportSpeed * gravDir;
		teleportIndex = 0;
	},
	tick: function(_substate) {
		if (_substate == 0) { // Moving down
			if (instance_exists(owner))
				ystart = owner.y + 6;
			
			var _distToYStart = (ystart - entity_y()) * gravDir;
			if (_distToYStart <= 0 && !check_for_solids(x, y)) {
				play_sfx(sfxTeleportIn);
				stateMachine.change_substate(1);
				yspeed = 0;
			}
		} else { // Teleport Animation
			teleportIndex += 1/3;
			if (teleportIndex < teleportFrameCount)
				image_index = teleportFrames[floor(teleportIndex)];
			else
				stateMachine.change_state("Idle");
		}
	},
	leave: function() {
		sprite_index = characterSpecs.get_sprite(PlayerSpriteType.JET);
		image_index = 0;
		collideWithSolids = true;
		solidType = SolidType.TOP_SOLID;
	}
});
stateMachine.add_state("Idle", {
	tick: function(_substate, _timer) {
		if (instance_exists(owner) && owner.ground && owner.groundInstance == self.id) {
			stateMachine.change_state("Takeoff");
			return;
		}
		if (_timer >= idleDuration)
			stateMachine.change_state("TeleportOut");
	}
});
stateMachine.add_state("Takeoff", {
	tick: function(_substate, _timer) {
		var _playerExists = instance_exists(owner);
		
		if (!is_undefined(weapon)) {
			if (_playerExists) {
				weapon.change_ammo(-ammoDrain);
				owner.hudElement.weaponAmmo = weapon.ammo;
			} else {
				weapon.change_ammo(-ammoDrain);
			}
		}
		
		xspeed = jetXSpeed * image_xscale;
		yspeed = 0;
		
		if (!_playerExists)
			return;
		if (owner.ground && owner.groundInstance == self.id) {
			jetLock.activate();
			
			yspeed = jetYSpeed * owner.yDir;
			if (sign(yspeed) == -image_yscale) {
				var _headCheckRange = floor(jetYSpeed + bbox_height(owner)) + 1;
				if (test_move_y(-_headCheckRange))
					yspeed = 0;
			}
			
			if (owner.xDir == -image_xscale) {
				xspeed *= pullbackFactor;
				yspeed *= pullbackFactor;
			}
		} else {
			jetLock.deactivate();
		}
	}
});
stateMachine.add_state("TeleportOut", {
	enter: function() {
		if (characterSpecs.id == CharacterType.PROTO) {
			entity_kill_self();
			return;
		}
		
		sprite_index = sprRushTeleport;
		image_index = array_at(teleportFrames, -1);
		collideWithSolids = false;
		solidType = SolidType.NOT_SOLID;
		teleportIndex = teleportFrameCount;
		jetLock.deactivate();
		play_sfx(sfxTeleportOut);
	},
	tick: function(_substate) {
		if (_substate != 0)
			return;
		
		teleportIndex -= 1/3;
		if (floor(teleportIndex) > 0) {
			image_index = teleportFrames[floor(teleportIndex)];
		} else {
			image_index = 0;
			stateMachine.change_substate(1);
			yspeed = -teleportSpeed * gravDir;
		}
	},
});