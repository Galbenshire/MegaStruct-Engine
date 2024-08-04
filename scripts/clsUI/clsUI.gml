function UIMenu() constructor {
	#region Variables
	
    owner = other.id; /// @is {instance}
    
    inputs = global.player.inputs; /// @is {InputMap}
    confirmButtons = [InputActions.PAUSE, InputActions.JUMP];
    cancelButtons = [InputActions.SHOOT];
    
    xDir = 0;
    yDir = 0;
    isConfirmed = false;
    isCanceled = false;
    
    submenus = {}; /// @is {struct}
    currentSubmenu = undefined; /// @is {UISubmenu?}
    previousSubmenu = undefined; /// @is {UISubmenu?}
    defaultSubmenu = undefined; /// @is {UISubmenu?}
    canChangeSubmenu = true;
    
    #endregion
    
    #region Functions - Managing UI Submenus
    
    /// @method add_submenu(name)
	/// @desc Creates a new UISubmenu for this submenu
    static add_submenu = function(_name) {
        submenus[$ _name] = new UISubmenu();
        return submenus[$ _name];
    };
    
    /// @method pass_submenu_focus(new_submenu)
	/// @desc Changes focus from the current UISubmenu to the specified one
    static pass_submenu_focus = function(_newSubmenu) {
        if (!is_undefined(currentSubmenu))
			currentSubmenu.release_focus();
		if (!is_undefined(_newSubmenu))
			_newSubmenu.gain_focus();
    };
    
    #endregion
    
    #region Functions - Other
    
    static check_inputs = function() {
		xDir = inputs.is_pressed(InputActions.RIGHT) - inputs.is_pressed(InputActions.LEFT);
        yDir = inputs.is_pressed(InputActions.DOWN) - inputs.is_pressed(InputActions.UP);
        if (xDir != 0 && yDir != 0) {
            xDir = 0;
            yDir = 0;
        }
        
        isConfirmed = inputs.is_any_pressed_ext(confirmButtons);
        isCanceled = inputs.is_any_pressed_ext(cancelButtons);
    };
    
    /// @method update()
	/// @desc Updates the menu
    static update = function() {
        check_inputs();
        
		if (canChangeSubmenu) {
			var _nextSubmenu = currentSubmenu.get_neighbour(xDir, yDir);
			if (!is_undefined(_nextSubmenu)) {
				pass_submenu_focus(_nextSubmenu);
				return;
			}
		}
		
		currentSubmenu.update();
    };
    
    #endregion
}

function UISubmenu() constructor {
    assert(is_instanceof(other, UIMenu), "UISubmenu should only be created by UIMenu (use add_submenu())");
    
    #region Variables
    
    menu = other; /// @is {UIMenu}
    owner = menu.owner; /// @is {instance}
    
    items = {}; /// @is {struct}
    currentItem = undefined; /// @is {UIItem?}
    previousItem = undefined; /// @is {UIItem?}
    defaultItem = undefined; /// @is {UIItem?}
    canChangeItem = true;
    
    // Neighbours - where to pass focus depending on direction
    neighbourLeft = undefined; /// @is {UISubmenu?}
    neighbourRight = undefined; /// @is {UISubmenu?}
    neighbourTop = undefined; /// @is {UISubmenu?}
    neighbourBottom = undefined; /// @is {UISubmenu?}
    
    #endregion
    
    #region Callbacks
    
    onFocusEnter = undefined; /// @is {function<void>} Called when this submenu gains focus
    onFocusLeave = undefined; /// @is {function<void>} Called when this submenu loses focus
    onTick = undefined; /// @is {function<InputMap, bool>} Called every frame while this submenu has focus
    
    #endregion
    
    #region Functions - Focus
    
    /// @method gain_focus()
	/// @desc Sets this submenu as the current submenu in its menu
    static gain_focus = function() {
		menu.currentSubmenu = self;
		if (!is_undefined(onFocusEnter))
			onFocusEnter();
		
		var _item = currentItem ?? defaultItem;
		if (!is_undefined(_item))
			_item.gain_focus();
    };
    
    /// @method is_focused()
	/// @desc Checks if this submenu currently has focus in its menu
	///
	/// @returns {bool}  If it has focus (true) or not (false)
    static is_focused = function() {
        return menu.currentSubmenu == self;
    };
    
    /// @method release_focus()
	/// @desc Unsets this submenu as the current submenu in its menu
    static release_focus = function() {
		if (!is_undefined(currentItem))
			currentItem.release_focus();
		
		if (!is_undefined(onFocusLeave))
			onFocusLeave();
		menu.currentSubmenu = undefined;
		menu.previousSubmenu = self;
    };
    
    #endregion
    
    #region Functions - Managing UI Items
    
    /// @method add_item(name)
	/// @desc Creates a new UIItem for this submenu
    static add_item = function(_name) {
        items[$ _name] = new UIItem();
        return items[$ _name];
    };
    
    /// @method pass_item_focus(new_item)
	/// @desc Changes focus from the current UIItem to the specified one
    static pass_item_focus = function(_newItem) {
		var _prevItem = currentItem;
		
		if (!is_undefined(currentItem))
			currentItem.release_focus();
		if (!is_undefined(_newItem))
			_newItem.gain_focus();
		
		if (currentItem != _prevItem)
			play_sfx(sfxMenuMove);
    };
    
    #endregion
    
    #region Functions - Other
    
    /// @method get_neighbour(x_dir, y_dir)
	/// @desc Gets this submenu's neighbour, using the given direction
    static get_neighbour = function(_xDir, _yDir) {
		if (!is_undefined(currentItem)) {
			if (is_undefined(currentItem.get_neighbour(_xDir, _yDir)))
				return undefined;
		}
		
		if (_xDir != 0)
            return (_xDir < 0) ? neighbourLeft : neighbourRight;
		if (_yDir != 0)
            return (_yDir < 0) ? neighbourTop : neighbourBottom;
        
		return undefined;
    };
    
    /// @method update()
	/// @desc Updates this submenu
    static update = function() {
		if (!is_undefined(onTick)) {
			var _terminate = onTick(menu.inputs) ?? false;
			if (_terminate)
				return;
		}
		
        if (is_undefined(currentItem))
            return;
        
		if (canChangeItem) {
			var _nextItem = currentItem.get_neighbour(menu.xDir, menu.yDir);
			if (!is_undefined(_nextItem)) {
				pass_item_focus(_nextItem);
				return;
			}
		}
        
        currentItem.update();
    };
    
    #endregion
}

function UIItem() constructor {
    assert(is_instanceof(other, UISubmenu), "UIItem should only be created by UISubmenu (use add_item())");
    
    #region Variables
    
    submenu = other; /// @is {UISubmenu}
    menu = submenu.menu; /// @is {UIMenu}
    owner = submenu.owner; /// @is {instance}
    
    // Neighbours - where to pass focus depending on direction
    neighbourLeft = undefined; /// @is {UIItem?}
    neighbourRight = undefined; /// @is {UIItem?}
    neighbourTop = undefined; /// @is {UIItem?}
    neighbourBottom = undefined; /// @is {UIItem?}
    
    #endregion
    
    #region Callbacks
    
    onFocusEnter = undefined; /// @is {function<void>}
    onFocusLeave = undefined; /// @is {function<void>}
    onTick = undefined; /// @is {function<InputMap, bool>}
    onXDir = undefined; /// @is {function<int, void>}
    onYDir = undefined; /// @is {function<int, void>}
    onConfirm = undefined; /// @is {function<void>}
    onCancel = undefined; /// @is {function<void>}
    
    #endregion
    
    #region Functions - Focus
    
    /// @method gain_focus()
	/// @desc Sets this item as the current item in its submenu
    static gain_focus = function() {
		submenu.currentItem = self;
		if (!is_undefined(onFocusEnter))
			onFocusEnter();
    };
    
    /// @method is_focused()
	/// @desc Checks if this item currently has focus in its submenu
	///
	/// @returns {bool}  If it has focus (true) or not (false)
    static is_focused = function() {
        return submenu.currentItem == self;
    };
    
    /// @method release_focus()
	/// @desc Unsets this item as the current item in its submenu
    static release_focus = function() {
		if (!is_undefined(onFocusLeave))
			onFocusLeave();
		submenu.currentItem = undefined;
		submenu.previousItem = self;
    };
    
    #endregion
    
    #region Functions - Other
    
    /// @method get_neighbour(x_dir, y_dir)
	/// @desc Gets this item's neighbour, using the given direction
    static get_neighbour = function(_xDir, _yDir) {
		if (_xDir != 0)
            return (_xDir < 0) ? neighbourLeft : neighbourRight;
		if (_yDir != 0)
            return (_yDir < 0) ? neighbourTop : neighbourBottom;
		return undefined;
    };
    
    /// @method update()
	/// @desc Updates this item
    static update = function() {
		if (!is_undefined(onTick)) {
			var _terminate = onTick(menu.inputs) ?? false;
			if (_terminate)
				return;
		}
		
		if (menu.isConfirmed && !is_undefined(onConfirm))
			onConfirm();
		else if (menu.isCanceled && !is_undefined(onCancel))
			onCancel();
		else if (menu.xDir != 0 && !is_undefined(onXDir))
            onXDir(menu.xDir);
        else if (menu.yDir != 0 && !is_undefined(onYDir))
            onYDir(menu.yDir);
    };
    
    #endregion
}
