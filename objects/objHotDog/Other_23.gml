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
				}
				break;
			
			case 1: // Fire Breath
				if (stateMachine.timer mod 4 == 0)
					create_projectile("fire", 16, 0);
				
				if (stateMachine.timer >= fireDuration) {
					animator.play("main", true);
					stateMachine.change_substate(0);
				}
				break;
		}
	});
}
with (stateMachine.add("Dying")) {
	set_event("enter", function() {
		canDealDamage = false;
		canTakeDamage = false;
		animator.play("freeze-in-place");
	});
	set_event("tick", function() {
		if (stateMachine.timer mod 5 == 0)
			create_projectile("death_explode", irandom_range(bbox_left, bbox_right), irandom_range(bbox_top, bbox_bottom));
		
		if (stateMachine.timer >= 60)
			entity_kill_self();
	});
}