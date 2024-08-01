function UIMenu() constructor {
	#region Variables
	
    owner = other.id; /// @is {instance}
    
    inputs = global.player.inputs; /// @is {InputMap}
    xDir = 0;
    yDir = 0;
    
    submenus = {}; /// @is {struct}
    currentSubmenu = undefined; /// @is {UISubmenu?}
    canChangeSubmenu = true;
    
    #endregion
    
    #region Functions - Managing UI Submenus
    
    /// @method add_submenu(name)
	/// @desc Creates a new UISubmenu for this submenu
    static add_submenu = function(_name) {
        submenus[$ _name] = new UISubmenu();
        return submenus[$ _name];
    };
    
    /// @method apply_focus(submenu)
	/// @desc Gives the specified UISubmenu focus within this submenu
    static apply_focus = function(_submenu) {
		currentSubmenu = _submenu;
		if (!is_undefined(currentSubmenu.onFocusEnter))
            currentSubmenu.onFocusEnter();
    };
    
    /// @method pass_submenu_focus(new_submenu)
	/// @desc Changes focus from the current UISubmenu to the specified one
    static pass_submenu_focus = function(_newSubmenu) {
        release_focus();
		apply_focus(_newSubmenu);
    };
    
    /// @method release_focus()
	/// @desc Releases focus from the current UISubmenu
    static release_focus = function() {
		if (!is_undefined(currentSubmenu) && !is_undefined(currentSubmenu.onFocusLeave))
            currentSubmenu.onFocusLeave();
        currentSubmenu = undefined;
    };
    
    #endregion
    
    #region Functions - Other
    
    /// @method update()
	/// @desc Updates the menu
    static update = function() {
        xDir = inputs.is_pressed(InputActions.RIGHT) - inputs.is_pressed(InputActions.LEFT);
        yDir = inputs.is_pressed(InputActions.DOWN) - inputs.is_pressed(InputActions.UP);
        if (xDir != 0 && yDir != 0) {
            xDir = 0;
            yDir = 0;
        }
        
        var _nextSubmenu = currentSubmenu.get_neighbour(xDir, yDir);
        if (!is_undefined(_nextSubmenu) && canChangeSubmenu) {
            pass_submenu_focus(_nextSubmenu);
        } else {
            currentSubmenu.update(xDir, yDir);
        }
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
    onTick = undefined; /// @is {function<InputMap, void>} Called every frame while this submenu has focus
    
    #endregion
    
    #region Functions - Managing UI Items
    
    /// @method add_item(name)
	/// @desc Creates a new UIItem for this submenu
    static add_item = function(_name) {
        items[$ _name] = new UIItem();
        return items[$ _name];
    };
    
    /// @method apply_focus(item)
	/// @desc Gives the specified UIItem focus within this submenu
    static apply_focus = function(_item) {
		currentItem = _item;
		if (!is_undefined(currentItem.onFocusEnter))
            currentItem.onFocusEnter();
    };
    
    /// @method pass_item_focus(new_item)
	/// @desc Changes focus from the current UIItem to the specified one
    static pass_item_focus = function(_newItem) {
		var _prevItem = currentItem;
		
		release_focus();
		apply_focus(_newItem);
		
		if (currentItem != _prevItem)
			play_sfx(sfxMenuMove);
    };
    
    /// @method release_focus()
	/// @desc Releases focus from the current UIItem
    static release_focus = function() {
		if (!is_undefined(currentItem) && !is_undefined(currentItem.onFocusLeave))
            currentItem.onFocusLeave();
        currentItem = undefined;
    };
    
    #endregion
    
    #region Functions - Other
    
    /// @method generate_neighbours_from_list(list, is_vertical)
	/// @desc Gets this submenu's neighbour, using the given direction
    static generate_neighbours_from_list = function(_list, _isVertical) {
        var _listCount = array_length(_list);
        for (var i = 0; i < _listCount; i++) {
			if (_isVertical) {
				_list[i].neighbourTop = _list[modf(i - 1, _listCount)];
				_list[i].neighbourBottom = _list[modf(i + 1, _listCount)];
			} else {
				_list[i].neighbourLeft = _list[modf(i - 1, _listCount)];
				_list[i].neighbourRight = _list[modf(i + 1, _listCount)];
			}
        }
    };
    
    /// @method get_neighbour(x_dir, y_dir)
	/// @desc Gets this submenu's neighbour, using the given direction
    static get_neighbour = function(_xDir, _yDir) {
		if (is_undefined(currentItem))
			return undefined;
		if (!is_undefined(currentItem.get_neighbour(_xDir, _yDir)))
			return undefined;
		
		if (_xDir != 0)
            return (_xDir < 0) ? neighbourLeft : neighbourRight;
		if (_yDir != 0)
            return (_yDir < 0) ? neighbourTop : neighbourBottom;
        
		return undefined;
    };
    
    /// @method is_focused()
	/// @desc Checks if this submenu currently has focus in its menu
	///
	/// @returns {bool}  If it has focus (true) or not (false)
    static is_focused = function() {
        return menu.currentSubmenu == self;
    };
    
    /// @method update(x_dir, y_dir)
	/// @desc Updates this submenu
    static update = function(_xDir, _yDir) {
		if (!is_undefined(onTick)) {
			onTick(menu.inputs);
			return;
		}
		
        if (is_undefined(currentItem))
            return;
        
        var _nextItem = currentItem.get_neighbour(_xDir, _yDir);
        if (canChangeItem && !is_undefined(_nextItem)) {
            pass_item_focus(_nextItem);
        } else {
            currentItem.update(_xDir, _yDir);
        }
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
    onTick = undefined; /// @is {function<InputMap, void>}
    onXDir = undefined; /// @is {function<int, void>}
    onYDir = undefined; /// @is {function<int, void>}
    
    #endregion
    
    #region Functions
    
    /// @method get_neighbour(x_dir, y_dir)
	/// @desc Gets this item's neighbour, using the given direction
    static get_neighbour = function(_xDir, _yDir) {
		if (_xDir != 0)
            return (_xDir < 0) ? neighbourLeft : neighbourRight;
		if (_yDir != 0)
            return (_yDir < 0) ? neighbourTop : neighbourBottom;
		return undefined;
    };
    
    /// @method is_focused()
	/// @desc Checks if this item currently has focus in its submenu
	///
	/// @returns {bool}  If it has focus (true) or not (false)
    static is_focused = function() {
        return submenu.currentItem == self;
    };
    
    /// @method update(x_dir, y_dir)
	/// @desc Updates this item
    static update = function(_xDir, _yDir) {
		if (!is_undefined(onTick))
			onTick(menu.inputs);
		else if (_xDir != 0 && !is_undefined(onXDir))
            onXDir(_xDir);
        else if (_yDir != 0 && !is_undefined(onYDir))
            onYDir(_yDir);
    };
    
    #endregion
}
