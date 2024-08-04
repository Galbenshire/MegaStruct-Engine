function OptionsMenu() : UIMenu() constructor {
	nextSubmenu = undefined;
	
    /// @method add_submenu(name, header)
	/// @desc Creates a new OptionsSubmenu for this submenu
    static add_submenu = function(_name, _header) {
        submenus[$ _name] = new OptionsSubmenu(_header);
        return submenus[$ _name];
    };
    
    /// @method switch_to_submenu(new_submenu)
    static switch_to_submenu = function(_newSubmenu) {
		nextSubmenu = _newSubmenu;
		owner.phase = 10;
		owner.phaseTimer = 0;
		play_sfx(sfxMenuSelect);
    };
}

function OptionsSubmenu(_header) : UISubmenu() constructor {
	header = _header;
	
    itemList = [];
    itemListCount = 0;
    
    /// @method add_item(name)
	/// @desc Creates a new UIItem for this submenu
    static add_item = function(_name, _label) {
        items[$ _name] = new OptionsItem(_label);
        array_push(itemList, items[$ _name]);
        itemListCount++;
        return items[$ _name];
    };
    
    /// @method generate_neighbours()
	/// @desc Gets this submenu's neighbour, using the given direction
    static generate_neighbours = function() {
        var _listCount = array_length(itemList);
        for (var i = 0; i < _listCount; i++) {
			itemList[i].neighbourTop = itemList[modf(i - 1, _listCount)];
			itemList[i].neighbourBottom = itemList[modf(i + 1, _listCount)];
        }
    };
    
    /// @method refresh_item_values()
    static refresh_item_values = function() {
		var i = 0;
		repeat(itemListCount) {
			itemList[i].refresh_value();
			i++;
		}
    };
    
    /// @method render(x, y)
    static render = function(_x, _y) {
		draw_set_valign(fa_top);
		
		var i = 0;
		repeat(itemListCount) {
			draw_set_colour(itemList[i].is_focused() ? c_yellow : c_white);
			draw_set_halign(fa_left);
			draw_text(_x - 96, _y, itemList[i].label);
			draw_set_halign(fa_right);
			draw_text(_x + 96, _y, itemList[i].value);
			
			_y += 16 + 8 * (i == 0);
			i++;
		}
    };
}

function OptionsItem(_label) : UIItem() constructor {
    label = _label;
    
    value = "";
    onRefreshValue = undefined;
    
    /// @method refresh_value()
    static refresh_value = function() {
		if (!is_undefined(onRefreshValue))
			value = onRefreshValue();
    };
}
