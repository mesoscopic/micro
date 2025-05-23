#include "../sampler.gdshaderinc"

/*
contributors: Patricio Gonzalez Vivo
description: Given a Spherical Map texture and a normal direction returns the right pixel
use: spheremap(<SAMPLER_TYPE> texture, <vec3> normal)
options:
    SPHEREMAP_EYETOPOINT: where the eye is looking
license:
    - Copyright (c) 2021 Patricio Gonzalez Vivo under Prosperity License - https://prosperitylicense.com/versions/3.0.0
    - Copyright (c) 2021 Patricio Gonzalez Vivo under Patron License - https://lygia.xyz/license
*/

#ifndef SPHEREMAP_TYPE
#define SPHEREMAP_TYPE vec4
#endif

#ifndef SPHEREMAP_SAMPLER_FNC
#define SPHEREMAP_SAMPLER_FNC(TEX, UV) SAMPLER_FNC(TEX, UV)
#endif

#ifndef FNC_SPHEREMAP
#define FNC_SPHEREMAP
vec2 sphereMap(const in vec3 normal, const in vec3 eye) {
    vec3 r = reflect(-eye, normal);
    r.z += 1.0;
    float m = 2.0 * length(r);
    return r.xy / m + 0.5;
}

SPHEREMAP_TYPE sphereMap(in SAMPLER_TYPE tex, const in vec3 normal, const in vec3 eye) {
    return SPHEREMAP_SAMPLER_FNC(tex, sphereMap(normal, eye) );
}
#endif
