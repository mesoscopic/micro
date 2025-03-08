shader_type canvas_item;

#include "lygia/draw/stroke.gdshaderinc"

uniform float explode_anim: hint_range(0,1);

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = (abs(2.*xy.x) + abs(xy.y));
	if(explode_anim>0.){
		d = mix(d, sqrt(pow(2.*xy.x, 2) + pow(xy.y, 2)), mix(0, -10, explode_anim));
	}
	COLOR.rgb *= stroke(d, 0.8, 0.3);
	COLOR.a *= stroke(d, 0.7, 0.6);
}