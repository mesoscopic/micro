#include "../../math/saturate.gdshaderinc"

/*
contributors: Patricio Gonzalez Vivo
description: Blackbody in kelvin to RGB. Range between 0.0 and 40000.0 Kelvin
use: <vec3> k2rgb(<float> wavelength)
license:
    - Copyright (c) 2021 Patricio Gonzalez Vivo under Prosperity License - https://prosperitylicense.com/versions/3.0.0
    - Copyright (c) 2021 Patricio Gonzalez Vivo under Patron License - https://lygia.xyz/license
*/

#ifndef FNC_K2RGB
#define FNC_K2RGB

vec3 k2rgb(const in float t) {
    float p = pow(t, -1.5);
    float l = log(t);
    vec3 color = vec3(
        220000.0 * p + 0.5804,
        0.3923 * l - 2.4431,
        0.7615 * l - 5.681
    );

    if (t > 6500.0) 
        color.g = 138039.0 * p + 0.738;

    color = saturate(color);
    if (t < 1000.0) 
        color *= t/1000.0;

    return color;
}

// vec3 k2rgb(float k) {
//     vec3 result = vec3(0.0);
//     result += pow(k, 5.0)*vec3(0.000000000003,0.000000000005,0.000000000002);
//     result += pow(k, 4.0)*vec3(-0.000000003171,-0.000000006209,-0.000000003218);
//     result += pow(k, 3.0)*vec3(0.000001228482,0.000002663965,0.000001592322);
//     result += pow(k, 2.0)*vec3(-0.000191890124,-0.000514748678,-0.000373276480);
//     result += pow(k, 1.0)*vec3(0.007157629359,0.041633483053,0.040925109898);
//     result += pow(k, 0.0)*vec3(0.949884505573,-0.338527499316,-0.649683924890);
//     return result;
// }

// vec3 k2rgb(float k) {
//     vec3 retColor = vec3(0.0);

//     k = clamp(k, 1000.0, 40000.0) / 100.0;
//     if (k <= 66.0) {
//         retColor.r = 1.0;
//         retColor.g = saturate(0.39008157876901960784 * log(k) - 0.63184144378862745098);
//     }
//     else {
//         float t = k - 60.0;
//         retColor.r = saturate(1.29293618606274509804 * pow(t, -0.1332047592));
//         retColor.g = saturate(1.12989086089529411765 * pow(t, -0.0755148492));
//     }
    
//     if (k >= 66.0)
//         retColor.b = 1.0;
//     else if(k <= 19.0)
//         retColor.b = 0.0;
//     else
//         retColor.b = saturate(0.54320678911019607843 * log(k - 10.0) - 1.19625408914);

//     return retColor;
// }

#endif