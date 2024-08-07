function PauseMenu() : UIFramework_Menu() constructor {}

function PauseMenu_Submenu_Weapons() : UIFramework_Submenu("weapons") constructor {
    /// @method render(x, y)
    static render = function(_x, _y) {
		var i = 0;
		repeat(itemCount) {
			items[i].render(_x, _y);
			_y += 24;
			i++;
		}
    };
}

function PauseMenu_Submenu_Options() : UIFramework_Submenu("options") constructor {
    /// @method render(x, y)
    static render = function(_x, _y) {
		var i = 0;
		repeat(itemCount) {
			items[i].render(_x, _y);
			_y += 16;
			i++;
		}
    };
}

function PauseMenu_Submenu_Player() : UIFramework_Submenu("player") constructor {
	palette = [ $A8D8FC, $FFFFFF, $000000 ];
	
    /// @method render(x, y)
    static render = function(_x, _y) {
		with (global.player.body) {
			var _playerX = x,
				_playerY = y,
				_xscale = image_xscale,
				_cellX = skinCellX,
				_cellY = skinCellY;
			
			x = _x - 32;
			y = _y + 4;
			image_xscale = 1;
			skinCellX = 0;
			skinCellY = 0;
			onDraw();
			
			x = _playerX;
			y = _playerY;
			image_xscale = _xscale;
			skinCellX = _cellX;
			skinCellY = _cellY;
			
			draw_mm_healthbar_horizontal(_x - 20, _y + 8, healthpoints, other.palette);
		}
    };
}

function PauseMenu_Item_Text(_id, _text) : UIFramework_Item(_id) constructor {
    text = _text;
    isConfirming = false;
    
    onFocusLeave = function() /*=>*/ { isConfirming = false; };
    
    static render = function(_x, _y) {
		var _col = is_focused() ? c_yellow : c_white;
		draw_set_text_align(fa_center, fa_top);
		draw_text_colour(_x, _y, isConfirming ? "OK?" : text, _col, _col, _col, _col, 1);
    };
}

function PauseMenu_Item_Weapon(_id, _weapon) : UIFramework_Item(_id) constructor {
    weapon = _weapon;
    palette = [ $A8D8FC, $FFFFFF, $000000 ];
    
    onConfirm = function() {
        player_equip_weapon(weapon, global.player.body);
        player_refresh_palette(global.player.body);
        play_sfx(sfxMenuSelect);
        
        with (prtProjectile) {
			if (owner == global.player.body.id)
				instance_destroy();
        }
        
        with (owner) {
            phase = 99;
            
            screen_fade({
                onFadeOutEnd: function(_fader) /*=>*/ { visible = false; },
                onFadeInEnd: function(_fader) /*=>*/ { instance_destroy(); }
            });
        }
    };
    
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
