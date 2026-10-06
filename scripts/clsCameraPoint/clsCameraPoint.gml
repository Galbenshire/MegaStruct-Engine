/// @func CameraPoint(owner, add_to_system)
/// @desc Represents a camera point, used to determine the position of the game camera
///       This is the simplest version; it just follows its owner around
///
/// @param {instance}  [owner]  The owner of this camera point. Defaults to the calling instance.
/// @param {bool}  [add_to_system]  Whether this point should be added to the camera system right away. Defaults to true.
function CameraPoint(_owner = other.id, _addToSystem = true) constructor {
    #region Variables
    
    owner = _owner; /// @is {instance}
    active = true;
    
    x = owner.x;
    y = owner.y;
    
    offsetX = 0;
    offsetY = 0;
    
    #endregion
    
    #region Functions
    
    /// @method add_to_camera_system()
	/// @desc Adds this camera point to the game's camera system
    static add_to_camera_system = function() {
        array_push(objSystem.camera.points, self);
    };
    
    /// @method draw()
	/// @desc Draws a visual representation of this camera point (Intended for debugging)
    static draw = function() {
        draw_sprite_ext(sprEnemyBullet, 0, x, y, 1, 1, 0, c_fuchsia, 0.5);
    };
    
    /// @method on_tick()
	/// @desc Runs this camera point's "step" code
    static on_tick = function() {
        if (instance_exists(owner)) {
            x = owner.x + offsetX;
            y = owner.y + offsetY;
        }
    };
    
    /// @method remove_from_camera_system()
	/// @desc Removes this camera point from the game's camera system
    static remove_from_camera_system = function() {
        var _index = array_get_index(objSystem.camera.points, self);
        if (_index != NOT_FOUND)
            array_delete(objSystem.camera.points, _index, 1);
    };
    
    /// @method reset()
	/// @desc Resets various variables
    static reset = function() {
        offsetX = 0;
        offsetY = 0;
        
        if (instance_exists(owner)) {
            x = owner.x;
            y = owner.y;
        }
    };
    
    #endregion
    
    #region Initialization
    
    if (_addToSystem)
        self.add_to_camera_system();
    
    #endregion
}

/// @func CameraPoint_Player(owner, add_to_system)
/// @desc Version of CameraPoint specifically for player entities
///
/// @param {prtPlayer}  [owner]  The owner of this camera point. Defaults to the calling instance.
/// @param {bool}  [add_to_system]  Whether this point should be added to the camera system right away. Defaults to true.
function CameraPoint_Player(_owner = other.id, _addToSystem = true) : CameraPoint(_owner, _addToSystem) constructor {
	offsetY = 0;
	
	followMode = 0; // 0 = Fixed; 1 = SMW-Styled;
	phase = 0;
	
    /// @method on_tick()
	/// @desc Runs this camera point's "step" code
    static on_tick = function() {
        if (!instance_exists(owner))
            return;
        
        // Follow the player
        switch (followMode) {
			case 1: self.follow_mode_smw(); break;
			default: self.follow_mode_fixed(); break;
        }
    };
    
    /// @method draw()
	/// @desc Draws a visual representation of this camera point (Intended for debugging)
    static draw = function() {
        draw_sprite_ext(sprEnemyBullet, 0, x, y, 1, 1, 0, c_fuchsia, 0.5);
        draw_text_transformed(x, y - 8, phase, 0.5, 0.5, 0);
    };
    
    /// @method follow_mode_fixed()
	/// @desc Follows the player exactly
    static follow_mode_fixed = function() {
		x = entity_x(owner) + offsetX;
		y = entity_y(owner) + offsetY;
    };
    
    /// @method follow_mode_smw()
	/// @desc Follows the player in a manner similar to Super Mario World
    static follow_mode_smw = function() {
		// Horizontal
		x = entity_x(owner) + offsetX;
		
		// Vertical
		switch (phase) {
			case 0: // Only follow if the player is on the ground (or climbing)
				if (owner.ground || owner.isClimbing || owner.y + offsetY > y) {
					y = owner.y + offsetY;
				} else {
					phase = 1;
				}
				break;
			
			case 1: // Wait for the player to hit ground
				if (owner.y + offsetY > y)
					phase = 0;
				else if (owner.ground || owner.isClimbing)
					phase = 2;
				break;
			
			case 2: // Scroll with the player
				var _diff = (owner.y + offsetY) - y;
				
				if (abs(_diff) <= 4) {
					phase = 0;
				} else {
					_diff = clamp(_diff, -4, 4);
					y += _diff;
				}
				break;
		}
    };
}
