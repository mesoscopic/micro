#include "space/rgb2lab.gdshaderinc"
#include "space/rgb2YCbCr.gdshaderinc"
#include "space/rgb2YPbPr.gdshaderinc"
#include "space/rgb2yuv.gdshaderinc"
#include "space/rgb2oklab.gdshaderinc"

/*
contributors: Patricio Gonzalez Vivo
description: Perceptual distance between two color according to CIE94 https://en.wikipedia.org/wiki/Color_difference#CIE94
use: colorDistance(<vec3|vec4> rgbA, <vec3|vec4> rgbA)
options:
    - COLORDISTANCE_FNC: | 
        colorDistanceLABCIE94, colorDistanceLAB, colorDistanceYCbCr,
        colorDistanceYPbPr, colorDistanceYUV, colorDistanceOKLAB
license:
    - Copyright (c) 2021 Patricio Gonzalez Vivo under Prosperity License - https://prosperitylicense.com/versions/3.0.0
    - Copyright (c) 2021 Patricio Gonzalez Vivo under Patron License - https://lygia.xyz/license
*/

#ifndef COLORDISTANCE_FNC
#define COLORDISTANCE_FNC colorDistanceLABCIE94
#endif

#ifndef FNC_PERCEPTUALDISTANCE
#define FNC_PERCEPTUALDISTANCE
float colorDistanceLABCIE94(in vec3 rgb1, in vec3 rgb2) {
    vec3 lab1 = rgb2lab(rgb1);
    vec3 lab2 = rgb2lab(rgb2);

    vec3 delta = lab1 - lab2;
    float c1 = sqrt(lab1.y * lab1.y + lab1.z * lab1.z);
    float c2 = sqrt(lab2.y * lab2.y + lab2.z * lab2.z);
    float delta_c = c1 - c2;
    float delta_h = delta.x * delta.x + delta.z * delta.z - delta_c * delta_c;
    delta_h = mix( 0., sqrt(delta_h), step(0.,delta_h));

    float sc = 1. +.045 * c1;
    float sh = 1. + .015 * c1;

    float delta_ckcsc = delta_c / sc;
    float delta_hkhsh = delta_h / sh;

    float delta_e = delta.x * delta.x + delta_ckcsc * delta_ckcsc + delta_hkhsh * delta_hkhsh;
    return mix( 0., sqrt(delta_e), step(0.,delta_e));
}

float colorDistanceLAB(in vec3 rgb1, in vec3 rgb2)    { return distance(rgb2lab(rgb1), rgb2lab(rgb2)); }
float colorDistanceYCbCr(in vec3 rgb1, in vec3 rgb2)  { return distance(rgb2YCbCr(rgb1).yz, rgb2YCbCr(rgb2).yz); }
float colorDistanceYPbPr(in vec3 rgb1, in vec3 rgb2)  { return distance(rgb2YPbPr(rgb1).yz, rgb2YPbPr(rgb2).yz); }
float colorDistanceYUV(in vec3 rgb1, in vec3 rgb2)    { return distance(rgb2yuv(rgb1), rgb2yuv(rgb2)); }
float colorDistanceOKLAB(in vec3 rgb1, in vec3 rgb2)  { return distance(rgb2oklab(rgb1), rgb2oklab(rgb2)); }

float colorDistance(in vec3 rgb1, in vec3 rgb2)       { return COLORDISTANCE_FNC(rgb1, rgb2); }
float colorDistance(in vec4 rgb1, in vec4 rgb2)       { return COLORDISTANCE_FNC(rgb1.rgb, rgb2.rgb); }
#endif