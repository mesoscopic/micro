#include "type.gdshaderinc"
#include "2mat3.gdshaderinc"
#include "../toMat4.gdshaderinc"

/*
contributors: Patricio Gonzalez Vivo
description: given a quaternion, returns a rotation 4x4 matrix
use: <mat4> quat2mat4(<QUAT> Q)
license:
    - Copyright (c) 2021 Patricio Gonzalez Vivo under Prosperity License - https://prosperitylicense.com/versions/3.0.0
    - Copyright (c) 2021 Patricio Gonzalez Vivo under Patron License - https://lygia.xyz/license
*/


#ifndef FNC_QUAT2MAT4
#define FNC_QUAT2MAT4
mat4 quat2mat4(QUAT q) { return toMat4(quat2mat3(q)); }
#endif