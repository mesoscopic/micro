shader_type canvas_item;

uniform float opacity = 1.0;

void fragment() {
	float c = 0.0;
	float s = 0.025 * sin(4.0*TIME) + 0.025;
	if ((UV.x > 0.1 && UV.x < 0.9 && UV.y > 0.1 && UV.y < 0.9)&&((UV.x > 0.1 && UV.x < 0.2-s) || (UV.x > 0.8+s && UV.x < 0.9) || (UV.y > 0.1 && UV.y < 0.2-s) || (UV.y > 0.8+s && UV.y < 0.9))) {
		c = 1.0;
	}
	
	COLOR = vec4(1.0, 1.0, 1.0, c*opacity);
}