#include "../blend.gdshaderinc"
#include "../composite/sourceOver.gdshaderinc"

/*
contributors: Patricio Gonzalez Vivo, Anton Marini
description: Exclusion Blending with Porter Duff Source Over Compositing
use: <vec4> layerExclusionSourceOver(<vec4> src, <vec4> dst)
license:
    - Copyright (c) 2021 Patricio Gonzalez Vivo under Prosperity License - https://prosperitylicense.com/versions/3.0.0
    - Copyright (c) 2021 Patricio Gonzalez Vivo under Patron License - https://lygia.xyz/license
*/

#ifndef FNC_LAYER_EXCLUSION_SRC_OVER
#define FNC_LAYER_EXCLUSION_SRC_OVER

vec4 layerExclusionSourceOver(vec4 src, vec4 dest) {
    vec4 result = vec4(0.0, 0.0, 0.0, 0.0);

    // Compute exclusion for RGB channels
    vec3 blendedColor = blendExclusion(src.rgb, dest.rgb);

    // Compute source-over for RGB channels
    result.rgb = compositeSourceOver(blendedColor, dest.rgb, src.a, dest.a);

    // Compute source-over for the alpha channel
    result.a = compositeSourceOver(src.a, dest.a);

    return result;
}
#endif
