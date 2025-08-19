float random(in float x) {
	return fract(sin(x) * 43758.5453);
}

float random(in vec2 x) {
	return fract(sin(dot(x.xy, vec2(12.9898, 78.233))) * 43758.5453);
}