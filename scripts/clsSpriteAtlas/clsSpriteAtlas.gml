/// @func SpriteAtlas(config)
/// @desc Represents a sprite that is made up of a set of smaller sub-sprites.
///       This is mainly used for spritesheets; the most notable example being Mega Man's sprites
///       Note that these atlases should be treated as if they were a resource themselves.
///       As such, it's recommended that they be stored in global variables.
///
/// @param {struct}  config  
function SpriteAtlas(_config) constructor {
    #region Variables
    
    // Sprite properties
    sprite = _config.sprite; /// @is {sprite}
    spriteWidth = sprite_get_width(sprite);
    spriteHeight = sprite_get_height(sprite);

    // Spacing/Padding properties
    border = _config[$ "border"] ?? 0; /// @is {int} Spacing in-between the cells & the edge of the spritesheet
    margin = _config[$ "margin"] ?? 0; /// @is {int} Spacing in between each cell on the sheet
    padding = _config[$ "padding"] ?? 0; /// @is {int} The inner 'border' of the cells to ignore when drawing
    
    // Cell properties
    cellWidth = _config.width; /// @is {int}
    cellHeight = _config[$ "height"] ?? cellWidth; /// @is {int}
    cellXOffset = _config[$ "xoffset"] ?? 0; /// @is {int}
    cellYOffset = _config[$ "yoffset"] ?? 0; /// @is {int}
    
    cells = []; /// @is {array<SpriteAtlasCell>}
    rows = 0;
    columns = 0;
    
    #endregion
    
    #region Functions - Getters
    
    /// -- get_cell(x, y)
	/// Gets data specific to the cell at the given cellgrid co-ordinates
	///
	/// @param {int}  x  Horizontal position of the cell in the atlas
	/// @param {int}  y  Vertical position of the cell in the atlas
	///
	/// @returns {SpriteAtlasCell}  The cell data at this position
    static get_cell = function(_x, _y) {
        return cells[get_cell_index(_x, _y)];
    };
    
    /// -- get_cell_1D(index)
	/// Version of get_cell() that only requires a single number
	///
	/// @param {int}  index  The index of the cell to retrieve
	///
	/// @returns {SpriteAtlasCell}  The SpriteAtlasCell at this position
    static get_cell_1D = function(_index) {
        return cells[_index];
    };
    
    /// -- get_cell_count()
	/// Returns the number of cells in the sprite atlas
	///
	/// @returns {int}  The number of cells
    static get_cell_count = function() {
        return array_length(cells);
    };
    
    /// -- get_cell_index(x, y)
	/// Gets the index of the cell at the given cellgrid co-ordinates
	///
	/// @param {int}  x  Horizontal position of the cell in the atlas
	/// @param {int}  y  Vertical position of the cell in the atlas
	///
	/// @returns {int}  The index of the cell
    static get_cell_index = function(_x, _y) {
        return _x + _y * columns;
    };
    
    #endregion
    
    #region Functions - Drawing
    
    /// -- draw_cell(cell_x, cell_y, subimage, x, y)
	/// Draws a cell from this atlas
	///
	/// @param {int}  cell_x  cell's horizontal position along the atlas
	/// @param {int}  cell_y  cell's verical position along the atlas
	/// @param {int}  subimage  The subimage of the sprite used for this atlas
	/// @param {number}  x  x-position to draw the cell at
	/// @param {number}  y  y-position to draw the cell at
    static draw_cell = function(_cellX, _cellY, _subimg, _x, _y) {
    	draw_cell_1D(get_cell_index(_cellX, _cellY), _subimg, _x, _y);
    };
    
    /// -- draw_cell_1D(index, subimage, x, y)
	/// Version of draw_cell() that only requires a single variable to get the cell
	///
	/// @param {int}  index  the specific cell to draw
	/// @param {int}  subimage  The subimage of the sprite used for this atlas
	/// @param {number}  x  x-position to draw the cell at
	/// @param {number}  y  y-position to draw the cell at
    static draw_cell_1D = function(_index, _subimg, _x, _y) {
		draw_cell_1D_ext(_index, _subimg, _x, _y, 1, 1, c_white, 1);
    };
    
    /// -- draw_cell_ext(cell_x, cell_y, subimage, x, y, xscale, yscale, colour, alpha)
	/// Extended version of draw_cell() that allows you to scale the image, apply a colour blend, or alter the opacity
	///
	/// @param {int}  cell_x  cell's horizontal position along the atlas
	/// @param {int}  cell_y  cell's verical position along the atlas
	/// @param {int}  subimage  The subimage of the sprite used for this atlas
	/// @param {number}  x  x-position to draw the cell at
	/// @param {number}  y  y-position to draw the cell at
	/// @param {number}  xscale  x-scale to draw at
	/// @param {number}  yscale  y-scale to draw at
	/// @param {int}  colour  blending to apply to this cell
	/// @param {number}  alpha  sets how transparent the cell should be drawn at 
    static draw_cell_ext = function(_cellX, _cellY, _subimg, _x, _y, _xscale, _yscale, _colour, _alpha) {
    	draw_cell_1D_ext(get_cell_index(_cellX, _cellY), _subimg, _x, _y, _xscale, _yscale, _colour, _alpha);
    };
    
    /// -- draw_cell_1D_ext(index, subimage, x, y, xscale, yscale, colour, alpha)
	/// Extended version of draw_cell_1D() that allows you to scale the image, apply a colour blend, or alter the opacity
	///
	/// @param {int}  index  the specific cell to draw
	/// @param {int}  subimage  The subimage of the sprite used for this atlas
	/// @param {number}  x  x-position to draw the cell at
	/// @param {number}  y  y-position to draw the cell at
	/// @param {number}  xscale  x-scale to draw at
	/// @param {number}  yscale  y-scale to draw at
	/// @param {int}  colour  blending to apply to this cell
	/// @param {number}  alpha  sets how transparent the cell should be drawn at 
    static draw_cell_1D_ext = function(_index, _subimg, _x, _y, _xscale, _yscale, _colour, _alpha) {
    	var _cell/*:SpriteAtlasCell*/ = cells[_index],
			_cellWidth = cellWidth - padding * 2,
			_cellHeight = cellHeight - padding * 2,
			_xoffset = (cellXOffset - padding) * _xscale,
			_yoffset = (cellYOffset - padding) * _yscale;
		
		draw_sprite_part_ext(sprite, _subimg, _cell[SpriteAtlasCell.sheetX] + padding, _cell[SpriteAtlasCell.sheetY] + padding, _cellWidth, _cellHeight, _x - _xoffset, _y - _yoffset, _xscale, _yscale, _colour, _alpha);
    };
    
    #endregion
    
    #region Initialize
    
    var _spriteWidth = spriteWidth,
        _spriteHeight = spriteHeight,
        _fullCellWidth = cellWidth + margin,
        _fullCellHeight = cellHeight + margin;
    
    while (_spriteWidth >= cellWidth) {
        _spriteWidth -= (cellWidth + margin);
        columns++;
    }
    while (_spriteHeight >= cellHeight) {
        _spriteHeight -= (cellHeight + margin);
        rows++;
    }
    
    cells = array_create(rows * columns);
    for (var j = 0; j < rows; j++) {
        for (var i = 0; i < columns; i++)
            cells[i + j * columns] = [border + _fullCellWidth * i, border + _fullCellHeight * j, i, j];
    }
    
    #endregion
}
