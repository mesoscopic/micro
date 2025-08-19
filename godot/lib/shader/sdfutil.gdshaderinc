#include "aa.gdshaderinc"

float fill(float sdf, float size) {
	return 1. - aastep(size, sdf);
}

float stroke(float sdf, float size, float width) {
	return clamp(aastep(size, sdf + width * 0.5) - aastep(size, sdf - width * 0.5), 0., 1.);
}