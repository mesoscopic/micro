shader_type canvas_item;

#include "res://lib/shader/aa.gdshaderinc"

uniform float outer = 0.0;
uniform float inner = 0.0;
uniform float bg_alpha = 0.25;

void fragment() {
	vec2 xy = (UV - vec2(0.5)) * 2.0;
	float d = (abs(xy.x) + abs(xy.y));
	COLOR.a = aastep(2.-outer, 2.-d);
	if (d < outer) {
		float total = 0.;
		for(int i = 0; i < 6; i++){
			float division = 20. + 10.*float(i);
			vec2 st = division*mod(UV*.05 + vec2(cos(TIME/10.),sin(TIME/10.))/200.*float(i), vec2(1./division)) - vec2(0.5);
			total += smoothstep(.5, .5 + .02*float(i), abs(st.x) + abs(st.y));
		}
		COLOR = mix(vec4(1.,1.,1.,mod(total, 1.)*bg_alpha), COLOR, aastep(inner, d));
	}
}