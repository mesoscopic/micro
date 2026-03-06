shader_type canvas_item;
render_mode skip_vertex_transform;

#include "res://lib/shader/rand.gdshaderinc"
#include "res://lib/shader/aa.gdshaderinc"

varying vec2 world_pos;

void vertex() {
	VERTEX = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
	world_pos = VERTEX;
}

void fragment() {
	vec2 lUV = 5.*mod(UV, 0.2);
	vec2 iUV = floor(world_pos*.15);
    vec2 fUV = fract(world_pos*.15);
	float d0 = 1e10;
	float d1 = 1e10;
	for(int j = -1; j <= 1; j++) {
		for(int i = -1; i <= 1; i++) {
			vec2 neighbor = vec2(float(i),float(j));
			vec2 point = .5*sin(TAU*random2(iUV+neighbor))+.5;
			point = .5*sin(TAU*point)+.5;
			float d = length(neighbor + point - fUV);
			d1 = max(min(d1, d), d0);
			if(d < d0){
				d0 = d;
			}
		}
	}
	vec2 xy = (lUV - vec2(0.5)) * 2.0;
	float d = length(xy);
	float n = aastep(mix(.8, 1., d), d0/d1)*(1.-d*d);
	COLOR = vec4(vec3(n), clamp(1.-d*d, 0., 1.));
}