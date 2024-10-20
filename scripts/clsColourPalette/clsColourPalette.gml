/// @func ColourPalette(colours)
/// @desc Represents a palette of colours.
///
/// @param {array<int>}  colours  Array of colours in the palette
function ColourPalette(_cols) constructor {
    #region Variables
    
    colourCount = min(array_length(_cols), COLOUR_REPLACER_MAX_COLOURS);
    colours = array_create(colourCount); /// @is {array<int>}
    
    // Colours split up by their components, mapped to a [0-1] range
    coloursR = array_create(colourCount); /// @is {array<number>}
    coloursG = array_create(colourCount); /// @is {array<number>}
    coloursB = array_create(colourCount); /// @is {array<number>}

    #endregion
    
    #region Functions - Copying/Getters
    
    /// @method copy_colours()
	/// @desc Gets a copy of the colours in this palette.
	/// 	  Any changes to this returned array will not affect the original values.
	///
	/// @returns {array<int>}  The copy of the palette colours
    static copy_colours = function() {
        return variable_clone(colours);
    };
    
    /// @method get_colour_at(index)
	/// @desc Gets the colour at the specified index
	///
	/// @param {int}  index  The index to get
	///
	/// @returns {int}  The colour at the specified index
    static get_colour_at = function(_index) {
		_index = clamp(_index, 0, colourCount);
		return colours[_index];
    };
    
    /// @method get_colour_channels_at(index)
	/// @desc Gets the RGB components of the colour at the specified index
	///
	/// @param {int}  index  The index to get
	///
	/// @returns {ColourChannels}  The components of the colour at the specified index
    static get_colour_channels_at = function(_index) {
		_index = clamp(_index, 0, colourCount);
		return [ coloursR[_index], coloursG[_index], coloursB[_index] ];
    };
    
    #endregion
    
    #region Functions - Setters
    
    /// @method set_colours(colours, offset)
	/// @desc Sets multiple colours across the palette
	///
	/// @param {array<int>}  colours  The new colours to apply
	/// @param {int}  [offset]  At which index to start applying the new colours. Defaults to 0
    static set_colours = function(_colours, _offset = 0) {
		for (var i = 0, n = array_length(_colours); i < n; i++) {
			if (i + _offset >= colourCount)
				break;
			self.set_colour_at(i + _offset, _colours[i]);
		}
    };
    
    /// @method set_colour_at(index, colour)
	/// @desc Sets a specific index in the palette to the given colour
	///
	/// @param {int}  index  The index to target
	/// @param {int}  colour  The colour to set to
    static set_colour_at = function(_index, _colour) {
		if (!in_range(_index, 0, colourCount)) {
			show_debug_message($"ColourPalette Warning: Trying to set an out-of-range index ({_index})");
			return;	
		}
		
        var _normalizedColour = normalize_colour(_colour);
        coloursR[_index] = _normalizedColour[ColourChannels.red];
		coloursG[_index] = _normalizedColour[ColourChannels.green];
		coloursB[_index] = _normalizedColour[ColourChannels.blue];
		colours[_index] = _colour;
    };
    
    #endregion
    
    #region Functions - Colour Altering
    
    /// @method brighten(factor)
	/// @desc Brightens all colours in the palette
    static brighten = function(_factor) {
		for (var i = 0; i < colourCount; i++)
			self.brighten_at(i, _factor);
    }
    
    /// @method brighten_at(index, factor)
	/// @desc Brightens the colour at the specified index
    static brighten_at = function(_index, _factor) {
        if (!in_range(_index, 0, colourCount)) {
			show_debug_message($"ColourPalette Warning: Trying to brighten an out-of-range index ({_index})");
			return;	
		}
		
		coloursR[_index] += (1 - coloursR[_index]) * _factor;
		coloursG[_index] += (1 - coloursG[_index]) * _factor;
		coloursB[_index] += (1 - coloursB[_index]) * _factor;
		colours[_index] = make_colour_channels(coloursR[_index], coloursG[_index], coloursB[_index]);
    };
    
    /// @method darken(factor)
	/// @desc Darkens all colours in the palette
    static darken = function(_factor) {
		for (var i = 0; i < colourCount; i++)
			self.darken_at(i, _factor);
    }
    
    /// @method darken_at(index, factor)
	/// @desc Darkens the colour at the specified index
    static darken_at = function(_index, _factor) {
        if (!in_range(_index, 0, colourCount)) {
			show_debug_message($"ColourPalette Warning: Trying to brighten an out-of-range index ({_index})");
			return;	
		}
		
		coloursR[_index] *= (1 - _factor);
		coloursG[_index] *= (1 - _factor);
		coloursB[_index] *= (1 - _factor);
		colours[_index] = make_colour_channels(coloursR[_index], coloursG[_index], coloursB[_index]);
    };
    
    /// @method greyscale(factor)
	/// @desc Converts all colours in the palette into a greyscale version
    static greyscale = function(_factor) {
		for (var i = 0; i < colourCount; i++)
			self.greyscale_at(i, _factor);
    }
    
    /// @method greyscale_at(index, factor)
	/// @desc Converts the colour at the specified index into a greyscale version
    static greyscale_at = function(_index, _factor) {
        if (!in_range(_index, 0, colourCount)) {
			show_debug_message($"ColourPalette Warning: Trying to greyscale an out-of-range index ({_index})");
			return;	
		}
		
		var _grey = dot_product_3d_normalized(coloursR[_index], coloursG[_index], coloursB[_index], 0.299, 0.587, 0.114);
		coloursR[_index] = _grey;
		coloursG[_index] = _grey;
		coloursB[_index] = _grey;
		colours[_index] = make_colour_channels(_grey, _grey, _grey);
    };
    
    #endregion
    
    #region Initialization
	
	self.set_colours(_cols);
    
    #endregion
}