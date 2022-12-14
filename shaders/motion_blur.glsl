

uniform float delta;
uniform float angle;
uniform float width;
uniform float height;
uniform sampler2D tInput;

out vec4 fragColor;

float random(vec3 xyz){
    return fract(sin(dot(xyz, vec3(12.9898, 78.233, 151.7182))) * 43758.5453);
}

vec4 fragment(vec2 uv, vec2 fragCoord) {
    vec4 color = vec4(0.0);
    float total = 0.0;
    vec2 tDelta = delta * vec2(cos(angle), sin(angle));
    float offset = random(vec3(fragCoord, 1000.0));

    for (float t = -30.0; t <= 30.0; t += 5){
        float percent = (t + offset - 0.5) / 30.0;
        float weight = 1.0 - abs(percent);
        color += texture(tInput, uv + tDelta * percent) * weight;
        total += weight;
    }

    if (total == 0.0) {
        total = 1.0;
    }

    vec4 fragcolor =  color / total;
    fragcolor.rgb = fragcolor.rgb / fragcolor.a + 0.01;

    return fragcolor;
}

void main() {
  vec2 pos = gl_FragCoord.xy;
  vec2 uv = pos / vec2(width, height);
  fragColor = fragment(uv, pos);
}
