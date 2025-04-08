shader_type canvas_item;

#include "lygia/sdf/rectSDF.gdshaderinc"
#include "lygia/draw/stroke.gdshaderinc"

uniform float opacity = 1.0;

void fragment() {
	float c = 0.0;
	if(UV.x < 0.05 || UV.x > 0.95 || UV.y < 0.05 || UV.y > 0.95){
		c = 1.0;
	}
	if(sin(20.0*(UV.x + UV.y)) < -0.8){
		c = 1.0;
	}

	COLOR.a *= opacity;
	float d = rectSDF(UV, 1.);
	COLOR.a *= clamp(stroke(d, 0.9, 0.2) + (d<.9?aastep(sin(20.*(UV.x+UV.y)), -0.5):0.), 0., 1.);
}