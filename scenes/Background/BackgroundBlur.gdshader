shader_type canvas_item;

uniform vec2 blur = vec2(0.0, 0.0);
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

vec4 blur_linear(sampler2D tex, vec2 texel, vec2 uv, vec2 line)
{
    vec4 total = vec4(0);
    
    float dist = 1.0/200.0;
    for(float i = -0.5; i<=0.5; i+=dist)
    {
        vec2 coord = uv+i*line*texel;
        total += texture(tex,coord);
    }
    
    return total * dist;
}

void fragment() {
	vec2 texel = SCREEN_PIXEL_SIZE;
	vec2 coord = FRAGCOORD.xy*texel*2.;
	vec2 uv = fract(coord);
    COLOR = blur_linear(screen_texture, texel, SCREEN_UV, blur);
}