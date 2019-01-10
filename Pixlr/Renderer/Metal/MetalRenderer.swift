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
        let a, b, c, d: Point
        let cr, cg, cb, ca: Float
        let colorIsOverlay: Bool
        
        let u: Float
        let v: Float

        var vertices: [PIXSpriteVertex] {
            // FIXME: Calculate vertex uv according to sprite u,v,w,h and texture
            return [
                PIXSpriteVertex(position: vector_float2(a.x, a.y), color: vector_float4(cr, cg, cb, ca), isColorOverlay: colorIsOverlay, uv: vector_float2(0.0, 1.0)),
                PIXSpriteVertex(position: vector_float2(d.x, d.y), color: vector_float4(cr, cg, cb, ca), isColorOverlay: colorIsOverlay, uv: vector_float2(0.0, 0.0)),
                PIXSpriteVertex(position: vector_float2(c.x, c.y), color: vector_float4(cr, cg, cb, ca), isColorOverlay: colorIsOverlay, uv: vector_float2(1.0, 0.0)),

                PIXSpriteVertex(position: vector_float2(c.x, c.y), color: vector_float4(cr, cg, cb, ca), isColorOverlay: colorIsOverlay, uv: vector_float2(1.0, 0.0)),
                PIXSpriteVertex(position: vector_float2(b.x, b.y), color: vector_float4(cr, cg, cb, ca), isColorOverlay: colorIsOverlay, uv: vector_float2(1.0, 1.0)),
                PIXSpriteVertex(position: vector_float2(a.x, a.y), color: vector_float4(cr, cg, cb, ca), isColorOverlay: colorIsOverlay, uv: vector_float2(0.0, 1.0))
            ]
        }
        
        init(pixlrSprite: Sprite, color: Color, transform: Matrix3) {
            let w = pixlrSprite.size.width
            let h = pixlrSprite.size.height
            
            self.a = Point(x: 0, y: 0) * transform
            self.b = Point(x: 0 + w, y: 0) * transform
            self.c = Point(x: 0 + w, y: 0 + h) * transform
            self.d = Point(x: 0, y: 0 + h) * transform
            
            self.cr = Float(color.r) / 255.0
            self.cg = Float(color.g) / 255.0
            self.cb = Float(color.b) / 255.0
            self.ca = Float(color.a) / 255.0
            self.colorIsOverlay = color.isOverlay
            
            // FIXME: Fill after adding support for sprite sheets
            self.u = 0.0
            self.v = 0.0
        }
        
        init(pixlrImage: Image, color: Color, transform: Matrix3) {
            let w = pixlrImage.size.width
            let h = pixlrImage.size.height
            
            self.a = Point(x: 0, y: 0) * transform
            self.b = Point(x: 0 + w, y: 0) * transform
            self.c = Point(x: 0 + w, y: 0 + h) * transform
            self.d = Point(x: 0, y: 0 + h) * transform
            
            self.cr = Float(color.r) / 255.0
            self.cg = Float(color.g) / 255.0
            self.cb = Float(color.b) / 255.0
            self.ca = Float(color.a) / 255.0
            self.colorIsOverlay = color.isOverlay
            
            self.u = 0.0 // top left corner of image
            self.v = 0.0
        }
    }
    
    private enum RendererCommand {
        case drawSprites(sprites: [MetalSprite], texture: MTLTexture?)
    }
    
    // MARK: Properties
    internal var metalKitView: MTKView?
    
    private let device: MTLDevice
    private let commandQueue: MTLCommandQueue
    private let textureLoader: MTKTextureLoader
    
    private var spritesFramebuffer: MTLTexture
    
    private var spritesPipeline: MTLRenderPipelineState
    private var renderPipeline: MTLRenderPipelineState
    
    private var viewportSize: vector_uint2
    private var gameViewportSize: vector_uint2
    
    private let spritesVerticesBuffer: MTLBuffer
    
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
        let defaultLibrary = try? self.device.makeDefaultLibrary(bundle: Bundle(for: MetalRenderer.classForCoder()))
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
            self.renderPipeline = renderPipeline
        } else {
            Log.graphics.error("Cannot create Metal render pipeline!")
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
        
        // reset viewports
        self.gameViewportSize = targetGameScreenSize.simdSize
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
    private func framebufferVertices(gameViewportSize: vector_uint2, viewportSize: vector_uint2) -> [PIXFramebufferVertex] {
        let widthRatio = Float(viewportSize.x) / Float(gameViewportSize.x)
        let heightRatio = Float(viewportSize.y) / Float(gameViewportSize.y)
        
        let realWidth = Float(gameViewportSize.x) * heightRatio
        let realHeight = Float(gameViewportSize.y) * widthRatio
        
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
    
    // MARK: Loading resources
    internal func loadNativeTexture(from file: String) -> MTLTexture? {
        let textureLoader = MTKTextureLoader(device: self.device)
        let fileUrl = URL(fileURLWithPath: file)
        let texture = try? textureLoader.newTexture(URL: fileUrl)
        texture?.label = file
        
        return texture
    }
    
    internal func loadNativeTexture(from texture: Texture, label: String) -> MTLTexture? {
        let width  = Int(texture.size.width)
        let height = Int(texture.size.height)
        let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .rgba8Unorm,
                                                                         width: width, height: height,
                                                                         mipmapped: false)
        
        textureDescriptor.usage = .shaderRead
        
        guard let metalTexture = self.device.makeTexture(descriptor: textureDescriptor) else {
            Log.graphics.error("Cannot create Metal texture! \(label)")
            return nil
        }
        
        metalTexture.label = label
        
        let bytesPerRow = texture.format.bytesPerPixel * width
        let region = MTLRegionMake2D(0, 0, width, height)
        
        texture.data.withUnsafeBytes { bytes in
            metalTexture.replace(region: region, mipmapLevel: 0, withBytes: bytes, bytesPerRow: bytesPerRow)
        }
        
        return metalTexture
    }
    
    // MARK: Rendering
    private func prepareMetalRendererCommands(from graphicsCommands: [Graphics.DrawCommand]) -> [RendererCommand] {
        func finalizeDrawSpritesCommand(into commands: inout [RendererCommand], sprites: [MetalSprite], texture: MTLTexture?) {
            if sprites.count > 0 {
                commands.append(.drawSprites(sprites: sprites, texture: texture))
            }
        }
        
        var commands = [RendererCommand]()
        commands.reserveCapacity(graphicsCommands.count)
        
        // batch commands by using the same texture
        var currentTexture: MTLTexture? = nil
        var currentSprites: [MetalSprite] = []
        
        for graphicCommand in graphicsCommands {
            switch graphicCommand {
                case .drawSprite(let sprite, let texture, let color, let transform):
                    let metalSprite = MetalSprite(pixlrSprite: sprite, color: color, transform: transform)
                    let metalTexture = texture.nativeTexture as? MTLTexture
                    
                    // batch this sprite if it's using the same texture
                    if metalTexture === currentTexture {
                        currentSprites.append(metalSprite)
                    } else {
                        finalizeDrawSpritesCommand(into: &commands, sprites: currentSprites, texture: currentTexture)
                        
                        // create a new set in case of new texture
                        currentSprites = [metalSprite]
                        currentTexture = metalTexture
                    }
                
                case .drawImage(let image, let color, let transform):
                    let metalSprite = MetalSprite(pixlrImage: image, color: color, transform: transform)
                    let metalTexture = image.texture.nativeTexture as? MTLTexture
                    
                    // batch this sprite if it's using the same texture
                    if metalTexture === currentTexture {
                        currentSprites.append(metalSprite)
                    } else {
                        finalizeDrawSpritesCommand(into: &commands, sprites: currentSprites, texture: currentTexture)
                        
                        // create a new set in case of new texture
                        currentSprites = [metalSprite]
                        currentTexture = metalTexture
                    }
                
                default:
                    Log.graphics.warning("Drawing command: \(graphicCommand), not implemented yet!")
            }
        }
        
        // add any remaining content to commands
        finalizeDrawSpritesCommand(into: &commands, sprites: currentSprites, texture: currentTexture)
        
        return commands
    }
    
    private func commandsRenderPhase(commands: [RendererCommand], commandBuffer: MTLCommandBuffer, in view: MTKView) {
        // custom render descriptor for rendering to texture
        let spritesRenderPassDescriptor = MTLRenderPassDescriptor()
        spritesRenderPassDescriptor.colorAttachments[0].texture = self.spritesFramebuffer
        spritesRenderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        spritesRenderPassDescriptor.colorAttachments[0].storeAction = .store
        spritesRenderPassDescriptor.colorAttachments[0].loadAction = .clear
        
        // create a render command encoder so we can render into something
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: spritesRenderPassDescriptor) else {
            return
        }
        
        renderEncoder.label = "Sprites Render Encoder"
        
        // set the drawable region & state
        renderEncoder.setViewport(MTLViewport(originX: 0.0, originY: 0.0,
                                              width: Double(self.gameViewportSize.x),
                                              height: Double(self.gameViewportSize.y),
                                              znear: -1.0, zfar: 1.0))
        renderEncoder.setRenderPipelineState(self.spritesPipeline)
        
        // send viewport data
        renderEncoder.setVertexBytes(&self.gameViewportSize,
                                     length: MemoryLayout<vector_uint2>.size,
                                     index: Int(PIXFramebufferVertexInputIndexViewportSize.rawValue))
        
        // send sprites & pixels data
        for command in commands {
            switch command {
                case .drawSprites(let spritesToDraw, let texture):
                    let joinedSprites = spritesToDraw.map { $0.vertices }.joined()
                    let spritesVertices = Array(joinedSprites)
                    let spritesVerticesCount = spritesVertices.count
                    
                    self.spritesVerticesBuffer.contents().copyMemory(from: spritesVertices, byteCount: MemoryLayout<PIXSpriteVertex>.stride * spritesVerticesCount)
                    renderEncoder.setVertexBuffer(self.spritesVerticesBuffer,
                                                  offset: 0,
                                                  index: Int(PIXSpriteVertexInputIndexVertices.rawValue))
                    
                    // set texture
                    renderEncoder.setFragmentTexture(texture,
                                                     index: Int(PIXSpriteTextureIndexBaseColor.rawValue))
                    
                    // draw single sprite
                    renderEncoder.drawPrimitives(type: .triangle,
                                                 vertexStart: 0,
                                                 vertexCount: spritesVerticesCount)
            }
        }
        
        renderEncoder.endEncoding()
    }
    
    private func scaleRenderPhase(commandBuffer: MTLCommandBuffer, in view: MTKView) {
        let vertices = self.framebufferVertices(gameViewportSize: self.gameViewportSize, viewportSize: self.viewportSize)
        let verticesCount = vertices.count
        
        // obtain a renderPassDescriptor generated fro view's drawable textures
        guard let  scaleRenderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        scaleRenderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        
        // create a render command encoder so we can render into something
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: scaleRenderPassDescriptor) else {
            return
        }
        
        renderEncoder.label = "Scale Render Encoder"
        
        // set the drawable region & state
        renderEncoder.setViewport(MTLViewport(originX: 0.0, originY: 0.0,
                                              width: Double(self.viewportSize.x), height: Double(self.viewportSize.y),
                                              znear: -1.0, zfar: 1.0))
        renderEncoder.setRenderPipelineState(self.renderPipeline)
        
        // send viewport size
        renderEncoder.setVertexBytes(&self.viewportSize,
                                     length: MemoryLayout<vector_uint2>.size,
                                     index: Int(PIXFramebufferVertexInputIndexViewportSize.rawValue))
        
        // send vertices
        renderEncoder.setVertexBytes(vertices,
                                     length: MemoryLayout<PIXFramebufferVertex>.stride * verticesCount,
                                     index: Int(PIXFramebufferVertexInputIndexVertices.rawValue))
        
        // set texture
        renderEncoder.setFragmentTexture(self.spritesFramebuffer,
                                         index: Int(Float(PIXFramebufferTextureIndexBaseColor.rawValue)))
        
        renderEncoder.drawPrimitives(type: .triangle,
                                     vertexStart: 0,
                                     vertexCount: verticesCount)
        
        renderEncoder.endEncoding()
    }
}

// MARK: Pixlr Renderer conformance
extension MetalRenderer: Renderer {    
    func viewportWillChange(to size: Size) {
        self.viewportSize = size.simdSize
    }
    
    func performDrawCommands(commands: [Graphics.DrawCommand]) {
        guard let view = self.metalKitView else {
            return
        }
        
        guard let commandBuffer = self.commandQueue.makeCommandBuffer() else {
            return
        }
        
        guard let currentDrawable = view.currentDrawable else {
            return
        }
        
        commandBuffer.label = "Main Command Buffer"
        
        let metalRendererCommands = self.prepareMetalRendererCommands(from: commands)
        self.commandsRenderPhase(commands: metalRendererCommands, commandBuffer: commandBuffer, in: view)
        self.scaleRenderPhase(commandBuffer: commandBuffer, in: view)
        
        // schedule command buffer view present
        commandBuffer.present(currentDrawable)
        
        // finalize rendering for now & push the command buffer to the GPU
        commandBuffer.commit()
    }
}
