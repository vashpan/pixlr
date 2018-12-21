//
//  Graphics.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 18/11/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation

// MARK: Helper types
public typealias Angle = Float

// MARK: - Graphics interface
public class Graphics {
    // MARK: Types
    internal enum DrawCommand {
        case drawSprite(sprite: Sprite, texture: Texture, position: Point)
        case drawImage(image: Image, position: Point)
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
    public func draw(sprite: SpriteId, from spriteSheet: SpriteSheetId, x: Float, y: Float, scale: Float = 1.0, rotation: Angle = 0.0, flip: Bool = false) {
        guard self.drawingPossible else {
            Log.graphics.warning("Drawing is not possible in this scope!")
            return
        }
        
        if let sheet = Resources.shared.spriteSheet(from: spriteSheet), let sprite = sheet.sprites[sprite] {
            self.drawingCommands.append(.drawSprite(sprite: sprite, texture: sheet.texture, position: Point(x: x, y: y)))
        }
    }
    
    public func draw(sprite: SpriteId, from spriteSheet: SpriteSheetId, at position: Point, scale: Float = 1.0, rotation: Angle = 0.0, flip: Bool = false) {
        self.draw(sprite: sprite, from: spriteSheet, x: position.x, y: position.y, scale: scale, rotation: rotation, flip: flip)
    }
    
    public func draw(image: ImageId, x: Float, y: Float, scale: Float = 1.0, rotation: Angle = 0.0, flip: Bool = false) {
        guard self.drawingPossible else {
            Log.graphics.warning("Drawing is not possible in this scope!")
            return
        }
        
        if let image = Resources.shared.image(from: image) {
            self.drawingCommands.append(.drawImage(image: image, position: Point(x: x, y: y)))
        }
    }
    
    public func draw(image: ImageId, at position: Point, scale: Float = 1.0, rotation: Angle = 0.0, flip: Bool = false) {
        self.draw(image: image, x: position.x, y: position.y, scale: scale, rotation: rotation, flip: flip)
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
        
        // FIXME: Implement text drawing
        Log.graphics.info("Drawing text not implemented yet!")
    }
    
    public func draw(text: String, at position: Point) {
        self.draw(text: text, x: position.x, y: position.y)
    }
}
