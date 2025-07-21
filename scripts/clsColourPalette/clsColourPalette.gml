/// @func ColourPalette(output_colours, input_colours)
/// @desc Represents a palette of colours.
///
/// @param {array<int>}  output_colours  Array of the colours this palette will display
/// @param {array<int>}  [input_colours]  Array of the colours this palette will "replace".
///										  If not defined, this palette will be in Greyscale mode
function ColourPalette(_outputCols, _inputCols = []) constructor {
    #region Variables
    
    colourCount = min(array_length(_outputCols), COLOUR_REPLACER_MAX_COLOURS);
    colourMode = ColourReplacerMode.GREYSCALE;
    
    // The colours this palette will output (& optionally, the colours they'd replace)
    outputColours = array_create(colourCount); /// @is {array<int>}
    inputColours = array_create(colourCount); /// @is {array<int>}
    
    // Colours split up by their components, mapped to a [0-1] range
    outputColoursR = array_create(colourCount); /// @is {array<number>}
    outputColoursG = array_create(colourCount); /// @is {array<number>}
    outputColoursB = array_create(colourCount); /// @is {array<number>}
    //
    inputColoursR = array_create(colourCount); /// @is {array<number>}
    inputColoursG = array_create(colourCount); /// @is {array<number>}
    inputColoursB = array_create(colourCount); /// @is {array<number>}

    #endregion
    
    #region Functions - Copying/Getters
    
    /// @method copy_input_colours()
	/// @desc Gets a copy of the input colours in this palette.
	/// 	  Any changes to this returned array will not affect the original values.
	///
	/// @returns {array<int>}  The copy of the input colours
    static copy_input_colours = function() {
        return variable_clone(inputColours);
    };
    
    /// @method copy_output_colours()
	/// @desc Gets a copy of the output colours in this palette.
	/// 	  Any changes to this returned array will not affect the original values.
	///
	/// @returns {array<int>}  The copy of the output colours
    static copy_output_colours = function() {
        return variable_clone(outputColours);
    };
    
    /// @method get_input_colour_at(index)
	/// @desc Gets the input colour at the specified index
	///
	/// @param {int}  index  The index to get
	///
	/// @returns {int}  The input colour at the specified index
    static get_input_colour_at = function(_index) {
		_index = clamp(_index, 0, colourCount);
		return inputColours[_index];
    };
    
    /// @method get_input_colour_channels_at(index)
	/// @desc Gets the RGB components of the input colour at the specified index
	///
	/// @param {int}  index  The index to get
	///
	/// @returns {ColourChannels}  The components of the input colour at the specified index
    static get_input_colour_channels_at = function(_index) {
		_index = clamp(_index, 0, colourCount);
		return [ inputColoursR[_index], inputColoursG[_index], inputColoursB[_index] ];
    };
    
    /// @method get_output_colour_at(index)
	/// @desc Gets the output colour at the specified index
	///
	/// @param {int}  index  The index to get
	///
	/// @returns {int}  The output colour at the specified index
    static get_output_colour_at = function(_index) {
		_index = clamp(_index, 0, colourCount);
		return outputColours[_index];
    };
    
    /// @method get_output_colour_channels_at(index)
	/// @desc Gets the RGB components of the output colour at the specified index
	///
	/// @param {int}  index  The index to get
	///
	/// @returns {ColourChannels}  The components of the output colour at the specified index
    static get_output_colour_channels_at = function(_index) {
		_index = clamp(_index, 0, colourCount);
		return [ outputColoursR[_index], outputColoursG[_index], outputColoursB[_index] ];
    };
    
    #endregion
    
    #region Functions - Setters
    
    /// @method set_input_colours(colours, offset)
	/// @desc Sets multiple input colours across the palette
	///
	/// @param {array<int>}  colours  The new input colours to apply
	/// @param {int}  [offset]  At which index to start applying the new colours. Defaults to 0
	///
	/// @returns {ColourPalette}  A reference to this struct. Useful for method chaining.
    static set_input_colours = function(_colours, _offset = 0) {
		var i = 0;
		repeat(array_length(_colours)) {
			if (i + _offset >= colourCount)
				break;
			self.set_input_colour_at(i + _offset, _colours[i]);
			i++;
		}
		return self;
    };
    
    /// @method set_input_colour_at(index, colour)
	/// @desc Sets a specific index in the palette's input to the given colour
	///
	/// @param {int}  index  The index to target
	/// @param {int}  colour  The colour to set to
	///
	/// @returns {ColourPalette}  A reference to this struct. Useful for method chaining.
    static set_input_colour_at = function(_index, _colour) {
		if (!in_range(_index, 0, colourCount)) {
			show_debug_message($"ColourPalette Warning: Trying to set an out-of-range index ({_index})");
			return;	
		}
		
        var _normalizedColour = colour_normalize(_colour);
        inputColoursR[_index] = _normalizedColour[ColourChannels.red];
		inputColoursG[_index] = _normalizedColour[ColourChannels.green];
		inputColoursB[_index] = _normalizedColour[ColourChannels.blue];
		inputColours[_index] = _colour;
		return self;
    };
    
    /// @method set_output_colours(colours, offset)
	/// @desc Sets multiple output colours across the palette
	///
	/// @param {array<int>}  colours  The new output colours to apply
	/// @param {int}  [offset]  At which index to start applying the new colours. Defaults to 0
	///
	/// @returns {ColourPalette}  A reference to this struct. Useful for method chaining.
    static set_output_colours = function(_colours, _offset = 0) {
		var i = 0;
		repeat(array_length(_colours)) {
			if (i + _offset >= colourCount)
				break;
			self.set_output_colour_at(i + _offset, _colours[i]);
			i++;
		}
		return self;
    };
    
    /// @method set_output_colour_at(index, colour)
	/// @desc Sets a specific index in the palette's output to the given colour
	///
	/// @param {int}  index  The index to target
	/// @param {int}  colour  The colour to set to
	///
	/// @returns {ColourPalette}  A reference to this struct. Useful for method chaining.
    static set_output_colour_at = function(_index, _colour) {
		if (!in_range(_index, 0, colourCount)) {
			show_debug_message($"ColourPalette Warning: Trying to set an out-of-range index ({_index})");
			return;	
		}
		
        var _normalizedColour = colour_normalize(_colour);
        outputColoursR[_index] = _normalizedColour[ColourChannels.red];
		outputColoursG[_index] = _normalizedColour[ColourChannels.green];
		outputColoursB[_index] = _normalizedColour[ColourChannels.blue];
		outputColours[_index] = _colour;
		return self;
    };
    
    #endregion
    
    #region Functions - Colour Altering
    
    /// @method brighten(factor)
	/// @desc Brightens all output colours in the palette
	///
	/// @param {number}  factor  How much to brighten the colours
	///
	/// @returns {ColourPalette}  A reference to this struct. Useful for method chaining.
    static brighten = function(_factor) {
		for (var i = 0; i < colourCount; i++)
			self.brighten_at(i, _factor);
		return self;
    }
    
    /// @method brighten_at(index, factor)
	/// @desc Brightens the output colour at the specified index
	///
	/// @param {int}  index  The index to target
	/// @param {number}  factor  How much to brighten the colour
	///
	/// @returns {ColourPalette}  A reference to this struct. Useful for method chaining.
    static brighten_at = function(_index, _factor) {
        if (!in_range(_index, 0, colourCount)) {
			show_debug_message($"ColourPalette Warning: Trying to brighten an out-of-range index ({_index})");
			return;	
		}
		
		outputColoursR[_index] += (1 - outputColoursR[_index]) * _factor;
		outputColoursG[_index] += (1 - outputColoursG[_index]) * _factor;
		outputColoursB[_index] += (1 - outputColoursB[_index]) * _factor;
		outputColours[_index] = make_colour_channels(outputColoursR[_index], outputColoursG[_index], outputColoursB[_index]);
		return self;
    };
    
    /// @method darken(factor)
	/// @desc Darkens all output colours in the palette
	///
	/// @param {number}  factor  How much to darken the colours
	///
	/// @returns {ColourPalette}  A reference to this struct. Useful for method chaining.
    static darken = function(_factor) {
		for (var i = 0; i < colourCount; i++)
			self.darken_at(i, _factor);
		return self;
    }
    
    /// @method darken_at(index, factor)
	/// @desc Darkens the output colour at the specified index
	///
	/// @param {int}  index  The index to target
	/// @param {number}  factor  How much to darken the colour
	///
	/// @returns {ColourPalette}  A reference to this struct. Useful for method chaining.
    static darken_at = function(_index, _factor) {
        if (!in_range(_index, 0, colourCount)) {
			show_debug_message($"ColourPalette Warning: Trying to brighten an out-of-range index ({_index})");
			return;	
		}
		
		outputColoursR[_index] *= (1 - _factor);
		outputColoursG[_index] *= (1 - _factor);
		outputColoursB[_index] *= (1 - _factor);
		outputColours[_index] = make_colour_channels(outputColoursR[_index], outputColoursG[_index], outputColoursB[_index]);
		return self;
    };
    
    /// @method greyscale()
	/// @desc Converts all output colours in the palette into a greyscale version
	///
	/// @returns {ColourPalette}  A reference to this struct. Useful for method chaining.
    static greyscale = function() {
		for (var i = 0; i < colourCount; i++)
			self.greyscale_at(i);
		return self;
    }
    
    /// @method greyscale_at(index)
	/// @desc Converts the output colour at the specified index into a greyscale version
	///
	/// @param {int}  index  The index to target
	///
	/// @returns {ColourPalette}  A reference to this struct. Useful for method chaining.
    static greyscale_at = function(_index) {
        if (!in_range(_index, 0, colourCount)) {
			show_debug_message($"ColourPalette Warning: Trying to greyscale an out-of-range index ({_index})");
			return;	
		}
		
		var _grey = dot_product_3d(outputColoursR[_index], outputColoursG[_index], outputColoursB[_index], 0.299, 0.587, 0.114);
		outputColoursR[_index] = _grey;
		outputColoursG[_index] = _grey;
		outputColoursB[_index] = _grey;
		outputColours[_index] = make_colour_channels(_grey, _grey, _grey);
		return self;
    };
    
    #endregion
    
    #region Initialization
    
    // Determine Colour Mode
	if (array_empty(_inputCols))
		colourMode = ColourReplacerMode.GREYSCALE;
	else if (colourCount == 1)
		colourMode = ColourReplacerMode.RGB_SINGLE;
	else
		colourMode = ColourReplacerMode.RGB;
	
	// Now apply the colours
	self.set_output_colours(_outputCols);
	self.set_input_colours(_inputCols);
    
    #endregion
}
