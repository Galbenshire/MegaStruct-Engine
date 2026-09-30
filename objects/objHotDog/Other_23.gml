/// @description State Machine Init
event_inherited();

stateMachine.add_state("Main", {
	enter: function(_prevState) {
		tailTimer = 0;
		tailImgIndex = 0;
		animator.play("main", true);
	},
	tick: function(_substate, _timer) {
		switch (_substate) {
			case 0: // Awaiting fire flag
				if (shootFlag) {
					fireDuration = choose_from_array(fireDurationList);
					shootFlag = false;
					stateMachine.change_substate(1);
				}
				break;
			
			case 1: // Fire Breath
				if (_timer mod 4 == 0)
					self.perform_action("fire");
				
				if (_timer >= fireDuration) {
					animator.play("main", true);
					stateMachine.change_substate(0);
				}
				break;
		}
	}
});
stateMachine.add_state("Dying", {
	enter: function(_prevState) {
		hitmaskMaster = 0;
		animator.play("freeze-in-place");
	},
	tick: function(_substate, _timer) {
		if (_timer mod 5 == 0) {
			self.perform_action("death_explode", {
				x: irandom_range(bbox_left, bbox_right),
				y: irandom_range(bbox_top, bbox_bottom)
			});
		}
		
		if (_timer >= 60)
			entity_kill_self();
	}
});