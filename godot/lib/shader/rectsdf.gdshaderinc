float rectSDF(in vec2 uv, in vec2 size) {
	return max(abs((uv.x*2.-1.)/size.x), abs((uv.y*2.-1.)/size.y));
}