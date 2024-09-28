//
// Shader that replaces a set of colours
//

#define MARGIN 0.01
#define MAX_COLOURS 32

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 u_colours[MAX_COLOURS];

void main() {
    // The original color (& its grey value)
    vec4 input_col = texture2D(gm_BaseTexture, v_vTexcoord);
    float grey = 1.0 - input_col.b;
    
    // Find the corresponding output colour to apply
    int index = int(min(float(MAX_COLOURS) - 1.0, grey * float(MAX_COLOURS)));
    vec3 output_col = u_colours[index];
    
    gl_FragColor = vec4(output_col, input_col.a) * v_vColour;
}
