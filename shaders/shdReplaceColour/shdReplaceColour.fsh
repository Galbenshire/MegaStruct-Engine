//
// Shader that replaces a set of colours
//

#define MAX_COLOURS 32

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_coloursR[MAX_COLOURS];
uniform float u_coloursG[MAX_COLOURS];
uniform float u_coloursB[MAX_COLOURS];

void main() {
    // The original color (& its grey value)
    vec4 input_col = texture2D(gm_BaseTexture, v_vTexcoord);
    float grey = 1.0 - input_col.b;
    
    // Find the index
    int index = int(min(float(MAX_COLOURS) - 1.0, grey * float(MAX_COLOURS)));
    
    // Now get the corresponding output colour to apply
    #ifdef _YY_HLSL11_
    vec3 output_col = vec3(u_coloursR[index], u_coloursG[index], u_coloursB[index]);
    #else
    vec3 output_col = vec3(0.0);
    for (int i = 0; i < MAX_COLOURS; i++) {
        if (i >= index) {
            output_col = vec3(u_coloursR[i], u_coloursG[i], u_coloursB[i]);
            break;
        }
    }
    #endif
    
    gl_FragColor = vec4(output_col, input_col.a) * v_vColour;
}
