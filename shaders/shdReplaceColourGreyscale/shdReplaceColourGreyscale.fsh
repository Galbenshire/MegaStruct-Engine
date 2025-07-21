//
// Shader that replaces a set of colours by reading a greyscale graphic
//

#define MAX_COLOURS 32
#define MAX_COLOURS_F 32.0

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_coloursR[MAX_COLOURS];
uniform float u_coloursG[MAX_COLOURS];
uniform float u_coloursB[MAX_COLOURS];
uniform int u_colourCount;

void main() {
    // The original color (& its grey value)
    vec4 input_col = texture2D(gm_BaseTexture, v_vTexcoord);
    float grey = 1.0 - input_col.b;
    
    // Find the index
    int index = int(min(MAX_COLOURS_F - 1.0, grey * MAX_COLOURS_F));
    
    // Now get the corresponding output colour to apply
    #ifdef _YY_HLSL11_
    vec3 output_col = vec3(u_coloursR[index], u_coloursG[index], u_coloursB[index]);
    #else
    vec3 output_col = input_col.rgb;
    for (int i = 0; i < MAX_COLOURS; i++) {
        if (i >= index) {
            output_col = vec3(u_coloursR[i], u_coloursG[i], u_coloursB[i]);
            break;
        } else if (i >= u_colourCount) {
            break;
        }
    }
    #endif
    
    gl_FragColor = vec4(output_col, input_col.a) * v_vColour;
}
