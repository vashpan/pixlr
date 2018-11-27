//
//  RenderShaders.metal
//  MetalRendererPrototype iOS
//
//  Created by Konrad Kołakowski on 13/11/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

#import "ShaderTypes.h"

// Vertex shader outputs and fragment shader inputs
typedef struct {
    float4 position [[position]];
    float2 uv;
    
} RasterizerData;

// Vertex function
vertex RasterizerData
renderVertexShader(uint vertexID [[vertex_id]],
                   constant PIXFramebufferVertex *vertices [[buffer(PIXFramebufferVertexInputIndexVertices)]],
                   constant vector_uint2 *viewportSizePointer [[buffer(PIXFramebufferVertexInputIndexViewportSize)]]) {
    RasterizerData out;
    
    // Initialize our output clip space position
    out.position = vector_float4(0.0, 0.0, 0.0, 1.0);
    
    float2 vertexPosition = vertices[vertexID].position.xy;
    vector_float2 viewportSize = vector_float2(*viewportSizePointer);
    
    // Map viewport position to Metal space
    out.position.xy = (vertexPosition / viewportSize - 0.5) * 2.0;
    
    // Pass UV further
    out.uv = vertices[vertexID].uv;
    
    return out;
}

// Fragment function
fragment float4
renderFragmentShader(RasterizerData in [[stage_in]],
                                      texture2d<half> colorTexture [[texture(PIXFramebufferTextureIndexBaseColor) ]]) {
    constexpr sampler textureSampler (mag_filter::linear,
                                      min_filter::linear);
    
    // Sample the texture to obtain a color
    const half4 colorSample = colorTexture.sample(textureSampler, in.uv);
    
    return float4(colorSample);
}

