/// @description State Machine Init
event_inherited();

with (stateMachine.add("Main")) {
	set_event("enter", function() {
		tailTimer = 0;
		tailImgIndex = 0;
		animator.play("main", true);
	});
	set_event("tick", function() {
		switch (stateMachine.substate) {
			case 0: // Awaiting fire flag
				if (shootFlag) {
					fireDuration = choose_from_array(fireDurationList);
					shootFlag = false;
					stateMachine.change_substate(1);
					print($"fire - {fireDuration}", WarningLevel.SHOW);
				}
				break;
			
			case 1: // Fire Breath
				if (stateMachine.timer >= fireDuration) {
					animator.play("main", true);
					stateMachine.change_substate(0);
				}
				break;
		}
	});
}
