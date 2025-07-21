//
// Shader that replaces a set of input colours with another set of output colours
//

#define MARGIN 0.01
#define MAX_COLOURS 32

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_inputColoursR[MAX_COLOURS];
uniform float u_inputColoursG[MAX_COLOURS];
uniform float u_inputColoursB[MAX_COLOURS];
uniform float u_outputColoursR[MAX_COLOURS];
uniform float u_outputColoursG[MAX_COLOURS];
uniform float u_outputColoursB[MAX_COLOURS];
uniform int u_colourCount;

void main() {
    // The original color
    vec4 input_col = texture2D(gm_BaseTexture, v_vTexcoord);
    vec3 output_col = input_col.rgb;
    
    // Search for the correct input colour
    int index = -1;
    for (int i = 0; i < MAX_COLOURS; i++) {
        vec3 index_col = vec3(u_inputColoursR[i], u_inputColoursG[i], u_inputColoursB[i]);
        if (distance(input_col.rgb, index_col) < MARGIN) {
            index = i;
            break;
        } else if (i >= u_colourCount) {
            break;
        }
    }
    
    // Apply the corresponding output colour (if applicable)
    if (index >= 0) {
        #ifdef _YY_HLSL11_
        output_col = vec3(u_outputColoursR[index], u_outputColoursG[index], u_outputColoursB[index]);
        #else
        for (int i = 0; i < MAX_COLOURS; i++) {
            if (i >= index) {
                output_col = vec3(u_outputColoursR[i], u_outputColoursG[i], u_outputColoursB[i]);
                break;
            } else if (i >= u_colourCount) {
                break;
            }
        }
        #endif
    }
    
    // Applying our output color.
    gl_FragColor = vec4(output_col, input_col.a) * v_vColour;
}
