shader_type canvas_item;

void fragment() {
	vec2 uv = (UV - vec2(0.5)) * 2.0;
	if (sqrt(uv.x*uv.x + uv.y*uv.y) > 1.) {
		COLOR.a = 0.;
	}
}
