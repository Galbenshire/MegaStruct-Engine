function UIFramework_Menu() constructor {
	#region Variables
	
    owner = other.id; /// @is {instance}
    
    inputs = new InputMap();
    xDir = 0;
    yDir = 0;
    isConfirmed = false;
    isCanceled = false;
    
    confirmButtons = [InputActions.PAUSE, InputActions.JUMP];
    cancelButtons = [InputActions.SHOOT];
    
    submenus = []; /// @is {array<UIFramework_Submenu>}
    submenuCount = 0;
    
    currentSubmenu = undefined; /// @is {UIFramework_Submenu?}
    previousSubmenu = undefined; /// @is {UIFramework_Submenu?}
    defaultSubmenu = undefined; /// @is {UIFramework_Submenu?}
    canChangeSubmenu = true;
    
    moveSFX = sfxMenuMove;
    selectSFX = sfxMenuSelect;
    
    __submenuIDFind = "";
    
    #endregion
    
    #region Functions - Input
    
    /// @method check_inputs()
	/// @desc Updates input across the menu
    static check_inputs = function() {
		inputs.copy_inputs(global.player.inputs);
		
		xDir = inputs.is_pressed(InputActions.RIGHT) - inputs.is_pressed(InputActions.LEFT);
        yDir = inputs.is_pressed(InputActions.DOWN) - inputs.is_pressed(InputActions.UP);
        if (xDir != 0 && yDir != 0) {
            xDir = 0;
            yDir = 0;
        }
        
        isConfirmed = inputs.is_any_pressed_ext(confirmButtons);
        isCanceled = inputs.is_any_pressed_ext(cancelButtons);
    };
    
    /// @method clear_inputs()
	/// @desc Clears all inputs currently in the menu
    static clear_inputs = function() {
		inputs.clear_all();
		xDir = 0;
		yDir = 0;
		isConfirmed = false;
		isCanceled = false;
    };
    
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
    
    /// @method try_changing_submenus()
	/// @desc Makes an attempt to change submenus
    static try_changing_submenus = function() {
		if (!canChangeSubmenu)
			return;
		
		var _prevSubmenu = currentSubmenu,
			_nextSubmenu = currentSubmenu.get_neighbour(xDir, yDir);
		if (!is_undefined(_nextSubmenu)) {
			self.pass_submenu_focus(_nextSubmenu);
			self.clear_inputs();
			if (currentSubmenu != _prevSubmenu)
				play_sfx(moveSFX);
		}
    };
    
    #endregion
    
    #region Functions - Other
    
    /// @method render(x, y)
	/// @desc Renders this menu
	///
	/// @param {number}  x  x-position to render the menu at
	/// @param {number}  y  y-position to render the menu at
    static render = function(_x, _y) {
		currentSubmenu.render(_x, _y);
    };
    
    /// @method update()
	/// @desc Updates the menu
    static update = function() {
        self.check_inputs();
        self.try_changing_submenus();
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
    
    /// @method on_focus_enter()
	/// @desc Called when this submenu gains focus
    static on_focus_enter = function() {
		//...	
    };
    
    /// @method on_focus_leave()
	/// @desc Called when this submenu loses focus
    static on_focus_leave = function() {
		//...	
    };
    
    /// @method on_tick(inputs)
	/// @desc Called every frame while this submenu has focus
	///
	/// @param {InputMap}  inputs  Current inputs from this menu's input map
	///
	/// @returns {bool}  If the submenu should check for item changes afterwards (true) or not (false)
    static on_tick = function(_inputs) {
		return true;
    };
    
    #endregion
    
    #region Functions - Focus
    
    /// @method gain_focus()
	/// @desc Sets this submenu as the current submenu in its menu
    static gain_focus = function() {
		menu.currentSubmenu = self;
		self.on_focus_enter();
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
		
		self.on_focus_leave();
		menu.currentSubmenu = undefined;
		menu.previousSubmenu = self;
    };
    
    #endregion
    
    #region Functions - Managing UI Items
    
    /// @method add_item(item)
	/// @desc Adds a UI Item into this submenu
	///
	/// @param {UIFramework_Item}  item  The UI Item to add
    static add_item = function(_item) {
        array_push(items, _item);
        itemCount++;
        
        _item.owner = owner;
        _item.menu = menu;
        _item.submenu = self;
    };
    
    /// @method initialize_grid(per_row, wrap_top, wrap_left, wrap_bottom, wrap_right)
	/// @desc Establishes this submenu as a list that's either vertical or horizontal
	///
	/// @param {int}  per_row  How many items should there be per row
	/// @param {bool}  wrap_front  Whether the grid should wrap around itself at the top (true) or not (false, default)
	/// @param {bool}  wrap_left  Whether the grid should wrap around itself at the left (true, default) or not (false)
	/// @param {bool}  wrap_bottom  Whether the grid should wrap around itself at the bottom (true) or not (false, default)
	/// @param {bool}  wrap_right  Whether the grid should wrap around itself at the right (true, default) or not (false)
    static initialize_grid = function(_perRow, _wrapTop = false, _wrapLeft = true, _wrapBottom = false, _wrapRight = true) {
		var _totalRows = ceil(itemCount / _perRow);
		
		var i = 0; repeat(itemCount) {
			var _rowI = i div _perRow,
				_columnI = i mod _perRow;
			
			// Top Neighbour
			if (_rowI > 0 || _wrapTop) {
				var _topI = modf(i - _perRow, itemCount);
				items[i].neighbourTop = items[_topI];
			}
			// Left Neighbour
			if (_columnI > 0 || _wrapLeft) {
				var _leftI = modf(_columnI - 1, _perRow) + (_rowI * _perRow);
				items[i].neighbourLeft = items[_leftI];
			}
			// Bottom Neighbour
			if (_rowI <= _totalRows - 1 || _wrapBottom) {
				var _bottomI = modf(i + _perRow, itemCount);
				items[i].neighbourBottom = items[_bottomI];
			}
			// Right Neighbour
			if (_columnI > 0 || _wrapRight) {
				var _rightI = modf(_columnI + 1, _perRow) + (_rowI * _perRow);
				items[i].neighbourRight = items[_rightI];
			}
			
			i++;
		}
    };
    
    /// @method initialize_list(is_vertical, wrap_front, wrap_back)
	/// @desc Establishes this submenu as a list that's either vertical or horizontal
	///
	/// @param {bool}  is_vertical  Whether to treat this list as vertical (true) or horizontal (false)
	/// @param {bool}  [wrap_front]  Whether the list should wrap around itself in the front (true, default) or not (false)
	/// @param {bool}  [wrap_back]  Whether the list should wrap around itself in the back (true, default) or not (false)
    static initialize_list = function(_isVertical, _wrapFront = true, _wrapBack = true) {
		if (itemCount <= 0)
			return;
		
		var i = 0; repeat(itemCount) {
			// Top/Left Neighbour
			if (i > 0 || _wrapFront) {
				var _prevI = modf(i - 1, itemCount);
				if (_isVertical)
					items[i].neighbourTop = items[_prevI];
				else
					items[i].neighbourLeft = items[_prevI];
			}
			
			// Bottom/Right Neighbour
			if (i < itemCount - 1 || _wrapBack) {
				var _nextI = modf(i + 1, itemCount);
				if (_isVertical)
					items[i].neighbourBottom = items[_nextI];
				else
					items[i].neighbourRight = items[_nextI];
			}
			
			i++;
		}
    };
    
    /// @method get_item(item_id)
	/// @desc Gets a UI Item by its ID
	///
	/// @param {string}  item_id  The ID of the UI Item to find
	///
	/// @returns {UIFramework_Item?}  The UI item, or `undefined` if nothing was found
    static get_item = function(_itemID) {
		__itemIDFind = _itemID;
		return array_find(items, function(_item, i) /*=>*/ {return _item.id == __itemIDFind});
    };
    
    /// @method pass_item_focus(new_item)
	/// @desc Changes focus from the current UIItem to the specified one
	///
	/// @param {UIFramework_Item?}  new_item  The new UI item to switch to
    static pass_item_focus = function(_newItem) {
		if (!is_undefined(currentItem))
			currentItem.release_focus();
		if (!is_undefined(_newItem))
			_newItem.gain_focus();
    };
    
    /// @method try_changing_items()
	/// @desc Makes an attempt to change items
    static try_changing_items = function() {
		if (!canChangeItem)
			return;
		
		var _prevItem = currentItem,
			_nextItem = currentItem.get_neighbour(menu.xDir, menu.yDir);
		if (!is_undefined(_nextItem)) {
			self.pass_item_focus(_nextItem);
			menu.clear_inputs();
			if (currentItem != _prevItem)
				play_sfx(menu.moveSFX);
		}
    };
    
    #endregion
    
    #region Functions - Neighbours
    
    /// @method get_neighbour(x_dir, y_dir)
	/// @desc Gets this submenu's neighbour, using the given direction
	///
	/// @param {number}  x_dir  Checks horizontally for a neighbour
	/// @param {number}  y_dir  Checks vertically for a neighbour
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
    
    /// @method set_neighbour(left, right, top, bottom)
	/// @desc Sets all possible neighbours for this submenu
	///
	/// @param {UIFramework_Submenu}  [left]  neighbour to the left
	/// @param {UIFramework_Submenu}  [right]  neighbour to the right
	/// @param {UIFramework_Submenu}  [top]  neighbour above
	/// @param {UIFramework_Submenu}  [bottom]  neighbour below
    static set_neighbours = function(_left, _right, _top, _bottom) {
		neighbourLeft = _left;
		neighbourRight = _right;
		neighbourTop = _top;
		neighbourBottom = _bottom;
    };
    
    #endregion
    
    #region Functions - Other
    
    /// @method render(x, y)
	/// @desc Renders this submenu
	///
	/// @param {number}  x  x-position to render at
	/// @param {number}  y  y-position to render at
    static render = function(_x, _y) {
		// Basic render callback, drawing all items in this submenu
		// Recommended you override this for your own menus
		var i = 0; repeat(itemCount) {
			items[i].render(_x, _y);
			i++;
		}
    };
    
    /// @method update()
	/// @desc Updates this submenu
    static update = function() {
		if (!self.on_tick(menu.inputs))
			return;
		
        if (!is_undefined(currentItem)) {
			self.try_changing_items();
			currentItem.update();
        }
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
    
    /// @method on_confirm()
	/// @desc Called when this item receives a "confirm" input
    static on_confirm = function() {
		//...
    };
    
    /// @method on_cancel()
	/// @desc Called when this item receives a "cancel" input
    static on_cancel = function() {
		//...
    };
    
    /// @method on_focus_enter()
	/// @desc Called when this item gains focus
    static on_focus_enter = function() {
		//...	
    };
    
    /// @method on_focus_leave()
	/// @desc Called when this item loses focus
    static on_focus_leave = function() {
		//...	
    };
    
    /// @method on_tick(inputs)
	/// @desc Called every frame while this item has focus
	///
	/// @param {InputMap}  inputs  Current inputs from this menu's input map
	///
	/// @returns {bool}  If the item should then check for more specific input types (true) or not (false)
    static on_tick = function(_inputs) {
		return true;
    };
    
    /// @method on_x_dir(dir)
	/// @desc Called when this item receives left/right input
	///
	/// @param {int}  dir  Direction of the input
    static on_x_dir = function(_dir) {
		//...
    };
    
    /// @method on_y_dir(dir)
	/// @desc Called when this item receives up/down input
	///
	/// @param {int}  dir  Direction of the input
    static on_y_dir = function(_dir) {
		//...
    };
    
    #endregion
    
    #region Functions - Focus
    
    /// @method gain_focus()
	/// @desc Sets this item as the current item in its submenu
    static gain_focus = function() {
		submenu.currentItem = self;
		on_focus_enter();
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
		on_focus_leave();
		submenu.currentItem = undefined;
		submenu.previousItem = self;
    };
    
    #endregion
    
    #region Functions - Neighbours
    
    /// @method get_neighbour(x_dir, y_dir)
	/// @desc Gets this item's neighbour, using the given direction
	///
	/// @param {int}  x_dir  x-direction to check in
	/// @param {int}  y_dir  y-direction to check in
	///
	/// @returns {UIFramework_Item?}  The neighbour in the given direction. Returns `undefined` if nothing was found
    static get_neighbour = function(_xDir, _yDir) {
		if (_xDir != 0)
            return (_xDir < 0) ? neighbourLeft : neighbourRight;
		if (_yDir != 0)
            return (_yDir < 0) ? neighbourTop : neighbourBottom;
		return undefined;
    };
    
    /// @method set_neighbour(left, right, top, bottom)
	/// @desc Sets all possible neighbours for this item
	///
	/// @param {UIFramework_Item}  [left]  neighbour to the left
	/// @param {UIFramework_Item}  [right]  neighbour to the right
	/// @param {UIFramework_Item}  [top]  neighbour above
	/// @param {UIFramework_Item}  [bottom]  neighbour below
    static set_neighbours = function(_left, _right, _top, _bottom) {
		neighbourLeft = _left;
		neighbourRight = _right;
		neighbourTop = _top;
		neighbourBottom = _bottom;
    };
    
    #endregion
    
    #region Functions - Other
    
    /// @method render(x, y)
	/// @desc Renders this item
	///
	/// @param {number}  x  x-position to render at
	/// @param {number}  y  y-position to render at
    static render = function(_x, _y) {
		//...
    };
    
    /// @method update()
	/// @desc Updates this item
    static update = function() {
		if (!on_tick(menu.inputs))
			return;
		
		if (menu.isConfirmed)
			self.on_confirm();
		else if (menu.isCanceled)
			self.on_cancel();
		else if (menu.xDir != 0)
            self.on_x_dir(menu.xDir);
        else if (menu.yDir != 0)
            self.on_y_dir(menu.yDir);
    };
    
    #endregion
}
