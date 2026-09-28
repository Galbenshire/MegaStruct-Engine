/// @description State Machine Init
// === The States ===
// - Inactive
// - Whistle
// - TeleportDown
// - ProtoMan
// - TeleportAway

stateMachine.add_state("Inactive", {
	enter: function(_prevState) /*=>*/ { visible = false; },
	tick: function(_substate, _timer) {
        if (!inside_section_point() || !instance_all(prtPlayer, function(el, i) /*=>*/ {return !el.isIntro}))
			return;
		stateMachine.change_state("Whistle");
	}
});
stateMachine.add_state("Whistle", {
	enter: function(_prevState) {
		pause_music();
		play_sfx(whistleSFX);
		encounterLock.activate();
		encounterPauseLock.activate();
		animator.play("teleport-idle");
		
		with (prtPlayer)
			calibrate_direction_point(other.x);
	},
	tick: function(_substate, _timer) {
        if (!audio_is_playing(whistleSFX))
            stateMachine.change_state("TeleportDown");
	}
});
stateMachine.add_state("TeleportDown", {
	enter: function(_prevState) {
		visible = true;
        y = game_view().top_edge(0);
		animator.play("teleport-idle");
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
			stateMachine.change_state("ProtoMan");
		}
	}
});
stateMachine.add_state("ProtoMan", {
	enter: function(_prevState) /*=>*/ { animator.play(idleAnim); },
	tick: function(_substate, _timer) {
        if (_timer >= waitDuration)
            stateMachine.change_state("TeleportAway");
	}
});
stateMachine.add_state("TeleportAway", {
	enter: function(_prevState) {
		resume_music();
        play_sfx(sfxTeleportOut);
		animator.play("teleport-out");
	},
	tick: function(_substate, _timer) {
        if (_timer == triggerDelay && !is_undefined(onEncounterEnd))
            onEncounterEnd();
		
		if (animator.is_animation_finished()) {
            y -= 8;
            if (!inside_view() && _timer > triggerDelay)
                instance_destroy();
		}
	}
});
