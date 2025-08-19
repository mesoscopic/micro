shader_type canvas_item;
render_mode skip_vertex_transform;


#include "res://lib/shader/rand.gdshaderinc"
#include "res://lib/shader/squaresdf.gdshaderinc"
#include "res://lib/shader/sdfutil.gdshaderinc"
#include "res://lib/shader/simplexnoise.gdshaderinc"

uniform float alpha_mult = 1.0;

uniform float landing_effect: hint_range(0,1);
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
	if(landing_effect>0.){
		float total = 0.;
		for(int i = 0; i < 6; i++){
			float division = 40. + 20.*float(i);
			vec2 st = division*mod(UV + CAMERA/200.*float(i), vec2(1./division)) - vec2(0.5);
			total += smoothstep(.5, .5 + .02*float(i), abs(st.x) + abs(st.y));
		}
		COLOR += vec4(1.,1.,1.,0.06*mod(total, 1.))*landing_effect;
	}
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
		vec2 uv = UV + vec2(simplex_noise(UV*100.+TIME/10.), simplex_noise(-UV*100.+TIME/10.))/5000.;
		vec2 st = 100.*mod(uv, vec2(0.01));
		float layer = 0.;
		for(float i = 0.; i < 5.; i++){
			if(random(floor(uv*100.*pow(2.,i))) > .9-.1*i){
				layer = i;
				break;
			}
			st = 2.*mod(st, vec2(0.5));
		}
		float d = squareSDF(st);
		COLOR += vec4(1., 1., 1., (.05+0.025*sin(PI*(TIME/5.+layer)))*stroke(d, .8, 0.1+0.05*sin(PI*(TIME/5.+layer))))*peace_effect;
	}
	COLOR.a *= alpha_mult;
}