/// @description State Machine Init
// === The States ===
// - Inactive
// - Whistle
// - TeleportDown
// - ProtoMan
// - TeleportAway

with (stateMachine.add("Inactive")) {
	set_event("enter", function() /*=>*/ { visible = false;	});
	set_event("tick", function() {
        if (!inside_section_point() || !instance_all(prtPlayer, function(el, i) /*=>*/ {return !el.isIntro}))
            return;
		stateMachine.change_state("Whistle");
	});
}
with (stateMachine.add("Whistle")) {
	set_event("enter", function() {
		pause_music();
		play_sfx(whistleSFX);
		encounterLock.activate();
		encounterPauseLock.activate();
		animator.play("teleport-idle");
		
		with (prtPlayer)
		    calibrate_direction_point(other.x);
	});
	set_event("tick", function() {
        if (!audio_is_playing(whistleSFX))
            stateMachine.change_state("TeleportDown");
	});
}
with (stateMachine.add("TeleportDown")) {
	set_event("enter", function() {
        visible = true;
        y = game_view().top_edge(0);
		animator.play("teleport-idle");
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
			stateMachine.change_state("ProtoMan");
		}
	});
}
with (stateMachine.add("ProtoMan")) {
	set_event("enter", function() /*=>*/ { animator.play((whistleSFX == sfxProtoWhistleBad) ? "idle-scarfless" : "idle"); });
	set_event("tick", function() {
        if (stateMachine.timer >= waitDuration)
            stateMachine.change_state("TeleportAway");
	});
}
with (stateMachine.add("TeleportAway")) {
	set_event("enter", function() {
		resume_music();
        play_sfx(sfxTeleportOut);
		animator.play("teleport-out");
	});
	set_event("tick", function() {
        if (stateMachine.timer == triggerDelay && !is_undefined(onEncounterEnd))
            onEncounterEnd();
		
		if (animator.is_animation_finished()) {
            y -= 8;
            if (!inside_view() && stateMachine.timer > triggerDelay)
                instance_destroy();
		}
	});
}

stateMachine.change_state("Inactive");
