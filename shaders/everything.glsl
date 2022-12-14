

precision mediump float;

uniform float width;
uniform float height;
uniform float threshold;
uniform sampler2D tInput;

out vec4 fragColor;

vec2 resolution = vec2(width, height);

float random(vec3 scale,float seed){return fract(sin(dot(gl_FragCoord.xyz+seed,scale))*43758.5453+seed);}


float clamp(float value, float minV, float maxV) {
    return min(max(value, minV), maxV);
}

float blendReflect(float base, float blend) {
    return (blend==1.0)?blend:min(base*base/(1.0-blend),1.0);
}

vec3 blendReflect(vec3 base, vec3 blend) {
    return vec3(blendReflect(base.r,blend.r),blendReflect(base.g,blend.g),blendReflect(base.b,blend.b));
}

vec3 blendReflect(vec3 base, vec3 blend, float opacity) {
    return (blendReflect(base, blend) * opacity + base * (1.0 - opacity));
}


vec3 blendGlow(vec3 base, vec3 blend) {
    return blendReflect(blend,base);
}

vec3 blendGlow(vec3 base, vec3 blend, float opacity) {
    return (blendGlow(base, blend) * opacity + base * (1.0 - opacity));
}


float blendAdd(float base, float blend) {
    return min(base+blend,1.0);
}

vec3 blendAdd(vec3 base, vec3 blend) {
    return min(base+blend,vec3(1.0));
}

vec3 blendAdd(vec3 base, vec3 blend, float opacity) {
    return (blendAdd(base, blend) * opacity + base * (1.0 - opacity));
}


float blendOverlay(float base, float blend) {
    return base<0.5?(2.0*base*blend):(1.0-2.0*(1.0-base)*(1.0-blend));
}


vec3 blendOverlay(vec3 base, vec3 blend) {
    return vec3(blendOverlay(base.r, blend.r), blendOverlay(base.g, blend.g), blendOverlay(base.b, blend.b));
}

vec3 blendMultiply(vec3 base, vec3 blend) {
    return base*blend;
}

vec3 blendMultiply(vec3 base, vec3 blend, float opacity) {
    return (blendMultiply(base, blend) * opacity + base * (1.0 - opacity));
}


float lum(vec3 color) {
    return dot(color.rgb, vec3(0.2126, 0.7152, 0.0722));
}

vec4 brightness(vec4 color, float brightness) {
    return vec4(color.rgb * vec3(brightness), color.a);
}

vec4 constrast(vec4 color, float constrast) {
    return vec4((color.rgb - vec3(0.5)) * vec3(constrast) + vec3(0.5), color.a);
}

vec4 sobel(vec2 uv, vec2 fragCoord){
    vec4 color = texture(tInput, uv);

    float x = 1.0 / resolution.x;
    float y = 1.0 / resolution.y;
    vec4 horizEdge = vec4(0.0);
    horizEdge -= texture(tInput, vec2(uv.x - x, uv.y - y)) * 1.0;
    horizEdge -= texture(tInput, vec2(uv.x - x, uv.y)) * 2.0;
    horizEdge -= texture(tInput, vec2(uv.x - x, uv.y + y)) * 1.0;
    horizEdge += texture(tInput, vec2(uv.x + x, uv.y - y)) * 1.0;
    horizEdge += texture(tInput, vec2(uv.x + x, uv.y)) * 2.0;
    horizEdge += texture(tInput, vec2(uv.x + x, uv.y + y)) * 1.0;
    vec4 vertEdge = vec4(0.0);
    vertEdge -= texture(tInput, vec2(uv.x - x, uv.y - y)) * 1.0;
    vertEdge -= texture(tInput, vec2(uv.x, uv.y - y)) * 2.0;
    vertEdge -= texture(tInput, vec2(uv.x + x, uv.y - y)) * 1.0;
    vertEdge += texture(tInput, vec2(uv.x - x, uv.y + y)) * 1.0;
    vertEdge += texture(tInput, vec2(uv.x, uv.y + y)) * 2.0;
    vertEdge += texture(tInput, vec2(uv.x + x, uv.y + y)) * 1.0;
    vec3 edge = sqrt((horizEdge.rgb * horizEdge.rgb) + (vertEdge.rgb * vertEdge.rgb));

    color = vec4(vec3(edge.r), 1);

    return color;
}


float random(vec3 xyz){
    return fract(sin(dot(xyz, vec3(12.9898, 78.233, 151.7182))) * 43758.5453);
}

vec4 fragment(vec2 uv, vec2 fragCoord) {
    vec4 color = texture(tInput, uv);

    vec4 sob = sobel(uv, fragCoord) * (4/1) * 2;
    vec4 sobbedColor = vec4((color.rgb * vec3(sob.r)), sob.r);
    vec4 sobbedContrast = constrast(sobbedColor, 1.7);
    vec4 sobbedBright = brightness(sobbedColor, 1);




    color = vec4(blendGlow(color.rgb, sobbedBright.rgb, sobbedBright.a * threshold), 1);

//    color = sobbedBright;

    return color;
}

void main() {
    vec2 pos = gl_FragCoord.xy;
    vec2 uv = pos / vec2(width, height);
    fragColor = fragment(uv, pos);
}
