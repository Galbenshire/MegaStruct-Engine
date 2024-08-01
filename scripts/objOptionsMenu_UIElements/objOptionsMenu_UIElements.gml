function OptionsMenu() : UIMenu() constructor {
    switchSubmenuList = [];
    
    /// @method add_submenu(name)
	/// @desc Creates a new UISubmenu for this submenu
    static add_submenu = function(_name) {
        submenus[$ _name] = new OptionsSubmenu();
        return submenus[$ _name];
    };
}

function OptionsSubmenu() : UISubmenu() constructor {
    itemList = [];
}

function OptionsItem(_label) : UIItem() constructor {
    label = _label;
    value = "";
    
    onUpdateValue = undefined;
}
