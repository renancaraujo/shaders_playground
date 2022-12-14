#version 460 core

precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;

uniform sampler2D tInput;

out vec4 fragColor;

vec4 fragment(vec2 uv, vec2 fragCoord) {
    vec4 resultingPixel = vec4(0.0);
    vec4 pixelColor = texture(tInput, uv);

    resultingPixel = pixelColor.rgba;
    return resultingPixel;
}

void main() {
    vec2 pos = FlutterFragCoord().xy;
    vec2 uv = pos / uSize;
    fragColor = fragment(uv, pos);
}