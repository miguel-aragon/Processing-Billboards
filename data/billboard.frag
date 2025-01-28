uniform sampler2D texMap;

varying vec2 texCoord;
varying vec3 fragColor; // Receive color from the vertex shader

void main() {
    // Sample the texture
    vec4 texColor = texture2D(texMap, texCoord);
    if (texColor.a < 0.1) { // Discard transparent pixels
        discard;
    }

    // Apply the color to the texture
    gl_FragColor = vec4(fragColor * texColor.rgb, texColor.a);
}