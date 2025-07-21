/// === SINGLETON ===
/// @func ColourReplacer()
/// @desc A system designed to allow for the change of a sprite's colours on the fly.
///		  There are two ways the Replacer can work:
///		  - RGB: Given a set of "input" colours, all matching pixels will be swapped out for a se of "output" colours
///		  - Greyscale: For each pixel on said sprite, its grey-ness will determine what colour from the Replacer's colour is assigned to it.
///
///       NOTE: This uses a shader. It will not work if your system doesn't support shaders.
function ColourReplacer() constructor {
	ENFORCE_SINGLETON
   
	#region Static Data
    
    /// Boolean to check if this shader works on the current system
	static isSupported = shaders_are_supported();
	
	// Shader Uniforms
	static uniforms = [
		{ // ColourReplacerMode.GREYSCALE
			coloursR: shader_get_uniform(shdReplaceColourGreyscale, "u_coloursR"),
			coloursG: shader_get_uniform(shdReplaceColourGreyscale, "u_coloursG"),
			coloursB: shader_get_uniform(shdReplaceColourGreyscale, "u_coloursB"),
			count: shader_get_uniform(shdReplaceColourGreyscale, "u_colourCount")
		},
		{ // ColourReplacerMode.RGB
			inputColoursR: shader_get_uniform(shdReplaceColourRGB, "u_inputColoursR"),
			inputColoursG: shader_get_uniform(shdReplaceColourRGB, "u_inputColoursG"),
			inputColoursB: shader_get_uniform(shdReplaceColourRGB, "u_inputColoursB"),
			outputColoursR: shader_get_uniform(shdReplaceColourRGB, "u_outputColoursR"),
			outputColoursG: shader_get_uniform(shdReplaceColourRGB, "u_outputColoursG"),
			outputColoursB: shader_get_uniform(shdReplaceColourRGB, "u_outputColoursB"),
			count: shader_get_uniform(shdReplaceColourRGB, "u_colourCount")
		},
		{ // ColourReplacerMode.RGB_SINGLE
			inputColour: shader_get_uniform(shdReplaceColourRGBSingle, "u_inputColour"),
			outputColour: shader_get_uniform(shdReplaceColourRGBSingle, "u_outputColour")
		},
	];
	
	// Shader for each colour mode
	static shaderLookup = [ shdReplaceColourGreyscale, shdReplaceColourRGB, shdReplaceColourRGBSingle ];
	static shaderCompiled = array_map(shaderLookup, function(_shd, i) /*=>*/ {return shader_is_compiled(_shd)});
    
    #endregion
    
    #region Variables
    
    active = false;
    colourCount = COLOUR_REPLACER_MAX_COLOURS;
    colourMode = ColourReplacerMode.GREYSCALE;
    
    inputColoursR = array_create(COLOUR_REPLACER_MAX_COLOURS);
    inputColoursG = array_create(COLOUR_REPLACER_MAX_COLOURS);
    inputColoursB = array_create(COLOUR_REPLACER_MAX_COLOURS);
    
    outputColoursR = array_create(COLOUR_REPLACER_MAX_COLOURS);
    outputColoursG = array_create(COLOUR_REPLACER_MAX_COLOURS);
    outputColoursB = array_create(COLOUR_REPLACER_MAX_COLOURS);
    
    #endregion
    
    #region Functions - Activate/Deactivate
    
    /// @method activate(mode)
    /// @desc Activates the colour replace shader
    /// 	  All future draws will be affected by the shader
    ///
	/// @param {int}  mode  The colour mode to use (Greyscale, RGB, RGB (Single))
    ///
	/// @returns {ColourReplacer}  A reference to this struct. Useful for method chaining.
    static activate = function(_mode = colourMode) {
		if (!active && self.is_mode_supported(_mode)) {
			active = true;
			colourMode = _mode;
			shader_set(shaderLookup[_mode]);
		}
        return self;
    };
    
    /// @method deactivate()
    /// @desc Deactivates the colour replace shader
    /// 	  Call this once you are done using this shader
    ///
	/// @returns {ColourReplacer}  A reference to this struct. Useful for method chaining.
    static deactivate = function() {
		if (active) {
			shader_reset();
			active = false;
		}
		return self;
    };
    
    #endregion
    
    #region Functions - Applying Colours
    
    /// @method apply_input_colours(colours)
    /// @desc Applies the given array of colours to the ColourReplacer as input
    ///
	/// @param {array<int>}  colours  Array of input colours to apply
	///
	/// @returns {ColourReplacer}  A reference to this struct. Useful for method chaining.
    static apply_input_colours = function(_colours) {
		var _length = min(array_length(_colours), COLOUR_REPLACER_MAX_COLOURS),
			i = 0;
		repeat(_length) {
			var _normalizedColour = colour_normalize(_colours[i]);
			inputColoursR[i] = _normalizedColour[ColourChannels.red];
			inputColoursG[i] = _normalizedColour[ColourChannels.green];
			inputColoursB[i] = _normalizedColour[ColourChannels.blue];
			i++;
		}
		
		return self;
    };
    
    /// @method apply_input_colour_at(index, colour)
    /// @desc Applies the input colour to the specified index of the ColourReplacer
    ///
	/// @returns {ColourReplacer}  A reference to this struct. Useful for method chaining.
    static apply_input_colour_at = function(_index, _colour) {
		if (!in_range(_index, 0, COLOUR_REPLACER_MAX_COLOURS)) {
			show_debug_message($"ColourReplacer Warning: Trying to apply an out-of-range index ({_index})");
			return;
		}
		
		var _normalizedColour = colour_normalize(_colour);
		inputColoursR[_index] = _normalizedColour[ColourChannels.red];
		inputColoursG[_index] = _normalizedColour[ColourChannels.green];
		inputColoursB[_index] = _normalizedColour[ColourChannels.blue];
		
		return self;
    };
    
    /// @method apply_output_colours(colours)
    /// @desc Applies the given array of colours to the ColourReplacer as output
    ///
	/// @param {array<int>}  colours  Array of output colours to apply
	///
	/// @returns {ColourReplacer}  A reference to this struct. Useful for method chaining.
    static apply_output_colours = function(_colours) {
		var _length = min(array_length(_colours), COLOUR_REPLACER_MAX_COLOURS),
			i = 0;
		repeat(_length) {
			var _normalizedColour = colour_normalize(_colours[i]);
			outputColoursR[i] = _normalizedColour[ColourChannels.red];
			outputColoursG[i] = _normalizedColour[ColourChannels.green];
			outputColoursB[i] = _normalizedColour[ColourChannels.blue];
			i++;
		}
		
		return self;
    };
    
    /// @method apply_output_colour_at(index, colour)
    /// @desc Applies the output colour to the specified index of the ColourReplacer
    ///
	/// @returns {ColourReplacer}  A reference to this struct. Useful for method chaining.
    static apply_output_colour_at = function(_index, _colour) {
		if (!in_range(_index, 0, COLOUR_REPLACER_MAX_COLOURS)) {
			show_debug_message($"ColourReplacer Warning: Trying to apply an out-of-range index ({_index})");
			return;
		}
		
		var _normalizedColour = colour_normalize(_colour);
		outputColoursR[_index] = _normalizedColour[ColourChannels.red];
		outputColoursG[_index] = _normalizedColour[ColourChannels.green];
		outputColoursB[_index] = _normalizedColour[ColourChannels.blue];
		
		return self;
    };
    
    /// @method apply_palette(palette)
    /// @desc Updates ColourReplacer using the given ColourPalette
    ///
	/// @param {ColourPalette}  palette  The `ColourPalette` to apply
	///
	/// @returns {ColourReplacer}  A reference to this struct. Useful for method chaining.
    static apply_palette = function(_palette) {
		var i = 0;
		repeat(_palette.colourCount) {
			inputColoursR[i] = _palette.inputColoursR[i];
			inputColoursG[i] = _palette.inputColoursG[i];
			inputColoursB[i] = _palette.inputColoursB[i];
			outputColoursR[i] = _palette.outputColoursR[i];
			outputColoursG[i] = _palette.outputColoursG[i];
			outputColoursB[i] = _palette.outputColoursB[i];
			i++;
		}
		colourMode = _palette.colourMode;
		colourCount = _palette.colourCount;
		return self;
    };
    
    #endregion
    
    #region Functions - Colour Altering
    
    /// @method brighten(factor)
	/// @desc Brightens all output colours currently in the ColourReplacer
	///
	/// @param {number}  factor  How much to brighten the colours
	///
	/// @returns {ColourReplacer}  A reference to this struct. Useful for method chaining.
    static brighten = function(_factor) {
		var i = 0;
		repeat(COLOUR_REPLACER_MAX_COLOURS) {
			outputColoursR[i] += (1 - outputColoursR[i]) * _factor;
			outputColoursG[i] += (1 - outputColoursG[i]) * _factor;
			outputColoursB[i] += (1 - outputColoursB[i]) * _factor;
			i++;
		}
		return self;
    }
    
    /// @method darken(factor)
	/// @desc Darkens all output colours currently in the ColourReplacer
	///
	/// @param {number}  factor  How much to darken the colours
	///
	/// @returns {ColourReplacer}  A reference to this struct. Useful for method chaining.
    static darken = function(_factor) {
		var i = 0;
		repeat(COLOUR_REPLACER_MAX_COLOURS) {
			outputColoursR[i] *= (1 - _factor);
			outputColoursG[i] *= (1 - _factor);
			outputColoursB[i] *= (1 - _factor);
			i++;
		}
		return self;
    }
    
    /// @method greyscale()
	/// @desc Converts all output colours currently in the ColourReplacer to a greyscale equivalent
	///
	/// @returns {ColourReplacer}  A reference to this struct. Useful for method chaining.
    static greyscale = function() {
		var i = 0;
		repeat(COLOUR_REPLACER_MAX_COLOURS) {
			var _grey = dot_product_3d(outputColoursR[i], outputColoursG[i], outputColoursB[i], 0.299, 0.587, 0.114);
			outputColoursR[i] = _grey;
			outputColoursG[i] = _grey;
			outputColoursB[i] = _grey;
			i++;
		}
		return self;
    }
    
    /// @method invert()
	/// @desc Inverts all output colours currently in the ColourReplacer
	///
	/// @returns {ColourReplacer}  A reference to this struct. Useful for method chaining.
    static invert = function() {
		var i = 0;
		repeat(COLOUR_REPLACER_MAX_COLOURS) {
			outputColoursR[i] = (1 - outputColoursR[i]);
			outputColoursG[i] = (1 - outputColoursG[i]);
			outputColoursB[i] = (1 - outputColoursB[i]);
			i++;
		}
		return self;
    }
    
    #endregion
    
    #region Functions - Other
    
    /// @method is_mode_supported(mode)
    /// @desc Checks if the specified colour mode is possible
    static is_mode_supported = function(_mode = colourMode) {
		return isSupported && (array_at(shaderCompiled, _mode) ?? false);
    };
    
    /// @method set_colour_count(number)
    /// @desc Sets the number of colours this system is replacing at once
    ///
	/// @returns {ColourReplacer}  A reference to this struct. Useful for method chaining.
    static set_colour_count = function(_number) {
		colourCount = clamp(_number, 1, COLOUR_REPLACER_MAX_COLOURS);
		return self;
    };
    
    /// @method set_colour_mode(mode)
    /// @desc Sets the current colour mode
    ///
	/// @returns {ColourReplacer}  A reference to this struct. Useful for method chaining.
    static set_colour_mode = function(_mode) {
		colourMode = clamp(_mode, 0, ColourReplacerMode.COUNT - 1);
		return self;
    };
    
    /// @method update_uniforms()
    /// @desc Updates the values of the uniforms in the shader
    ///
	/// @returns {ColourReplacer}  A reference to this struct. Useful for method chaining.
    static update_uniforms = function() {
		var _uni = uniforms[colourMode];
		
		switch (colourMode) {
			case ColourReplacerMode.GREYSCALE:
				shader_set_uniform_f_array(_uni.coloursR, outputColoursR);
				shader_set_uniform_f_array(_uni.coloursG, outputColoursG);
				shader_set_uniform_f_array(_uni.coloursB, outputColoursB);
				shader_set_uniform_i(_uni.count, colourCount);
				break;
			case ColourReplacerMode.RGB:
				shader_set_uniform_f_array(_uni.inputColoursR, inputColoursR);
				shader_set_uniform_f_array(_uni.inputColoursG, inputColoursG);
				shader_set_uniform_f_array(_uni.inputColoursB, inputColoursB);
				shader_set_uniform_f_array(_uni.outputColoursR, outputColoursR);
				shader_set_uniform_f_array(_uni.outputColoursG, outputColoursG);
				shader_set_uniform_f_array(_uni.outputColoursB, outputColoursB);
				shader_set_uniform_i(_uni.count, colourCount);
				break;
			case ColourReplacerMode.RGB_SINGLE:
				shader_set_uniform_f(_uni.inputColour, inputColoursR[0], inputColoursG[0], inputColoursB[0]);
				shader_set_uniform_f(_uni.outputColour, outputColoursR[0], outputColoursG[0], outputColoursB[0]);
				break;
		}
		
		return self;
    };
    
    #endregion
}

/// @func colour_replacer()
/// @desc Returns a static instance of ColourReplacer
///
/// @returns {ColourReplacer}  A reference to this ColourReplacer static.
function colour_replacer() {
	static _instance = new ColourReplacer();
	return _instance;
}
