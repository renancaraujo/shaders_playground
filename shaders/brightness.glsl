#version 460 core

precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;

uniform float uDelta;

uniform sampler2D tInput;

out vec4 fragColor;


vec4 brightness(vec4 color, float amount) {
    return vec4(color.rgb * vec3(amount), color.a);
}

vec4 fragment(vec2 uv, vec2 fragCoord) {
    vec4 color = texture(tInput, uv);
    color = brightness(color, 1.0 + uDelta);
    return color;
}

void main() {
    vec2 pos = FlutterFragCoord().xy;
    vec2 uv = pos / uSize;
    fragColor = fragment(uv, pos);
}
