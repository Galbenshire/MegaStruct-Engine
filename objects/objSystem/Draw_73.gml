core.drawEnd();
debug.drawEnd();

var _inputs = global.player.inputs,
	_str = string("{0}\n{1}\n{2}", _inputs.held, _inputs.pressed, _inputs.released);
draw_text(mouse_x, mouse_y, _str);
