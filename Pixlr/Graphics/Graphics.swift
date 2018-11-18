//
//  Graphics.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 18/11/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation

// MARK: Helper types
public typealias SpriteId = Int
public typealias Angle = Float

// MARK: - Graphics interface
public class Graphics {
    // MARK: Types
    internal struct Sprite {
        internal let id: SpriteId
        internal let scale: Float
        internal let flip: Bool
        internal let rotation: Angle
        
        // FIXME: Add support for sprite atlas and its UV
    }
    
    internal enum DrawCommand {
        case drawSprite(sprite: Sprite, point: Point)
        case drawPixels(pixels: [Pixel])
    }
    
    // MARK: Properties
    private let renderer: Renderer
    
    private var drawingPossible = false
    private var drawingCommands: [DrawCommand] = []
    
    public private(set) var screenSize: Size
    
    // MARK: Initialization
    internal init(renderer: Renderer, screenSize: Size) {
        self.screenSize = screenSize
        self.renderer = renderer
    }
    
    // MARK: Updating state
    internal func updateScreenSize(size: Size) {
        self.screenSize = size
    }
    
    // MARK: Frame processing
    internal func beginFrame() {
        self.drawingCommands.removeAll(keepingCapacity: true)
        self.drawingPossible = true
    }
    
    internal func endFrame() {
        self.drawingPossible = false
        
        self.renderer.performDrawCommands(commands: self.drawingCommands)
    }
    
    // MARK: Drawing
    public func draw(sprite: SpriteId, x: Float, y: Float, scale: Float = 1.0, rotation: Angle = 0.0, flip: Bool = false) {
        guard self.drawingPossible else {
            Log.graphics.warning("Drawing is not possible in this scope!")
            return
        }
        
        let sprite = Sprite(id: sprite, scale: scale, flip: flip, rotation: rotation)
        self.drawingCommands.append(.drawSprite(sprite: sprite, point: Point(x: x, y: y)))
    }
    
    public func draw(sprite: SpriteId, at position: Point, scale: Float = 1.0, rotation: Angle = 0.0, flip: Bool = false) {
        self.draw(sprite: sprite, x: position.x, y: position.y, scale: scale, rotation: rotation, flip: flip)
    }
    
    public func draw(pixels: [Pixel]) {
        guard self.drawingPossible else {
            Log.graphics.warning("Drawing is not possible in this scope!")
            return
        }
        
        self.drawingCommands.append(.drawPixels(pixels: pixels))
    }
    
    public func draw(text: String, x: Float, y: Float) {
        guard self.drawingPossible else {
            Log.graphics.warning("Drawing is not possible in this scope!")
            return
        }
        
        // FIXME: Implement
        Log.graphics.info("Drawing text not implemented yet!")
    }
    
    public func draw(text: String, at position: Point) {
        self.draw(text: text, x: position.x, y: position.y)
    }
}
