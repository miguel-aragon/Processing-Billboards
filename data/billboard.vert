#define PROCESSING_POINT_SHADER
uniform mat4 transform;
uniform mat4 modelview;
uniform mat4 projection;

attribute vec4 position;
attribute vec2 offset;

// Texture-based attributes
uniform sampler2D colorTexture; // Texture for color data
uniform sampler2D sizeTexture;  // Texture for size data
uniform float pointCount;       // Total number of points

varying vec2 texCoord;
varying vec3 fragColor; // Pass color to the fragment shader

void main() {
    // Calculate the index of the current point
    // OJO!!! Use strokeCap(PROJECT) to force the POINTS vertex shader to draw
    //   squared points with 5 vertices. So we must divide by 5 to get the correct index!
    float index = float(gl_VertexID) / pointCount/5; // OJO!!! 

    // Sample color and size from textures
    vec3 color = texture2D(colorTexture, vec2(index, 0.5)).rgb;
    float size = texture2D(sizeTexture, vec2(index, 0.5)).r;

    // Transform the vertex position
    vec4 worldPosition = modelview * position;
    vec4 clipPosition = projection * worldPosition;

    // Calculate the billboard offset (scaled by size)
    vec2 screenOffset = offset * size; // Use the size attribute
    clipPosition.xy += screenOffset * clipPosition.w;

    gl_Position = clipPosition;
    texCoord = offset + vec2(0.5); // Map to texture coordinates
    fragColor = color; // Pass color to the fragment shader
}