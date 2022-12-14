#version 460 core

precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float uAmount;
uniform sampler2D tInput;

out vec4 fragColor;


vec4 fragment(vec2 uv, vec2 fragCoord) {
    float realAmount = 1.0 - uAmount;
    vec2 uv2 = vec2(uv.x, uv.y * pow(realAmount, uv.y * 0.4));
    vec4 pixelColor = texture(tInput, uv2);

    return pixelColor;
}

void main() {
    vec2 pos = FlutterFragCoord().xy;
    vec2 uv = pos / uSize;
    fragColor = fragment(uv, pos);
}
