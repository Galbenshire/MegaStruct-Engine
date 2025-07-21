#region Menu

function PauseMenu() : UIFramework_Menu() constructor {}

#endregion

#region Submenus

function PauseMenu_Submenu_Weapons() : UIFramework_Submenu("weapons") constructor {
    /// @method on_render(x, y)
    static on_render = function(_x, _y) {
		var i = 0;
		repeat(itemCount) {
			items[i].render(_x, _y);
			_y += 24;
			i++;
		}
    };
}

function PauseMenu_Submenu_Options() : UIFramework_Submenu("options") constructor {
    /// @method on_render(x, y)
    static on_render = function(_x, _y) {
		var i = 0;
		repeat(itemCount) {
			items[i].render(_x, _y);
			_y += 16;
			i++;
		}
    };
}

function PauseMenu_Submenu_Player() : UIFramework_Submenu("player") constructor {
	healthPalette = [ $A8D8FC, $FFFFFF, $000000 ];
	
    /// @method on_render(x, y)
    static on_render = function(_x, _y) {
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
			
			draw_mm_healthbar_horizontal(_x - 20, _y + 8, healthpoints, other.healthPalette);
			
			draw_set_text_align(fa_left, fa_top);
			draw_sprite(sprBoltBig, 0, _x - 40, _y + 24);
			draw_text(_x - 20, _y + 32, global.bolts);
		}
    };
}

#endregion

#region Items

function PauseMenu_Item_Text(_id, _text) : UIFramework_Item(_id) constructor {
    text = _text;
    isConfirming = false;
    
    static on_confirm = function() {
		play_sfx(sfxMenuSelect);
		
		switch (id) {
			case "options":
				owner.phase = 10;
				
				screen_fade({
					onFadeOutEnd: function() /*=>*/ { event_user_scope(2, owner); },
					fadeOutDuration: 10,
					fadeHoldDuration: 1,
					fadeInDuration: 10
				});
				break;
			
			case "retry":
				if (!isConfirming)
					isConfirming = true;
				else
					restart_room();
				break;
			
			case "exitstage":
				if (!isConfirming)
					isConfirming = true;
				else
					go_to_room(rmTitleScreen);
				break;
		}
    };
    
    static on_focus_leave = function() {
		isConfirming = false;
    };
    
    static on_render = function(_x, _y) {
		var _col = is_focused() ? c_yellow : c_white;
		draw_set_text_align(fa_center, fa_top);
		draw_text_colour(_x, _y, isConfirming ? "OK?" : text, _col, _col, _col, _col, 1);
    };
}

function PauseMenu_Item_Weapon(_id, _weapon) : UIFramework_Item(_id) constructor {
    static ammoPaletteUnselected = [ $E4E4E4, $FFFFFF, $000000 ];
    static ammoPaletteSelected = [ $A8D8FC, $FFFFFF, $000000 ];
    static iconPaletteUnselected = [ $616161, $A1A1A1, $000000, $DCDCDC, $FFFFFF ];
    static iconPaletteSelected = [ $EC7000, $F8B838, $000000, $A8D8FC, $FFFFFF ];
    
    weapon = _weapon;
    
    static on_confirm = function() {
		var _player = global.player.body;
		
        _player.equip_weapon(weapon, _player);
        _player.refresh_palette();
        play_sfx(sfxMenuSelect);
        
        if (weapon != owner.oldWeapon) {
			with (prtProjectile) {
				if (owner == _player.id)
					instance_destroy();
			}
        }
        
        with (owner) {
            phase = 99;
            
            screen_fade({
                onFadeOutEnd: function(_fader) /*=>*/ { visible = false; },
                onFadeInEnd: function(_fader) /*=>*/ { instance_destroy(); },
				fadeOutDuration: 10,
				fadeInDuration: 10
            });
        }
    };
    
    static on_render = function(_x, _y) {
		var _isFocused = is_focused(),
			_colReplacer = colour_replacer();
		
		_colReplacer.activate(ColourReplacerMode.GREYSCALE)
			.set_colour_count(PalettePlayer.sizeof)
			.apply_output_colours(_isFocused ? iconPaletteSelected : iconPaletteUnselected)
			.update_uniforms();
		weapon.draw_icon(_x, _y);
		_colReplacer.deactivate();
		
		var _col = _isFocused ? ammoPaletteSelected : ammoPaletteUnselected;
		draw_mm_healthbar_horizontal(_x + 24, _y + 8, weapon.ammo, _col);
		
		_col = is_focused() ? c_yellow : c_white;
		draw_set_text_align(fa_left, fa_top);
		draw_text_colour(_x + 24, _y, weapon.get_name(true, true), _col, _col, _col, _col, 1);
    };
}

#endregion
