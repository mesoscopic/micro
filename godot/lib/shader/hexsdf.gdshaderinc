float hexSDF(vec2 p) {
     const vec2 s = vec2(1, 1.7320508);
     p = abs(p);
     return max(dot(p, s * .5), p.x);
}