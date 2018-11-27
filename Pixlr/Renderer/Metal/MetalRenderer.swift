//
//  MetalRenderer.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 18/11/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Metal
import MetalKit
import simd

// MARK: Metal renderer
internal class MetalRenderer: NSObject {
    // MARK: Types
    private struct MetalSprite {
        let x: Float
        let y: Float
        
        let w: Float
        
        var vertices: [PIXSpriteVertex] {
            return [
                PIXSpriteVertex(position: vector_float2(x,     y    ), uv: vector_float2(0.0, 1.0)),
                PIXSpriteVertex(position: vector_float2(x,     y - w), uv: vector_float2(0.0, 0.0)),
                PIXSpriteVertex(position: vector_float2(x + w, y    ), uv: vector_float2(1.0, 1.0)),
                
                PIXSpriteVertex(position: vector_float2(x + w, y    ), uv: vector_float2(1.0, 1.0)),
                PIXSpriteVertex(position: vector_float2(x + w, y - w), uv: vector_float2(1.0, 0.0)),
                PIXSpriteVertex(position: vector_float2(x,     y - w), uv: vector_float2(0.0, 0.0))
            ]
        }
    }
    
    // MARK: Properties
    internal var metalKitView: MTKView?
    
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let textureLoader: MTKTextureLoader
    
    private var spritesFramebuffer: MTLTexture
    
    private var spritesPipeline: MTLRenderPipelineState
    private var renderPipeline: MTLRenderPipelineState
    
    private var viewportSize: vector_uint2 = vector_uint2()
    private var gameViewportSize: vector_uint2 = vector_uint2()
    
    private var sprites: [MetalSprite] = []
    private let spritesVerticesBuffer: MTLBuffer
    private var spriteSheet: MTLTexture? = nil
    
    // MARK: Constants
    private let maxSprites = 8192
    
    // MARK: Initialization
    internal init?(metalKitView: MTKView, targetGameScreenSize: Size) {
        guard let device = metalKitView.device else {
            Log.graphics.error("Cannot get Metal device!")
            return nil
        }
        
        guard let verticesBuffer = device.makeBuffer(length: MemoryLayout<PIXSpriteVertex>.stride * self.maxSprites * 6, options: [.storageModeShared]) else {
            Log.graphics.error("Cannot create Metal vertices buffer!")
            return nil
        }
        
        self.metalKitView = metalKitView
        
        // create device and texture loader
        self.device = device
        self.textureLoader = MTKTextureLoader(device: device)
        
        // load all needed shader files with .metal extension and get some shaders
        let defaultLibrary = self.device.makeDefaultLibrary()
        let targetPixelFormat = metalKitView.colorPixelFormat
        
        // sprites drawing pipeline
        if let spritesPipeline = MetalRenderer.createSpritesPipeline(on: device,
                                                                     library: defaultLibrary,
                                                                     pixelFormat: targetPixelFormat) {
            self.spritesPipeline = spritesPipeline
        } else {
            Log.graphics.error("Cannot create Metal sprites pipeline!")
            return nil
        }
        
        // render pipeline
        if let renderPipeline = MetalRenderer.createRenderPipeline(on: device,
                                                                   library: defaultLibrary,
                                                                   pixelFormat: targetPixelFormat) {
            Log.graphics.error("Cannot create Metal render pipeline!")
            self.renderPipeline = renderPipeline
        } else {
            return nil
        }
        
        // creating our main command queue
        if let newCommandQueue = self.device.makeCommandQueue() {
            self.commandQueue = newCommandQueue
        } else {
            Log.graphics.error("Cannot create Metal command queue!")
            return nil
        }
        
        // allocate framebuffer for sprites renderer
        self.spritesFramebuffer = MetalRenderer.createSpritesFramebufferTexture(using: device,
                                                                                pixelFormat: targetPixelFormat,
                                                                                size: targetGameScreenSize)
        
        // create vertices buffer
        self.spritesVerticesBuffer = verticesBuffer
        
        // reset viewport
        self.viewportSize = vector_uint2()
        
        super.init()
    }
    
    private static func createSpritesPipeline(on device: MTLDevice, library: MTLLibrary?, pixelFormat: MTLPixelFormat) -> MTLRenderPipelineState? {
        let vertexFunction = library?.makeFunction(name: "spritesVertexShader")
        let fragmentFunction = library?.makeFunction(name: "spritesFragmentShader")
        
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Sprites Pipeline"
        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction
        descriptor.colorAttachments[0].pixelFormat = pixelFormat
        descriptor.colorAttachments[0].isBlendingEnabled = true
        descriptor.colorAttachments[0].rgbBlendOperation = .add
        descriptor.colorAttachments[0].alphaBlendOperation = .add
        descriptor.colorAttachments[0].sourceRGBBlendFactor = .one
        descriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
        descriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        descriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
        
        do {
            let spritesPipeline = try device.makeRenderPipelineState(descriptor: descriptor)
            return spritesPipeline
        } catch(let error) {
            Log.graphics.error("Failed to create sprites pipeline state, error: \(error)")
            return nil
        }
    }
    
    private static func createRenderPipeline(on device: MTLDevice, library: MTLLibrary?, pixelFormat: MTLPixelFormat) -> MTLRenderPipelineState? {
        let vertexFunction = library?.makeFunction(name: "renderVertexShader")
        let fragmentFunction = library?.makeFunction(name: "renderFragmentShader")
        
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.label = "Render Pipeline"
        descriptor.vertexFunction = vertexFunction
        descriptor.fragmentFunction = fragmentFunction
        descriptor.colorAttachments[0].pixelFormat = pixelFormat
        
        do {
            let renderPipeline = try device.makeRenderPipelineState(descriptor: descriptor)
            return renderPipeline
        } catch(let error) {
            Log.graphics.error("Failed to create render pipeline state, error: \(error)")
            return nil
        }
    }
    
    private static func createSpritesFramebufferTexture(using device: MTLDevice, pixelFormat: MTLPixelFormat, size: Size) -> MTLTexture {
        let framebufferTextureDescriptor = MTLTextureDescriptor()
        framebufferTextureDescriptor.width = Int(size.width)
        framebufferTextureDescriptor.height = Int(size.height)
        framebufferTextureDescriptor.pixelFormat = pixelFormat
        framebufferTextureDescriptor.textureType = .type2D
        framebufferTextureDescriptor.usage = .unknown
        
        guard let framebufferTexture = device.makeTexture(descriptor: framebufferTextureDescriptor) else {
            Log.graphics.error("Cannot create Metal sprites framebuffer texture!")
            fatalError()
        }
        
        return framebufferTexture
    }
    
    // MARK: Utils
    private func framebufferVertices(spritesScreenSize: CGSize, viewportSize: vector_uint2) -> [PIXFramebufferVertex] {
        let heightRatio = Float(viewportSize.y) / Float(spritesScreenSize.height)
        let widthRatio = Float(viewportSize.x) / Float(spritesScreenSize.width)
        
        let realWidth = Float(spritesScreenSize.width) * heightRatio
        let realHeight = Float(spritesScreenSize.height) * widthRatio
        
        let xStart: Float, xStop: Float
        let yStart: Float, yStop: Float
        
        if heightRatio < widthRatio {
            xStart = (Float(viewportSize.x) - realWidth) / 2.0
            xStop = xStart + realWidth
            
            yStart = 0.0
            yStop = Float(viewportSize.y)
            
        } else {
            xStart = 0.0
            xStop = Float(viewportSize.x)
            
            yStart = (Float(viewportSize.y) - realHeight) / 2.0
            yStop = yStart + realHeight
        }
        
        return [
            PIXFramebufferVertex(position: vector_float2(xStart, yStart), uv: vector_float2(0.0, 1.0)),
            PIXFramebufferVertex(position: vector_float2(xStart, yStop), uv: vector_float2(0.0, 0.0)),
            PIXFramebufferVertex(position: vector_float2(xStop,  yStart), uv: vector_float2(1.0, 1.0)),
            
            PIXFramebufferVertex(position: vector_float2(xStop,  yStart), uv: vector_float2(1.0, 1.0)),
            PIXFramebufferVertex(position: vector_float2(xStop,  yStop), uv: vector_float2(1.0, 0.0)),
            PIXFramebufferVertex(position: vector_float2(xStart, yStop), uv: vector_float2(0.0, 0.0))
        ]
    }
}

// MARK: Pixlr Renderer conformance
extension MetalRenderer: Renderer {    
    func viewportWillChange(to size: Size) {
        self.viewportSize = size.simdSize
    }
    
    func performDrawCommands(commands: [Graphics.DrawCommand]) {
        
    }
}
