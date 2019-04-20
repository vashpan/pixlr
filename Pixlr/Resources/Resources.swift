//
//  Resources.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 30/11/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation

public final class Resources {
    // MARK: Properties
    public static let shared = Resources()
    
    internal var spriteSheets: [SpriteSheetId: SpriteSheet] = [:]
    internal var images: [ImageId: Image] = [:]
    internal var fonts: [FontId: Font] = [:]
    
    // MARK: Loading resources
    public func loadSpriteSheet(named spriteSheetName: String, into spriteSheetId: SpriteSheetId) {
        guard !self.spriteSheets.keys.contains(spriteSheetId) else {
            Log.resources.error("Sprite sheet of id: \(spriteSheetId) is already loaded!")
            return
        }
        
        // parse sprite sheet file
        guard let spriteSheetUrl = Bundle.main.url(forResource: spriteSheetName, withExtension: "json") else {
            Log.resources.error("Sprite sheet of name: \(spriteSheetName) cannot be found!")
            return
        }
        
        guard let jsonData = FileManager.default.contents(atPath: spriteSheetUrl.path) else {
            Log.resources.error("Cannot load atlas JSON data for sprite sheet of name: \(spriteSheetName)!")
            return
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments), let frames = json as? [String:Any] else {
            Log.resources.error("Cannot parse atlas JSON data for sprite sheet of name: \(spriteSheetName)!")
            return
        }
        
        var sprites = [SpriteId: Sprite]()
        var currentSpriteId: SpriteId = 0
        if let framesArray = frames["frames"] as? [Any] {
            for spriteFrameObject in framesArray {
                if let frame = spriteFrameObject as? [String:Any] {
                    let x = frame["x"] as? Int
                    let y = frame["y"] as? Int
                    let w = frame["w"] as? Int
                    let h = frame["h"] as? Int
                    
                    let sprite = Sprite(size: Size(width: Float(w ?? 0), height: Float(h ?? 0)),
                                        uv: Point(x: Float(x ?? 0), y: Float(y ?? 0)))
                    sprites[currentSpriteId] = sprite
                    currentSpriteId += 1
                }
            }
        }
        
        // Add load sprites sheet texture
        guard let spritesTexture = Pixlr.currentPlatform.loadTexture(name: spriteSheetName) else {
            Log.resources.error("Can't load sprites texture: \(spriteSheetName)!")
            return
        }
        
        self.spriteSheets[spriteSheetId] = SpriteSheet(sprites: sprites, texture: spritesTexture)
    }
    
    public func loadImage(named imageName: String, into imageId: ImageId) {
        guard !self.images.keys.contains(imageId) else {
            Log.resources.error("Image of id: \(imageId) is already loaded!")
            return
        }
        
        guard let texture = Pixlr.currentPlatform.loadTexture(name: imageName) else {
            Log.resources.error("Can't load texture: \(imageName) as image of id: \(imageId)!")
            return
        }
        
        self.images[imageId] = Image(texture: texture)
    }
    
    public func loadFont(named fontName: String, into fontId: FontId) {
        guard !self.fonts.keys.contains(fontId) else {
            Log.resources.error("Font of id: \(fontId) is already loaded!")
            return
        }
        
        // open font data file
        guard let fontDataUrl = Bundle.main.url(forResource: fontName, withExtension: "json") else {
            Log.resources.error("Font of name: \(fontName) cannot be found!")
            return
        }
        
        guard let jsonData = FileManager.default.contents(atPath: fontDataUrl.path) else {
            Log.resources.error("Cannot load font JSON data for font of name: \(fontName)!")
            return
        }
        
        guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: .allowFragments), let font = json as? [String:Any] else {
            Log.resources.error("Cannot parse font JSON data for font of name: \(fontName)!")
            return
        }
        
        // open font image file
        guard let fontTexture = Pixlr.currentPlatform.loadTexture(name: fontName) else {
            Log.resources.error("Cannot load font texture for font of name: \(fontName)!")
            return
        }
        
        // parse font info
        guard let fontInfo = font["fontInfo"] as? [String:Int] else {
            Log.resources.error("No font info section in JSON for font of name: \(fontName)!")
            return
        }
        
        guard let fontLineHeight = fontInfo["lineHeight"] else {
            Log.resources.error("No font line height info in JSON for font of name: \(fontName)!")
            return
        }
        
        guard let fontSize = fontInfo["size"] else {
            Log.resources.error("No font size info in JSON for font of name: \(fontName)!")
            return
        }
        
        let fontSpacing = fontInfo["spacing"] ?? 0
        
        // parse glyphs
        var glyphs = [Character: Glyph]()
        if let glyphsArray = font["glyphs"] as? [Any] {
            for glyphObject in glyphsArray {
                if let glyph = glyphObject as? [String:Any] {
                    let x = glyph["x"] as? Int
                    let y = glyph["y"] as? Int
                    let w = glyph["w"] as? Int
                    let h = glyph["h"] as? Int
                    
                    if let char = glyph["char"] as? String, char.count == 1 {
                        let sprite = Glyph(size: Size(width: Float(w ?? 0), height: Float(h ?? 0)),
                                             uv: Point(x: Float(x ?? 0), y: Float(y ?? 0)))
                        glyphs[Character(char)] = sprite
                    } else {
                        Log.resources.warning("No character, for specified glyph! Skipping...")
                    }
                }
            }
        }
        
        self.fonts[fontId] = Font(glyphs: glyphs,
                                  texture: fontTexture,
                                  lineHeight: fontLineHeight,
                                  spacing: fontSpacing,
                                  size: fontSize)
    }
    
    // MARK: Accessing resources
    internal func spriteSheet(from spriteSheetId: SpriteSheetId) -> SpriteSheet? {
        guard let spriteSheet = self.spriteSheets[spriteSheetId] else {
            Log.resources.warning("No sprite sheet of id: \(spriteSheetId) loaded!")
            return nil
        }
        
        return spriteSheet
    }
    
    internal func sprite(from spriteSheetId: SpriteSheetId, id spriteId: SpriteId) -> Sprite? {
        guard let spriteSheet = self.spriteSheets[spriteSheetId] else {
            Log.resources.warning("No sprite sheet of id: \(spriteSheetId) loaded!")
            return nil
        }
        
        guard let sprite = spriteSheet.sprites[spriteId] else {
            Log.resources.warning("No sprite of id: \(spriteId) is present in sprite sheet: \(spriteSheetId)!")
            return nil
        }
        
        return sprite
    }
    
    internal func image(from imageId: ImageId) -> Image? {
        guard let image = self.images[imageId] else {
            Log.resources.warning("No image of id: \(imageId) loaded!")
            return nil
        }
        
        return image
    }
    
    internal func font(from fontId: FontId) -> Font? {
        guard let font = self.fonts[fontId] else {
            Log.resources.warning("No font of id: \(fontId) loaded!")
            return nil
        }
        
        return font
    }
}
