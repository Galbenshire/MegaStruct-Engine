function ColourReplacer(_inputCols, _outputCols) constructor {
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
    
    #region Static Data
	
	/// Boolean to check if this shader works on the current system
	/// @static
    static isSupported = shaders_are_supported() && shader_is_compiled(shdReplaceColour);
    
    /// Shader uniforms
    /// @static
    static u_InputColours = shader_get_uniform(shdReplaceColour, "u_inputColours");
    /// @static
    static u_OutputColours = shader_get_uniform(shdReplaceColour, "u_outputColours");
    /// @static
    static u_ColourCount = shader_get_uniform(shdReplaceColour, "u_colourCount");
	
	#endregion
	
	#region Variables
    
    active = false;
    colourCount = 0;
    inputColours = []; /// @is {array<int>}
    outputColours = []; /// @is {array<int>}
    
    // The above two variables, processed into a state suitable to pass to the shader uniforms
    __inputColourParams = array_create(MAX_COLOURS * COMPONENT_COUNT, 0); /// @is {array<int>}
    __outputColourParams = array_create(MAX_COLOURS * COMPONENT_COUNT, 0); /// @is {array<int>}
    
    #endregion
    
    #region Functions - Activation/Deactivation
    
    /// -- activate()
    /// Activates the colour replace shader
    /// All future draws will be affected by the shader
    static activate = function() {
        if (!isSupported)
            return;
        shader_set(shdReplaceColour);
        refresh_all_uniforms();
        active = true;
    };
    
    /// -- deactivate()
    /// Deactivates the colour replace shader
    /// Call this once you are done using this shader
    static deactivate = function() {
        if (!isSupported)
            return;
        shader_reset();
        active = false;
    };
    
    /// -- is_active()
    /// Checks if the Colour Replacer is active
    ///
	/// @returns {bool}  The colours to ouput after replacing
    static is_active = function() {
		return active && isSupported && (shader_current() == shdReplaceColour);	
    };
    
    #endregion
    
    #region Functions - Copying
    
    /// -- copy_input_colours()
	/// Gets a copy the colours this replacer is told to replace.
	/// Any changes to this returned array will not affect the original values.
	///
	/// @returns {array<int>}  The copy of the colours being replaced
    static copy_input_colours = function() {
        return variable_clone(inputColours);
    };
    
    /// -- copy_output_colours()
	/// Gets a copy the colours this replacer will display over replaced colours.
	/// Any changes to this returned array will not affect the original values.
	///
	/// @returns {array<int>}  The copy of the colours to replace to
    static copy_output_colours = function() {
        return variable_clone(outputColours);
    };
    
    #endregion
    
    #region Functions - Setters
    
    /// -- set_input_colour_at(index, colour)
	/// Sets a specific index from the input list to the given colour
	///
	/// @param {int}  index  The index to target
	/// @param {int}  colour  The colour to set
    static set_input_colour_at = function(_index, _colour) {
		if (_index >= colourCount) {
			show_debug_message("ColourReplacer Warning: Trying to set an unused index");
			return;	
		}
		
		var _baseIndex = _index * COMPONENT_COUNT;
        inputColours[_index] = _colour;
        __inputColourParams[_baseIndex + COMPONENT_RED] = colour_get_red(_colour) / 255;
        __inputColourParams[_baseIndex + COMPONENT_GREEN] = colour_get_green(_colour) / 255;
        __inputColourParams[_baseIndex + COMPONENT_BLUE] = colour_get_blue(_colour) / 255;
        
        if (is_active())
            shader_set_uniform_f_array(u_InputColours, __inputColourParams);
    };
    
    /// -- set_output_colour_at(index, colour)
	/// Sets a specific index from the output list to the given colour
	///
	/// @param {int}  index  The index to target
	/// @param {int}  colour  The colour to set
    static set_output_colour_at = function(_index, _colour) {
		if (_index >= colourCount) {
			show_debug_message("ColourReplacer Warning: Trying to set an unused index");
			return;
		}
		
		var _baseIndex = _index * COMPONENT_COUNT;
        outputColours[_index] = _colour;
        __outputColourParams[_baseIndex + COMPONENT_RED] = colour_get_red(_colour) / 255;
        __outputColourParams[_baseIndex + COMPONENT_GREEN] = colour_get_green(_colour) / 255;
        __outputColourParams[_baseIndex + COMPONENT_BLUE] = colour_get_blue(_colour) / 255;
        
        if (is_active())
            shader_set_uniform_f_array(u_OutputColours, __outputColourParams);
    };
    
    #endregion
    
    #region Functions - Other
    
    /// -- refresh_all_uniforms()
    /// Sets all uniforms used in the colour shader
    static refresh_all_uniforms = function() {
		shader_set_uniform_f_array(u_InputColours, __inputColourParams);
        shader_set_uniform_f_array(u_OutputColours, __outputColourParams);
        shader_set_uniform_i(u_ColourCount, colourCount);
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