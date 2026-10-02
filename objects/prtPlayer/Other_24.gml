/// @description Entity Tick
xDir = self.is_input_held(InputActions.RIGHT) - self.is_input_held(InputActions.LEFT);
yDir = self.is_input_held(InputActions.DOWN) - self.is_input_held(InputActions.UP);

if (coyoteTimer > 0)
	coyoteTimer--;
	
if (jumpBufferTimer > 0)
	jumpBufferTimer--;
if (self.is_input_pressed(InputActions.JUMP))
	jumpBufferTimer = JUMP_BUFFER;

stateMachine.tick();