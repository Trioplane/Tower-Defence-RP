#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;
uniform vec2 ScreenSize;
out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;
out float isVignette;

vec3 newPosition = Position;
float ASCENT_OFFSET = 2000.0;

void main() {
    float id = floor((newPosition.y + 1000.0) / ASCENT_OFFSET);
    newPosition.y = mod(newPosition.y + 1000.0, ASCENT_OFFSET) - 1000.0;

    vertexDistance = fog_distance(Position, FogShape);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    
    mat4 TransformMat = mat4(1.0);
    if (id >= 0.999) {
        if (Position.z == 2400) { vertexColor.a = 0; }
        // Create a scale matrix to span the screen
        vec2 screenScale = 2.0 / ScreenSize;
        TransformMat = mat4(
            50.0, 0.0, 0.0, 0.0,
            0.0, 50.0, 0.0, 0.0,
            0.0, 0.0, 1.0, 0.0,
            (screenScale.x * 5) * 50.0, (screenScale.y - 0.0575) * 50.0, 0.0, 1.0
        );
    };
    
    texCoord0 = UV0;
    gl_Position = TransformMat * ProjMat * ModelViewMat * vec4(newPosition, 1.0);
}
