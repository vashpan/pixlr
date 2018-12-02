/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Metal shaders used for this sample
 */

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
spritesVertexShader(uint vertexID [[vertex_id]],
             constant PIXSpriteVertex *vertices [[buffer(PIXSpriteVertexInputIndexVertices)]],
             constant vector_uint2 *viewportSizePointer [[buffer(PIXSpriteVertexInputIndexViewportSize)]]) {
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
fragment
float4 spritesFragmentShader(RasterizerData in [[stage_in]],
                               texture2d<half> colorTexture [[texture(PIXSpriteTextureIndexBaseColor) ]]) {
    constexpr sampler textureSampler (mag_filter::nearest,
                                      min_filter::nearest);
    
    // Sample the texture to obtain a color
    //const half4 colorSample = colorTexture.sample(textureSampler, in.uv);
    
    // FIXME: For now not using texture sampler because of lack of texture
    const half4 colorSample = half4(1.0, 0.0, 0.0, 1.0);
    
    return float4(colorSample);
}
