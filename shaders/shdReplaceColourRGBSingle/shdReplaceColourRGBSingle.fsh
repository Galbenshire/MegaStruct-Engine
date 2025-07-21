//
// Shader that replaces a single colour if it happens to match
//

#define MARGIN 0.01

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform vec3 u_inputColour;
uniform vec3 u_outputColour;

void main() {
    vec4 input_col = texture2D(gm_BaseTexture, v_vTexcoord);
    
    vec3 output_col = (distance(input_col.rgb, u_inputColour) < MARGIN)
        ? u_outputColour
        : input_col.rgb;
    
    gl_FragColor = vec4(output_col, input_col.a) * v_vColour;
}
