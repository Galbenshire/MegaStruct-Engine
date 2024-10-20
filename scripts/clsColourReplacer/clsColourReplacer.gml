/// === SINGLETON ===
/// @func ColourReplacer()
/// @desc A system designed to allow for the change of a sprite's colours on the fly.
///		  For each pixel on said sprite, its grey-ness will determine what colour from the replacer's assigned palette is assigned to it.
///		  A near pure-white pixel will use the first colour in the palette, with the last colour applied to a almost pitch-black pixel.
///
///       NOTE: This uses a shader. It will not work if your system doesn't support shaders.
function ColourReplacer() constructor {
	ENFORCE_SINGLETON
   
	#region Constants (in spirit)
    
    /// Boolean to check if this shader works on the current system
	static IS_SUPPORTED = shaders_are_supported() && shader_is_compiled(shdReplaceColour);
    
    #endregion
    
	#region Shader Uniforms
    
    u_ColoursR = shader_get_uniform(shdReplaceColour, "u_coloursR");
    u_ColoursG = shader_get_uniform(shdReplaceColour, "u_coloursG");
    u_ColoursB = shader_get_uniform(shdReplaceColour, "u_coloursB");
    
    #endregion
    
    #region Variables
    
    active = false;
    coloursR = array_create(COLOUR_REPLACER_MAX_COLOURS);
    coloursG = array_create(COLOUR_REPLACER_MAX_COLOURS);
    coloursB = array_create(COLOUR_REPLACER_MAX_COLOURS);
    
    #endregion
    
    #region Functions - Activate/Deactivate
    
    /// @method activate()
    /// @desc Activates the colour replace shader
    /// 	  All future draws will be affected by the shader
    static activate = function() {
        if (!IS_SUPPORTED || active)
            return;
        active = true;
        shader_set(shdReplaceColour);
    };
    
    /// @method deactivate()
    /// @desc Deactivates the colour replace shader
    /// 	  Call this once you are done using this shader
    static deactivate = function() {
        if (!active)
            return;
        shader_reset();
        active = false;
    };
    
    #endregion
    
    #region Functions - Applying Colours
    
    /// @method apply_colours(colours)
    /// @desc Applies the given array of colours to the ColourReplacer
    ///
	/// @param {array<int>}  colours  Array of colours to apply
    static apply_colours = function(_colours) {
		var i = 0;
		repeat(min(array_length(_colours), COLOUR_REPLACER_MAX_COLOURS)) {
			var _normalizedColour = normalize_colour(_colours[i]);
			coloursR[i] = _normalizedColour[ColourChannels.red];
			coloursG[i] = _normalizedColour[ColourChannels.green];
			coloursB[i] = _normalizedColour[ColourChannels.blue];
			i++;
		}
		
		if (active)
			self.update_uniforms();
    };
    
    /// @method apply_colour_at(index, colour)
    /// @desc Applies the colour to the specified index of the ColourReplacer
    static apply_colour_at = function(_index, _colour) {
		if (!in_range(_index, 0, COLOUR_REPLACER_MAX_COLOURS)) {
			show_debug_message($"ColourReplacer Warning: Trying to apply an out-of-range index ({_index})");
			return;
		}
		
		var _normalizedColour = normalize_colour(_colour);
		coloursR[_index] = _normalizedColour[ColourChannels.red];
		coloursG[_index] = _normalizedColour[ColourChannels.green];
		coloursB[_index] = _normalizedColour[ColourChannels.blue];
		
		if (active)
			self.update_uniforms();
    };
    
    /// @method apply_palette(palette)
    /// @desc Applies the colours from a `ColourPalette` instance to the ColourReplacer
    ///
	/// @param {ColourPalette}  palette  The `ColourPalette` to apply
    static apply_palette = function(_palette) {
		var i = 0;
		repeat(_palette.colourCount) {
			coloursR[i] = _palette.coloursR[i];
			coloursG[i] = _palette.coloursG[i];
			coloursB[i] = _palette.coloursB[i];
			i++;
		}
		
		if (active)
			self.update_uniforms();
    };
    
    #endregion
    
    #region Functions - Colour Altering
    
    /// @method brighten(factor)
	/// @desc Brightens all colours currently in the ColourReplacer
    static brighten = function(_factor) {
		var i = 0;
		repeat(COLOUR_REPLACER_MAX_COLOURS) {
			coloursR[i] += (1 - coloursR[i]) * _factor;
			coloursG[i] += (1 - coloursG[i]) * _factor;
			coloursB[i] += (1 - coloursB[i]) * _factor;
			i++;
		}
		
		if (active)
			self.update_uniforms();
    }
    
    /// @method darken(factor)
	/// @desc Darkens all colours currently in the ColourReplacer
    static darken = function(_factor) {
		_factor = 1 - _factor;
		
		var i = 0;
		repeat(COLOUR_REPLACER_MAX_COLOURS) {
			coloursR[i] *= _factor;
			coloursG[i] *= _factor;
			coloursB[i] *= _factor;
			i++;
		}
		
		if (active)
			self.update_uniforms();
    }
    
    /// @method greyscale()
	/// @desc Converts all colours currently in the ColourReplacer to a greyscale equivalent
    static greyscale = function() {
		var i = 0;
		repeat(COLOUR_REPLACER_MAX_COLOURS) {
			var _grey = dot_product_3d_normalized(coloursR[i], coloursG[i], coloursB[i], 0.299, 0.587, 0.114);
			coloursR[i] = _grey;
			coloursG[i] = _grey;
			coloursB[i] = _grey;
			i++;
		}
		
		if (active)
			self.update_uniforms();
    }
    
    /// @method invert()
	/// @desc Inverts all colours currently in the ColourReplacer
    static invert = function() {
    	var i = 0;
		repeat(COLOUR_REPLACER_MAX_COLOURS) {
			coloursR[i] = (1 - coloursR[i]);
			coloursG[i] = (1 - coloursG[i]);
			coloursB[i] = (1 - coloursB[i]);
			i++;
		}
		
		if (active)
			self.update_uniforms();
    }
    
    #endregion
    
    #region Functions - Other
    
    /// @method update_uniforms()
    /// @desc Updates the values of the uniforms in the shader
    static update_uniforms = function() {
		shader_set_uniform_f_array(u_ColoursR, coloursR);
		shader_set_uniform_f_array(u_ColoursG, coloursG);
		shader_set_uniform_f_array(u_ColoursB, coloursB);
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
