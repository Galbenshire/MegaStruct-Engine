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
    
    u_Colours = shader_get_uniform(shdReplaceColour, "u_colours");
    
    #endregion
    
    #region Variables
    
    active = false;
    colourUniforms = array_create(COLOUR_REPLACER_MAX_COLOURS * ColourChannels.sizeof);
    
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
    
    #region Functions - Other
    
    /// @method apply_colours(colours)
    /// @desc Applies the given array of colours to the ColourReplacer
    ///
	/// @param {array<int>}  colours  Array of colours to apply
    static apply_colours = function(_colours) {
		var _count = min(array_length(_colours), COLOUR_REPLACER_MAX_COLOURS),
			i = 0;
		repeat(_count) {
			var _index = i * ColourChannels.sizeof,
				_normalizedColour = normalize_colour(_colours[i]);
			colourUniforms[_index + ColourChannels.red] = _normalizedColour[ColourChannels.red];
			colourUniforms[_index + ColourChannels.green] = _normalizedColour[ColourChannels.green];
			colourUniforms[_index + ColourChannels.blue] = _normalizedColour[ColourChannels.blue];
			i++;
		}
		if (active)
			self.update_uniforms();
    };
    
    /// @method apply_colour_uniforms(uniforms)
    /// @desc Applies the given array of colour uniform values to the ColourReplacer
    ///
	/// @param {array<number>}  uniforms  Array of colour uniform values to apply
    static apply_colour_uniforms = function(_uniforms) {
		var _count = min(array_length(_uniforms), COLOUR_REPLACER_MAX_COLOURS * ColourChannels.sizeof),
			i = 0;
		repeat(_count) {
			colourUniforms[i] = _uniforms[i];
			i++;
		}
		if (active)
			self.update_uniforms();
    };
    
    /// @method apply_palette(palette)
    /// @desc Applies the colours from a `ColourReplacerPalette` instance to the ColourReplacer
    ///
	/// @param {ColourReplacerPalette}  palette  The `ColourReplacerPalette` to apply
    static apply_palette = function(_palette) {
		self.apply_colour_uniforms(_palette.colourUniforms);
    };
    
    /// @method update_uniforms()
    /// @desc Updates the values of the uniforms in the shader
    static update_uniforms = function() {
		shader_set_uniform_f_array(u_Colours, colourUniforms);	
    };
    
    #endregion
}

/// @func ColourReplacerPalette(colours)
/// @desc Represents a palette to be used by `ColourReplacer`
///
/// @param {array<int>}  colours  Array of colours in the palette
function ColourReplacerPalette(_cols) constructor {
	
	#region Variables
    
    colourCount = min(array_length(_cols), COLOUR_REPLACER_MAX_COLOURS);
    colours = array_create(colourCount); /// @is {array<int>}
    colourUniforms = array_create(colourCount * ColourChannels.sizeof); /// @is {array<number>}

    #endregion
    
    #region Functions
    
    /// @method copy_colours()
	/// @desc Gets a copy of the colours in this palette.
	/// 	  Any changes to this returned array will not affect the original values.
	///
	/// @returns {array<int>}  The copy of the palette colours
    static copy_colours = function() {
        return variable_clone(colours);
    };
    
    /// @method copy_colour_uniforms()
	/// @desc Gets a copy of the uniform values in this palette.
	/// 	  Any changes to this returned array will not affect the original values.
	///
	/// @returns {array<int>}  The copy of the uniform values of the palette colours
    static copy_colour_uniforms = function() {
        return variable_clone(colourUniforms);
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
    
    /// @method set_colours(colours, offset)
	/// @desc Sets multiple colours across the palette
	///
	/// @param {array<int>}  colours  The new colours to apply
	/// @param {int}  [offset]  At which index to start applying the new colours. Defaults to 0
    static set_colours = function(_colours, _offset = 0) {
		var _count = array_length(_colours);
		for (var i = 0; i < _count; i++) {
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
		if (_index >= colourCount) {
			show_debug_message("ColourReplacerPalette Warning: Trying to set an unused index");
			return;	
		}
		
        colours[_index] = _colour;
        
        var _uniformIndex = _index * ColourChannels.sizeof,
			_normalizedColour = normalize_colour(_colour);
        colourUniforms[_uniformIndex + ColourChannels.red] = _normalizedColour[ColourChannels.red];
		colourUniforms[_uniformIndex + ColourChannels.green] = _normalizedColour[ColourChannels.green];
		colourUniforms[_uniformIndex + ColourChannels.blue] = _normalizedColour[ColourChannels.blue];
    };
    
    #endregion
    
	#region Initialization
	
	for (var i = 0; i < colourCount; i++)
        self.set_colour_at(i, _cols[i]);
    
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
