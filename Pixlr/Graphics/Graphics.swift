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
        case drawGlyph(glyph: Glyph, size: Size, texture: Texture, color: Color, transform: Matrix3)
        case drawImage(image: Image, color: Color, transform: Matrix3)
        case drawPixels(pixels: [Pixel])
    }
    
    // MARK: Properties
    private let renderer: Renderer
    
    private var drawingPossible = false
    private var drawingCommands: [DrawCommand] = []
    
    // MARK: Initialization
    internal init(renderer: Renderer) {
        self.renderer = renderer
    }
    
    // MARK: Helpers
    private func makeTransformMatrix(origin: Point, size: Size, pivot: Vector2, scale: Vector2, rotation: Angle) -> Matrix3 {
        // pivot in points
        let pivotInPoints = Vector2(x: pivot.x * size.width * scale.x, y: pivot.y * size.height * scale.y)
        
        // translate + rotation
        var transform = Matrix3(translation: origin) * Matrix3(rotation: rotation)
        
        // move by pivot after rotation
        transform = transform * Matrix3(translation: -pivotInPoints)
        
        // and scale...
        transform = transform * Matrix3(scale: scale)
        
        return transform
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
    public func draw(sprite spriteId: SpriteId, from spriteSheet: SpriteSheetId, at position: Point, pivot: Vector2 = Vector2(0.5), scale: Vector2 = Vector2(1.0), rotation: Angle = 0.0, color: Color = .white) {
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
        let transform = self.makeTransformMatrix(origin: position, size: sprite.size, pivot: pivot, scale: scale, rotation: rotation)
        
        // add drawing command
        self.drawingCommands.append(.drawSprite(sprite: sprite, texture: sheet.texture, color: color, transform: transform))
    }
    
    public func draw(image: ImageId, at position: Point, pivot: Vector2 = Vector2(0.5), scale: Vector2 = Vector2(1.0), rotation: Angle = 0.0, color: Color = .white) {
        guard self.drawingPossible else {
            Log.graphics.warning("Drawing is not possible in this scope!")
            return
        }
        
        guard let image = Resources.shared.image(from: image) else {
            return
        }
        
        // transform
        let transform = self.makeTransformMatrix(origin: position, size: image.size, pivot: pivot, scale: scale, rotation: rotation)
        
        // add drawing command
        self.drawingCommands.append(.drawImage(image: image, color: color, transform: transform))
    }
    
    public func draw(pixels: [Pixel]) {
        guard self.drawingPossible else {
            Log.graphics.warning("Drawing is not possible in this scope!")
            return
        }
        
        self.drawingCommands.append(.drawPixels(pixels: pixels))
    }
    
    public func draw(text: String, using fontId: FontId, at position: Point, scale: Vector2 = Vector2(1.0), color: Color = .white) {
        guard self.drawingPossible else {
            Log.graphics.warning("Drawing is not possible in this scope!")
            return
        }
        
        guard let font = Resources.shared.font(from: fontId) else {
            Log.graphics.error("Cannot find font \(fontId) ")
            return
        }
        
        let scaledGlyphSize = Size(width: font.glyphSize.width * scale.x, height: font.glyphSize.height * scale.y)
        
        var insertion = position
        for c in text {
            if c == " " {
                insertion.x += scaledGlyphSize.width
                continue
            }
            
            if let glyph = font.glyphs[c] {
                let transform = self.makeTransformMatrix(origin: insertion, size: font.glyphSize, pivot: Vector2(0.0), scale: scale, rotation: 0.0)
                self.drawingCommands.append(.drawGlyph(glyph: glyph, size: font.glyphSize, texture: font.texture, color: color, transform: transform))
                
                insertion.x += scaledGlyphSize.width
            }
        }
    }
}
