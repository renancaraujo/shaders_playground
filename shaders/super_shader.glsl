precision mediump float;

layout(location = 0) uniform float width;
layout(location = 1) uniform float height;
layout(location = 2) uniform float threshold;
layout(location = 3) uniform sampler2D tInput;


out vec4 fragColor;


vec4 fragment(vec2 uv, vec2 fragCoord) {


    vec4 color = texture(tInput, uv);

    vec2 resolution = vec2(width, height);

    // calculate the average color of the surrounding pixels
    //    vec2 offset = 1.0 / resolution;
    //    vec4 topLeft = texture(tInput, fragCoord + vec2(-offset.x, offset.y));
    //    vec4 top = texture(tInput, fragCoord + vec2(0, offset.y));
    //    vec4 topRight = texture(tInput, fragCoord + vec2(offset.x, offset.y));
    //    vec4 left = texture(tInput, fragCoord + vec2(-offset.x, 0));
    //    vec4 right = texture(tInput, fragCoord + vec2(offset.x, 0));
    //    vec4 bottomLeft = texture(tInput, fragCoord + vec2(-offset.x, -offset.y));
    //    vec4 bottom = texture(tInput, fragCoord + vec2(0, -offset.y));
    //    vec4 bottomRight = texture(tInput, fragCoord + vec2(offset.x, -offset.y));
    //    vec4 average = (topLeft + top + topRight + left + right + bottomLeft + bottom + bottomRight) / 8.0;
    //
    //    vec3 diff = abs(average.rgb - color.rgb);
    //
    //    if (diff.r > threshold) {
    //        color = vec4(0, 1, 0, 1);
    //    }

    //    vec4 sum = vec4(0.0);
    //    for (float x = -1.0; x <= 1.0; x += 1.0) {
    //        for (float y = -1.0; y <= 1.0; y += 1.0) {
    //            sum += texture(tInput, fragCoord + vec2(x, y) * 10);
    //        }
    //    }
    //    vec4 avg = sum / 9.0;


    // calculate horizontal and vertical derivatives
    float gx = texture(tInput, fragCoord + vec2(1, 0)).r - texture(tInput, fragCoord - vec2(1, 0)).r;
    float gy = texture(tInput, fragCoord + vec2(0, 1)).r - texture(tInput, fragCoord - vec2(0, 1)).r;

    // calculate gradient magnitude and orientation
    float magnitude = sqrt(gx * gx + gy * gy);
    float orientation = atan(gy, gx);

    color= vec4(magnitude, magnitude, magnitude, 1.0);


    return color;
}

void main() {
    vec2 pos = gl_FragCoord.xy;
    vec2 uv = pos / vec2(width, height);
    fragColor = fragment(uv, pos);
}
