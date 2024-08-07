function UIFramework_Menu() constructor {
	#region Variables
	
    owner = other.id; /// @is {instance}
    
    inputs = global.player.inputs; /// @is {InputMap}
    confirmButtons = [InputActions.PAUSE, InputActions.JUMP];
    cancelButtons = [InputActions.SHOOT];
    
    xDir = 0;
    yDir = 0;
    isConfirmed = false;
    isCanceled = false;
    
    submenus = []; /// @is {array<UIFramework_Submenu>}
    submenuCount = 0;
    
    currentSubmenu = undefined; /// @is {UIFramework_Submenu?}
    previousSubmenu = undefined; /// @is {UIFramework_Submenu?}
    defaultSubmenu = undefined; /// @is {UIFramework_Submenu?}
    canChangeSubmenu = true;
    
    __submenuIDFind = "";
    
    #endregion
    
    #region Functions - Managing UI Submenus
    
    /// @method add_submenu(submenu)
	/// @desc Adds a UI Submenu into this menu
    static add_submenu = function(_submenu) {
		array_push(submenus, _submenu);
        submenuCount++;
        
        _submenu.owner = owner;
        _submenu.menu = self;
        
		with (_submenu) {
			for (var i = 0; i < itemCount; i++) {
				items[i].owner = owner;
				items[i].menu = menu;
				items[i].submenu = self;
			}
		}
    };
    
    /// @method get_submenu(submenu_id)
	/// @desc Gets a UI Submenu by its ID
    static get_submenu = function(_submenuID) {
		__submenuIDFind = _submenuID;
		return array_find(submenus, function(_submenu, i) /*=>*/ {return _submenu.id == __submenuIDFind});
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

function UIFramework_Submenu(_id) constructor {
    #region Variables
    
    id = _id
    
    menu = undefined; /// @is {UIFramework_Menu}
    owner = noone; /// @is {instance}
    
    items = []; /// @is {array<UIFramework_Item>}
    itemCount = 0;
    
    currentItem = undefined; /// @is {UIFramework_Item?}
    previousItem = undefined; /// @is {UIFramework_Item?}
    defaultItem = undefined; /// @is {UIFramework_Item?}
    canChangeItem = true;
    
    // Neighbours - where to pass focus depending on direction
    neighbourLeft = undefined; /// @is {UIFramework_Submenu?}
    neighbourRight = undefined; /// @is {UIFramework_Submenu?}
    neighbourTop = undefined; /// @is {UIFramework_Submenu?}
    neighbourBottom = undefined; /// @is {UIFramework_Submenu?}
    
    __itemIDFind = "";
    
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
		
		if (!is_undefined(defaultItem))
			defaultItem.gain_focus();
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
    
    /// @method add_item(item)
	/// @desc Adds a UI Item into this submenu
    static add_item = function(_item) {
        array_push(items, _item);
        itemCount++;
        
        _item.owner = owner;
        _item.menu = menu;
        _item.submenu = self;
    };
    
    /// @method add_items_from_list(item_list, is_vertical, wrap_neighbours)
	/// @desc Adds a list UI Items into this submenu
    static add_items_from_list = function(_itemList, _isVertical, _wrapNeighbours) {
		var _count = array_length(_itemList);
		if (_count <= 0)
			return;
		
		for (var i = 0; i < _count; i++) {
			add_item(_itemList[i]);
			
			if (_isVertical) {
				_itemList[i].neighbourTop = _itemList[modf(i - 1, _count)];
				_itemList[i].neighbourBottom = _itemList[modf(i + 1, _count)];
			} else {
				_itemList[i].neighbourLeft = _itemList[modf(i - 1, _count)];
				_itemList[i].neighbourRight = _itemList[modf(i + 1, _count)];
			}
        }
        
        if (_wrapNeighbours)
			return;
        if (_isVertical) {
			_itemList[0].neighbourTop = undefined;
			_itemList[_count - 1].neighbourBottom = undefined;
        } else {
			_itemList[0].neighbourLeft = undefined;
			_itemList[_count - 1].neighbourRight = undefined;
        }
    };
    
    /// @method get_item(item_id)
	/// @desc Gets a UI Item by its ID
    static get_item = function(_itemID) {
		__itemIDFind = _itemID;
		return array_find(items, function(_item, i) /*=>*/ {return _item.id == __itemIDFind});
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
			if (!is_undefined(currentItem.get_neighbour(_xDir, _yDir)))
				return undefined;
		}
		
		if (_xDir != 0)
            return (_xDir < 0) ? neighbourLeft : neighbourRight;
		if (_yDir != 0)
            return (_yDir < 0) ? neighbourTop : neighbourBottom;
        
		return undefined;
    };
    
    /// @method render(x, y)
	/// @desc Renders this item
    static render = function(_x, _y) {
		var i = 0;
		repeat(itemCount) {
			items[i].render(_x, _y);
			i++;
		}
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

function UIFramework_Item(_id) constructor {
    #region Variables
    
    id = _id;
    
    submenu = undefined; /// @is {UIFramework_Submenu}
    menu = undefined; /// @is {UIFramework_Menu}
    owner = noone; /// @is {instance}
    
    // Neighbours - where to pass focus depending on direction
    neighbourLeft = undefined; /// @is {UIFramework_Item?}
    neighbourRight = undefined; /// @is {UIFramework_Item?}
    neighbourTop = undefined; /// @is {UIFramework_Item?}
    neighbourBottom = undefined; /// @is {UIFramework_Item?}
    
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
    
    /// @method render(x, y)
	/// @desc Renders this item
    static render = function(_x, _y) {
		//...
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
