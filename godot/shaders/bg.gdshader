shader_type canvas_item;
render_mode skip_vertex_transform;

#include "lygia/generative/random.gdshaderinc"
#include "lygia/sdf/rectSDF.gdshaderinc"
#include "lygia/draw/stroke.gdshaderinc"
#include "lygia/generative/snoise.gdshaderinc"

uniform float default_effect: hint_range(0,1);
uniform float peace_effect: hint_range(0,1);

varying vec2 CAMERA;

void vertex() {
    CAMERA = (SCREEN_MATRIX * inverse(CANVAS_MATRIX) * vec4(VERTEX, 0.0, 1.0)).xy;
    VERTEX = (MODEL_MATRIX * vec4(VERTEX, 0.0, 1.0)).xy;
}

void fragment() {
	if(abs(UV.x-.5)+abs(UV.y-.5) > .5){
		discard;
	}

	COLOR = vec4(0.);
	if(default_effect>0.){
		float c = 0.0;
		if(sin(800. * PI * (UV.x) - 0.5 * PI) > 0.99){
			c = 0.05;
		}
		if(sin(800. * PI * (UV.y) - 0.5 * PI) > 0.99){
			c = 0.05;
		}
		COLOR += vec4(1.,1.,1.,c)*default_effect;
	}
	if(peace_effect>0.){
		vec2 uv = UV + vec2(snoise(UV*100.+TIME/10.), snoise(-UV*100.+TIME/10.))/5000.;
		vec2 st = 100.*mod(uv, vec2(0.01));
		float layer = 0.;
		for(float i = 0.; i < 5.; i++){
			if(random(floor(uv*100.*pow(2.,i))) > .9-.1*i){
				layer = i;
				break;
			}
			st = 2.*mod(st, vec2(0.5));
		}
		float d = rectSDF(st, 1.);
		COLOR += vec4(1., 1., 1., (.05+0.025*sin(PI*(TIME/5.+layer)))*stroke(d, .8, 0.1+0.05*sin(PI*(TIME/5.+layer))))*peace_effect;
	}
}