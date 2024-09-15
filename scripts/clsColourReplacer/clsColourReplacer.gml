/// === SINGLETON ===
/// @func ColourReplacer()
/// @desc A system designed to allow for the change of a sprite's colours on the fly.
///       Given a list of input colours, it will replace them with a set of corresponding output colours.
///
///       NOTE: This uses a shader. It will not work if your system doesn't support shaders.
function ColourReplacer() constructor {
	ENFORCE_SINGLETON
   
	#region Constants (in spirit)
    
    /// Boolean to check if this shader works on the current system
	IS_SUPPORTED = shaders_are_supported() && shader_is_compiled(shdReplaceColour);
    
    #endregion
    
	#region Shader Uniforms
    
    u_InputColours = shader_get_uniform(shdReplaceColour, "u_inputColours");
    u_OutputColours = shader_get_uniform(shdReplaceColour, "u_outputColours");
    u_ColourCount = shader_get_uniform(shdReplaceColour, "u_colourCount");
    
    #endregion
    
    #region Variables
    
    active = false;
    palette = undefined; /// @is {ColourReplacerPalette?}
    
    #endregion
    
    #region Functions
    
    /// @method activate()
    /// @desc Activates the colour replace shader
    /// 	  All future draws will be affected by the shader
    static activate = function(_palette) {
        if (!IS_SUPPORTED)
            return;
        palette = _palette;
        palette.update_uniform_values();
        active = true;
        shader_set(shdReplaceColour);
        update_uniforms();
    };
    
    /// @method deactivate()
    /// @desc Deactivates the colour replace shader
    /// 	  Call this once you are done using this shader
    static deactivate = function() {
        if (!IS_SUPPORTED)
            return;
        shader_reset();
        active = false;
        palette = undefined;
    };
    
    /// @method is_active()
    /// @desc Checks if the Colour Replacer is active
    ///
	/// @returns {bool}  The colours to ouput after replacing
    static is_active = function() {
		return active && IS_SUPPORTED && (shader_current() == shdReplaceColour);	
    };
    
    /// @method update_uniforms()
    /// @desc Updates uniform values
    static update_uniforms = function() {
		if (!is_active() || is_undefined(palette))
			return;
		shader_set_uniform_f_array(u_InputColours, palette.__inputColourUniforms);
        shader_set_uniform_f_array(u_OutputColours, palette.__outputColourUniforms);
        shader_set_uniform_i(u_ColourCount, palette.colourCount);
    };
    
    #endregion
}

/// @func ColourReplacerPalette(input_colours, output_colours)
/// @desc Represents a set of colours to replace to another set of colours
///		  Supports up to 16 colours.
///
/// @param {array<int>}  input_colours  Array of the colours to replace.
/// @param {array<int>}  output_colours  Array of the colours after replacing.
function ColourReplacerPalette(_inputCols, _outputCols) constructor {
	#region Constants (in spirit)
    
    /// Components of a colour
    /// @static
    static COMPONENT_RED = 0;
    /// @static
    static COMPONENT_GREEN = 1;
    /// @static
    static COMPONENT_BLUE = 2;
    /// @static
    static COMPONENT_COUNT = 3;
    
    /// Maximum number of colours supported by the replacer
    /// @static
    static MAX_COLOURS = 16;
    
    #endregion
	
	#region Variables
    
    colourCount = 0;
    inputColours = []; /// @is {array<int>}
    outputColours = []; /// @is {array<int>}
    
    // The above two variables, processed into a state suitable to pass to the shader uniforms
    __inputColourUniforms = array_create(MAX_COLOURS * COMPONENT_COUNT, 0); /// @is {array<number>}
    __outputColourUniforms = array_create(MAX_COLOURS * COMPONENT_COUNT, 0); /// @is {array<number>}
    __isDirty = false;

    #endregion
    
    #region Functions - Copying
    
    /// @method copy_colours_from_palette()
	/// @desc Transfers colours from one ColourReplacerPalette into this one
    static copy_colours_from_palette = function(_palette, _copyInput = true, _copyOutput = true) {
		if (_copyInput) {
			inputColours = _palette.copy_input_colours();
			__isDirty |= (array_equals(inputColours, _palette.inputColours));
		}
		if (_copyOutput) {
			outputColours = _palette.copy_output_colours();
			__isDirty |= (array_equals(outputColours, _palette.outputColours));
		}
    };
    
    /// @method copy_input_colours()
	/// @desc Gets a copy of the colours this replacer is told to replace.
	/// 	  Any changes to this returned array will not affect the original values.
	///
	/// @returns {array<int>}  The copy of the colours being replaced
    static copy_input_colours = function() {
        return variable_clone(inputColours);
    };
    
    /// @method copy_output_colours()
	/// @desc Gets a copy of the colours this replacer will display over replaced colours.
	/// 	  Any changes to this returned array will not affect the original values.
	///
	/// @returns {array<int>}  The copy of the colours to replace to
    static copy_output_colours = function() {
        return variable_clone(outputColours);
    };

    #endregion
    
    #region Functions - Setters
    
    /// @method set_input_colour_at(index, colour)
	/// @desc Sets a specific index from the input list to the given colour
	///
	/// @param {int}  index  The index to target
	/// @param {int}  colour  The colour to set
    static set_input_colour_at = function(_index, _colour) {
		if (_index >= colourCount) {
			show_debug_message("ColourReplacerPalette Warning: Trying to set an unused index");
			return;	
		}
		__isDirty |= (inputColours[_index] != _colour);
        inputColours[_index] = _colour;
    };
    
    /// @method set_output_colour_at(index, colour)
	/// @desc Sets a specific index from the output list to the given colour
	///
	/// @param {int}  index  The index to target
	/// @param {int}  colour  The colour to set
    static set_output_colour_at = function(_index, _colour) {
		if (_index >= colourCount) {
			show_debug_message("ColourReplacerPalette Warning: Trying to set an unused index");
			return;	
		}
		__isDirty |= (outputColours[_index] != _colour);
        outputColours[_index] = _colour;
    };
    
    #endregion
    
    #region Functions - Other
    
    /// @method update_uniform_values()
    /// @desc Updates variables to be passed to the colour replacer's uniforms
    static update_uniform_values = function() {
		if (!__isDirty)
			return;
		
		__isDirty = false;
		
		for (var i = 0; i < colourCount; i++) {
			var _baseIndex = i * COMPONENT_COUNT;
			
			var _inputCol = inputColours[i];
			__inputColourUniforms[_baseIndex + COMPONENT_RED] = colour_get_red(_inputCol) / 255;
			__inputColourUniforms[_baseIndex + COMPONENT_GREEN] = colour_get_green(_inputCol) / 255;
			__inputColourUniforms[_baseIndex + COMPONENT_BLUE] = colour_get_blue(_inputCol) / 255;
			
			var _outputCol = outputColours[i];
			__outputColourUniforms[_baseIndex + COMPONENT_RED] = colour_get_red(_outputCol) / 255;
			__outputColourUniforms[_baseIndex + COMPONENT_GREEN] = colour_get_green(_outputCol) / 255;
			__outputColourUniforms[_baseIndex + COMPONENT_BLUE] = colour_get_blue(_outputCol) / 255;
		}
    };
    
    #endregion
    
	#region Initialization
    
    var _inputLength = array_length(_inputCols),
		_outputLength = array_length(_outputCols);
	assert(_inputLength == _outputLength, "Please make sure your input & output colours are equal in length");
	
	colourCount = min(_inputLength, MAX_COLOURS);
	array_resize(inputColours, colourCount);
	array_resize(outputColours, colourCount);
	
	for (var i = 0; i < colourCount; i++) {
        set_input_colour_at(i, _inputCols[i]);
        set_output_colour_at(i, _outputCols[i]);
	}
    
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
