if (entity_is_dead())
	exit;

var _x = x,
	_y = y;
x += subPixelX;
y += subPixelY;

// image_blend = mouse_check_button(mb_left) ? c_blue : c_white;
// image_alpha = mouse_check_button(mb_right) ? 0.5 : 1;

if (iFrames < 0 || (iFrames & 3) < 2) {
	if (isHurt && (stateMachine.timer & 7) <= 3) {
		draw_sprite_ext(sprHitspark, 0, sprite_x_center(), sprite_y_center(), image_xscale, image_yscale, 0, c_white, 1);
	} else if (bodyPalette.isSupported) {
		bodyPalette.activate();
        global.spriteAtlas_Player.draw_cell_ext(skinCellX, skinCellY, 0, x, y, image_xscale, image_yscale, image_blend, image_alpha);
        bodyPalette.deactivate();
	} else { // Shaders aren't working? Then let's go for our backup: whitemasks
		var _whitemaskBlends = array_create_ext(4, function(i) /*=>*/ {return (i == 0) ? c_white : bodyPalette.outputColours[i - 1]});
		var _blendChannels = [ colour_get_red(image_blend) / 255, colour_get_green(image_blend) / 255, colour_get_blue(image_blend) / 255 ];
		
		for (var i = 0; i < 4; i++) {
			var _colour = make_color_rgb(
				(colour_get_red(_whitemaskBlends[i]) / 255) * _blendChannels[0] * 255,
				(colour_get_green(_whitemaskBlends[i]) / 255) * _blendChannels[1] * 255,
				(colour_get_blue(_whitemaskBlends[i]) / 255) * _blendChannels[2] * 255,
			);
			global.spriteAtlas_Player.draw_cell_ext(skinCellX, skinCellY, i, _x, _y, image_xscale, image_yscale, _colour, image_alpha);
		}
	}
}

x = _x;
y = _y;

var _text = string("{0}\n{1}", animator.currentFrame, animator.frameCounter);
draw_text(mouse_x + 8, mouse_y, _text);
