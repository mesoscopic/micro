#include "../blend.gdshaderinc"
#include "../composite/sourceOver.gdshaderinc"

/*
contributors: Patricio Gonzalez Vivo, Anton Marini
description: Linear Light Blending with Porter Duff Source Over Compositing
use: <vec4> layerLinearLightSourceOver(<vec4> src, <vec4> dst)
license:
    - Copyright (c) 2021 Patricio Gonzalez Vivo under Prosperity License - https://prosperitylicense.com/versions/3.0.0
    - Copyright (c) 2021 Patricio Gonzalez Vivo under Patron License - https://lygia.xyz/license
*/

#ifndef FNC_LAYER_LINEAR_LIGHT_SRC_OVER
#define FNC_LAYER_LINEAR_LIGHT_SRC_OVER

vec4 layerLinearLightSourceOver(vec4 src, vec4 dest) {
    vec4 result = vec4(0.0, 0.0, 0.0, 0.0);

    // Compute linear light for RGB channels
    vec3 blendedColor = blendLinearLight(src.rgb, dest.rgb);

    // Compute source-over for RGB channels
    result.rgb = compositeSourceOver(blendedColor, dest.rgb, src.a, dest.a);

    // Compute source-over for the alpha channel
    result.a = compositeSourceOver(src.a, dest.a);

    return result;
}
#endif
