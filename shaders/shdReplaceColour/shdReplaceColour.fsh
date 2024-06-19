//
// Shader that replaces a set of colours
//

#define MARGIN 0.01
#define MAX_COLOURS 16

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 u_inputColours[MAX_COLOURS];
uniform vec3 u_outputColours[MAX_COLOURS];
uniform int u_colourCount;

void main() {
    // The original color
    vec4 input_col = texture2D(gm_BaseTexture, v_vTexcoord);
    
    // Search for the correct input colour
    int index = -1;
    for (int i = 0; i < u_colourCount; i++) {
        if (distance(input_col.rgb, u_inputColours[i]) < MARGIN) {
            index = i;
        }
    }
    
    // Apply the corresponding output colour (if applicable)
    vec3 output_col = (index >= 0) ? u_outputColours[index] : input_col.rgb;
    
    // Setting our output color.
    gl_FragColor = vec4(output_col, input_col.a) * v_vColour;
}
