shader_type canvas_item;

uniform float landing_effect: hint_range(0,1);

void fragment() {
	if(abs(UV.x-.5)+abs(UV.y-.5) > .5){
		discard;
	}
	
	COLOR = vec4(0.);
	if(landing_effect>0.){
		float c = 0.0;
		if(sin(780. * PI * (UV.x) - 0.5 * PI) > 0.99){
			c = 0.05;
		}
		if(sin(780. * PI * (UV.y) - 0.5 * PI) > 0.99){
			c = 0.05;
		}
		COLOR += vec4(1.,1.,1.,c)*landing_effect;
	}
}