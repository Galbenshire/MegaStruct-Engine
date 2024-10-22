/// @description Post Tick
event_inherited();

if (stateMachine.get_current_state() == "Dying")
	exit;

tailTimer++;
if (tailTimer > 75 && tailTimer mod 4 == 0) {
	tailImgIndex = !tailImgIndex;
} else if (tailTimer >= 100) {
	tailTimer = 0;
	tailImgIndex = 0;
}

if (animator.flag == "shoot")
    shootFlag = true;
