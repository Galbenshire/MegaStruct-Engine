/// @description State Machine Init
stateMachine.add_state("TeleportIn", {
	enter: function() {
		sprite_index = sprRushTeleport;
		y = game_view().center_y(false) - ((GAME_HEIGHT / 2) * gravDir);
		gravEnabled = false;
		collideWithSolids = false;
		yspeed = teleportSpeed * gravDir;
		teleportIndex = 0;
	},
	tick: function(_substate) {
		if (_substate == 0) { // Moving down
			var _distToYStart = (ystart - entity_y()) * gravDir;
			if (_distToYStart <= 0 && !check_for_solids(x, y)) {
				collideWithSolids = true;
				stateMachine.change_substate(1);
			}
		} else if (_substate >= 2) { // Teleport Animation
			teleportIndex += 1/3;
			if (teleportIndex < teleportFrameCount)
				image_index = teleportFrames[floor(teleportIndex)];
			else
				stateMachine.change_state("Idle");
		}
	},
	posttick: function(_substate) {
		if (_substate == 1 && ycoll != 0) {
			stateMachine.change_substate(1);
			play_sfx(sfxTeleportIn);
		}
	},
	leave: function() {
		sprite_index = characterSpecs.get_sprite(PlayerSpriteType.COIL);
		image_index = 0;
		gravEnabled = true;
		collideWithSolids = true;
	}
});
stateMachine.add_state("Idle", {
	enter: function() {
		ground = true;
		entity_check_ground(2);
	},
	tick: function(_substate, _timer) {
		if (_substate == 0) { // Not Coiled Yet
			tailWagTimer += tailWagSpeed;
			if (tailWagTimer >= 2)
				tailWagTimer -= 2;
			image_index = tailWagTimer;
			
			var _spring = false;
			with (prtPlayer) {
				if (entity_is_dead() || !gravEnabled || !collideWithSolids)
					continue;
				if (yspeed * gravDir <= 0 || isClimbing)
					continue;
				if (place_meeting(x, y, other.id) && !place_meeting(x, y - yspeed, other.id)) {
					yspeed = -other.launchSpeed * gravDir;
					canMinJump = false;
					ladderInstance = noone;
					_spring = true;
					break;
				}
			}
			
			if (_spring) {
				stateMachine.change_substate(1);
				image_index = 2;
				
				if (!is_undefined(weapon)) {
					weapon.change_ammo(-ammoCost);
					if (instance_exists(owner))
						owner.hudElement.weaponAmmo = weapon.ammo;
				}
			} else if (_timer >= lifeDuration) {
				stateMachine.change_state("TeleportOut");
			}
		} else { // Coiled
			image_index = 2;
			if (_timer >= 60)
				stateMachine.change_state("TeleportOut");
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
		gravEnabled = false;
		collideWithSolids = false;
		teleportIndex = teleportFrameCount;
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