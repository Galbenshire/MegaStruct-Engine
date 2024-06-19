/// @description Entity Tick
xDir = inputs.get_axis(InputActions.RIGHT, InputActions.LEFT);
yDir = inputs.get_axis(InputActions.DOWN, InputActions.UP);

if (coyoteTimer > 0)
	coyoteTimer--;
	
if (jumpBufferTimer > 0)
	jumpBufferTimer--;
if (inputs.is_pressed(InputActions.JUMP))
	jumpBufferTimer = JUMP_BUFFER;

stateMachine.tick();