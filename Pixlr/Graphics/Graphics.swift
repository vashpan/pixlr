//
//  Graphics.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 18/11/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation

public class Graphics {
    // MARK: Types
    internal enum DrawCommand {
        case drawSprite(sprite: Sprite, texture: Texture, color: Color, transform: Matrix3)
        case drawImage(image: Image, color: Color, transform: Matrix3)
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
    public func draw(sprite spriteId: SpriteId, from spriteSheet: SpriteSheetId, at position: Point, scale: Vector2 = Vector2(1.0), rotation: Angle = 0.0, color: Color = .white) {
        guard self.drawingPossible else {
            Log.graphics.warning("Drawing is not possible in this scope!")
            return
        }
        
        guard let sheet = Resources.shared.spriteSheet(from: spriteSheet) else {
            return
        }
        
        guard let sprite = sheet.sprites[spriteId] else {
            Log.graphics.error("Cannot find sprite \(spriteId) ")
            return
        }
        
        // transform
        let translate = Matrix3(translation: position)
        let scale = Matrix3(scale: scale)
        let rotate = Matrix3(rotation: rotation)
        let transform = translate * scale * rotate
        
        // add drawing command
        self.drawingCommands.append(.drawSprite(sprite: sprite, texture: sheet.texture, color: color, transform: transform))
    }
    
    public func draw(sprite spriteId: SpriteId, from spriteSheet: SpriteSheetId, at position: Point, scale: Float = 1.0, rotation: Angle = 0.0, color: Color = .white) {
        self.draw(sprite: spriteId, from: spriteSheet, at: position, scale: Vector2(x: scale, y: scale), rotation: rotation, color: color)
    }
    
    public func draw(image: ImageId, at position: Point, scale: Vector2 = Vector2(1.0), rotation: Angle = 0.0, color: Color = .white) {
        guard self.drawingPossible else {
            Log.graphics.warning("Drawing is not possible in this scope!")
            return
        }
        
        guard let image = Resources.shared.image(from: image) else {
            return
        }
        
        // transform
        let translate = Matrix3(translation: position)
        let scale = Matrix3(scale: scale)
        let rotate = Matrix3(rotation: rotation)
        let transform = translate * scale * rotate
        
        // add drawing command
        self.drawingCommands.append(.drawImage(image: image, color: color, transform: transform))
    }
    
    public func draw(image: ImageId, at position: Point, scale: Float = 1.0, rotation: Angle = 0.0, color: Color = .white) {
        self.draw(image: image, at: position, scale: Vector2(x: scale, y: scale), rotation: rotation, color: color)
    }
    
    public func draw(pixels: [Pixel]) {
        guard self.drawingPossible else {
            Log.graphics.warning("Drawing is not possible in this scope!")
            return
        }
        
        self.drawingCommands.append(.drawPixels(pixels: pixels))
    }
    
    public func draw(text: String, at position: Point) {
        guard self.drawingPossible else {
            Log.graphics.warning("Drawing is not possible in this scope!")
            return
        }
        
        // FIXME: Implement text drawing
        Log.graphics.info("Drawing text not implemented yet!")
    }
}
