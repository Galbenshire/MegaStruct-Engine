core.drawEnd();
debug.drawEnd();

var _str = string("Time Scale: {0}", global.gameTimeScale.value);
draw_text(game_view().left_edge(8), game_view().top_edge(8), _str);
