function PauseMenu() : UIMenu() constructor {
	static add_submenu = function(_name) {
        submenus[$ _name] = new PauseSubmenu();
        return submenus[$ _name];
    };
}

function PauseSubmenu() : UISubmenu() constructor {
	itemList = [];
    itemListCount = 0;
    
    static add_weapon_item = function(_name, _weapon) {
        items[$ _name] = new PauseItem_Weapon(_weapon);
        array_push(itemList, items[$ _name]);
        itemListCount++;
        return items[$ _name];
    };
    
    /// @method generate_neighbours()
	/// @desc Gets this submenu's neighbour, using the given direction
    static generate_neighbours = function() {
        for (var i = 0; i < itemListCount; i++) {
			itemList[i].neighbourTop = itemList[modf(i - 1, itemListCount)];
			itemList[i].neighbourBottom = itemList[modf(i + 1, itemListCount)];
        }
    };
    
    /// @method render(x, y)
    static render = function(_x, _y) {
		var i = 0;
		repeat(itemListCount) {
			itemList[i].render(_x, _y);
			_y += 24;
			i++;
		}
    };
}

function PauseItem_Text(_text) : UIItem() constructor {
    text = _text;
    
    static render = function(_x, _y) {
		draw_set_text_align(fa_center, fa_top);
		draw_text(_x, _y, text);
    };
}

function PauseItem_Weapon(_weapon) : UIItem() constructor {
    weapon = _weapon;
    palette = [ $A8D8FC, $FFFFFF, $000000 ];
    
    static render = function(_x, _y) {
        shader_set(is_focused() ? shdPassthrough : shdGreyscale);
        
		weapon.draw_icon(_x, _y);
		draw_mm_healthbar_horizontal(_x + 24, _y + 8, weapon.ammo, palette);
		
		var _col = is_focused() ? c_yellow : c_white;
		draw_set_text_align(fa_left, fa_top);
		draw_text_colour(_x + 24, _y, weapon.get_name(true, true), _col, _col, _col, _col, 1);
		
		shader_reset();
    };
}
