#version 150

#moj_import <fog.glsl>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in vec4 vertexColor;
in vec4 vertexPosition;
in vec2 texCoord0;
in vec2 ScreenSize;
flat in int isVignette;
out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    if (isVignette == 1) {
        float dist = 1.9 - length(vertexPosition.xy);
        float vig = smoothstep(0.2, 1, dist);
        color.a *= 1.0 - vig;
    }

    if (color.a < 0.1) {
        discard;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}