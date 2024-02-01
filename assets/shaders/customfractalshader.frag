{
  "sksl": "// This SkSL shader is autogenerated by spirv-cross.\n\nfloat4 flutter_FragCoord;\n\nuniform vec2 uSize;\nuniform float zoom;\nuniform vec2 uPos;\nuniform vec2 mousePos;\nuniform vec3 exprX1;\nuniform vec3 exprX2;\nuniform vec3 exprX3;\nuniform vec3 exprX4;\nuniform vec3 exprY1;\nuniform vec3 exprY2;\nuniform vec3 exprY3;\nuniform vec3 exprY4;\nuniform float brotOrJulia;\n\nvec4 fragColor;\n\nvec2 FLT_flutter_local_FlutterFragCoord()\n{\n    return flutter_FragCoord.xy;\n}\n\nvec3 FLT_flutter_local_hsv2rgb(vec3 c)\n{\n    vec4 K = vec4(1.0, 0.666666686534881591796875, 0.3333333432674407958984375, 3.0);\n    vec3 p = abs((fract(c.xxx + K.xyz) * 6.0) - K.www);\n    return mix(K.xxx, clamp(p - K.xxx, vec3(0.0), vec3(1.0)), vec3(c.y)) * c.z;\n}\n\nvec4 FLT_flutter_local_colorFor(int i, float length)\n{\n    float iteration = (float(i) + 1.0) - (1.4375 * log(log(length) / 0.693147182464599609375));\n    vec3 param = vec3(iteration / 20.0, 1.0, 1.0);\n    vec3 rgb = FLT_flutter_local_hsv2rgb(param);\n    return vec4(rgb, 1.0);\n}\n\nvec3 FLT_flutter_local_getExprX(int i)\n{\n    switch (i)\n    {\n        case 0:\n        {\n            return exprX1;\n        }\n        case 1:\n        {\n            return exprX2;\n        }\n        case 2:\n        {\n            return exprX3;\n        }\n    }\n    return exprX4;\n}\n\nfloat FLT_flutter_local_power(float base, float exponent)\n{\n    int ex = int(exponent);\n    switch (ex)\n    {\n        case 1:\n        {\n            return base;\n        }\n        case 2:\n        {\n            return base * base;\n        }\n        case 3:\n        {\n            return (base * base) * base;\n        }\n    }\n    return 1.0;\n}\n\nfloat FLT_flutter_local_interpretX(vec2 number)\n{\n    float total = 0.0;\n    for (int i = 0; i < 4; i++)\n    {\n        int param = i;\n        vec3 term = FLT_flutter_local_getExprX(param);\n        if (term.x == 0.0)\n        {\n            break;\n        }\n        else\n        {\n            float param_1 = number.x;\n            float param_2 = term.y;\n            float param_3 = number.y;\n            float param_4 = term.z;\n            total += ((term.x * FLT_flutter_local_power(param_1, param_2)) * FLT_flutter_local_power(param_3, param_4));\n        }\n    }\n    return total;\n}\n\nvec3 FLT_flutter_local_getExprY(int i)\n{\n    switch (i)\n    {\n        case 0:\n        {\n            return exprY1;\n        }\n        case 1:\n        {\n            return exprY2;\n        }\n        case 2:\n        {\n            return exprY3;\n        }\n    }\n    return exprY4;\n}\n\nfloat FLT_flutter_local_interpretY(vec2 number)\n{\n    float total = 0.0;\n    for (int i = 0; i < 4; i++)\n    {\n        int param = i;\n        vec3 term = FLT_flutter_local_getExprY(param);\n        if (term.x == 0.0)\n        {\n            break;\n        }\n        else\n        {\n            float param_1 = number.x;\n            float param_2 = term.y;\n            float param_3 = number.y;\n            float param_4 = term.z;\n            total += ((term.x * FLT_flutter_local_power(param_1, param_2)) * FLT_flutter_local_power(param_3, param_4));\n        }\n    }\n    return total;\n}\n\nvoid FLT_main()\n{\n    vec2 fragCoord = FLT_flutter_local_FlutterFragCoord();\n    vec2 z0 = uPos + ((((fragCoord - (uSize / vec2(2.0))) / vec2(min(uSize.x, uSize.y))) * 2.0) / vec2(zoom));\n    vec2 uv = z0;\n    if (brotOrJulia > 0.0)\n    {\n        uv = mousePos;\n    }\n    fragColor = vec4(0.0, 0.0, 0.0, 1.0);\n    for (int i_1 = 0; i_1 < 110; i_1++)\n    {\n        if (length(z0) > 128.0)\n        {\n            int param_5 = i_1;\n            float param_6 = length(z0);\n            fragColor = FLT_flutter_local_colorFor(param_5, param_6);\n            break;\n        }\n        vec2 param_7 = z0;\n        vec2 param_8 = z0;\n        z0 = vec2(FLT_flutter_local_interpretX(param_7), FLT_flutter_local_interpretY(param_8)) + uv;\n    }\n}\n\nhalf4 main(float2 iFragCoord)\n{\n      flutter_FragCoord = float4(iFragCoord, 0, 0);\n      FLT_main();\n      return fragColor;\n}\n",
  "stage": 1,
  "target_platform": 2,
  "uniforms": [
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 0,
      "name": "uSize",
      "rows": 2,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 1,
      "name": "zoom",
      "rows": 1,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 2,
      "name": "uPos",
      "rows": 2,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 3,
      "name": "mousePos",
      "rows": 2,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 4,
      "name": "exprX1",
      "rows": 3,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 5,
      "name": "exprX2",
      "rows": 3,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 6,
      "name": "exprX3",
      "rows": 3,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 7,
      "name": "exprX4",
      "rows": 3,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 8,
      "name": "exprY1",
      "rows": 3,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 9,
      "name": "exprY2",
      "rows": 3,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 10,
      "name": "exprY3",
      "rows": 3,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 11,
      "name": "exprY4",
      "rows": 3,
      "type": 10
    },
    {
      "array_elements": 0,
      "bit_width": 32,
      "columns": 1,
      "location": 12,
      "name": "brotOrJulia",
      "rows": 1,
      "type": 10
    }
  ]
}