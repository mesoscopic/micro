#include "tonemap/aces.gdshaderinc"
#include "tonemap/debug.gdshaderinc"
#include "tonemap/filmic.gdshaderinc"
#include "tonemap/linear.gdshaderinc"
#include "tonemap/reinhard.gdshaderinc"
#include "tonemap/reinhardJodie.gdshaderinc"
#include "tonemap/uncharted.gdshaderinc"
#include "tonemap/uncharted2.gdshaderinc"
#include "tonemap/unreal.gdshaderinc"

/*
contributors: Patricio Gonzalez Vivo
description: Tone maps the specified RGB color (meaning convert from HDR to LDR) inside the range [0..~8] to [0..1]. The input must be in linear HDR pre-exposed.
use: tonemap(<vec3|vec4> rgb)
options:
    - TONEMAP_FNC: |
        tonemapLinear, tonemapReinhard, tonemapUnreal, tonemapACES, tonemapDebug,
        tonemapUncharter
license:
    - Copyright (c) 2021 Patricio Gonzalez Vivo under Prosperity License - https://prosperitylicense.com/versions/3.0.0
    - Copyright (c) 2021 Patricio Gonzalez Vivo under Patron License - https://lygia.xyz/license
*/

#ifndef TONEMAP_FNC
#if defined(TARGET_MOBILE) || defined(PLATFORM_RPI)
    #define TONEMAP_FNC     tonemapUnreal
#else
    // #define TONEMAP_FNC     tonemapDebug
    // #define TONEMAP_FNC     tonemapFilmic
    // #define TONEMAP_FNC     tonemapACES
    // #define TONEMAP_FNC     tonemapUncharted2
    // #define TONEMAP_FNC     tonemapUncharted
    #define TONEMAP_FNC     tonemapReinhardJodie
    // #define TONEMAP_FNC     tonemapReinhard
    // #define TONEMAP_FNC     tonemapUnreal
    // #define TONEMAP_FNC     tonemapLinear
#endif
#endif

#ifndef FNC_TONEMAP
#define FNC_TONEMAP

vec3 tonemap(const vec3 v) { return TONEMAP_FNC(v); }
vec4 tonemap(const vec4 v) { return TONEMAP_FNC(v); }

#endif