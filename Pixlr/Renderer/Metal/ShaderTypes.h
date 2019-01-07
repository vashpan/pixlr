/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Header containing types and enum constants shared between Metal shaders and C/ObjC source
 */

#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>

// MARK: - Vertex shader indices
typedef enum PIXSpriteVertexInputIndex {
    PIXSpriteVertexInputIndexVertices = 0,
    PIXSpriteVertexInputIndexViewportSize = 1,
} PIXSpriteVertexInputIndex;

typedef enum PIXFramebufferVertexInputIndex {
    PIXFramebufferVertexInputIndexVertices = 0,
    PIXFramebufferVertexInputIndexViewportSize = 1,
} PIXFramebufferVertexInputIndex;

// MARK: - Fragment shader indices
typedef enum PIXSpriteTextureIndex {
    PIXSpriteTextureIndexBaseColor = 0,
} PIXSpriteTextureIndex;

typedef enum PIXFramebufferTextureIndex {
    PIXFramebufferTextureIndexBaseColor = 0,
} PIXFramebufferTextureIndex;

// MARK: - Vertex definitions
typedef struct {
    vector_float2 position;
    vector_float4 color;
    vector_float2 uv;
} PIXSpriteVertex;

typedef struct {
    vector_float2 position;
    vector_float2 uv;
} PIXFramebufferVertex;

#endif /* ShaderTypes_h */


