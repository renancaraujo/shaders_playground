#version 460 core

precision mediump float;

#include <flutter/runtime_effect.glsl>

uniform vec2 uSize;
uniform float delta;
uniform sampler2D tInput;

out vec4 fragColor;

vec2 barrelDistortion(vec2 coord, float amt) {
    vec2 cc = coord - 0.5;
    float dist = dot(cc, cc);
    return coord + cc * dist * amt;
}

vec4 fragment(vec2 uv, vec2 fragCoord) {
    vec4 resultingPixel = vec4(0.0);

    vec4 a1=texture(tInput, barrelDistortion(uv, 0.0));
    vec4 a2=texture(tInput, barrelDistortion(uv, 0.2));
    vec4 a3=texture(tInput, barrelDistortion(uv, 0.4));
    vec4 a4=texture(tInput, barrelDistortion(uv, 0.6));

    vec4 a5=texture(tInput, barrelDistortion(uv, 0.8));
    vec4 a6=texture(tInput, barrelDistortion(uv, 1.0));
    vec4 a7=texture(tInput, barrelDistortion(uv, 1.2));
    vec4 a8=texture(tInput, barrelDistortion(uv, 1.4));

    vec4 a9=texture(tInput, barrelDistortion(uv, 1.6));
    vec4 a10=texture(tInput, barrelDistortion(uv, 1.8));
    vec4 a11=texture(tInput, barrelDistortion(uv, 2.0));
    vec4 a12=texture(tInput, barrelDistortion(uv, 2.2));

    vec4 tx=(a1+a2+a3+a4+a5+a6+a7+a8+a9+a10+a11+a12)/12.;
    resultingPixel = vec4(tx.rgb, tx.a);
    return resultingPixel;
}

void main() {
    vec2 pos = FlutterFragCoord().xy;
    vec2 uv = pos / resolution;
    fragColor = fragment(uv, pos);
}

