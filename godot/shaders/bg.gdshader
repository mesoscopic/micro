shader_type canvas_item;

void fragment() {
	float c = 0.0;
	if(sin(160. * PI * (UV.x) - 0.5 * PI) > 0.99){
		c = 1.0;
	}
	if(sin(160. * PI * (UV.y) - 0.5 * PI) > 0.99){
		c = 1.0;
	}
	
	COLOR = vec4(0.05, 0.05, 0.05, c);
}