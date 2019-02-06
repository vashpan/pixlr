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
                if let spriteFrameDict = spriteFrameObject as? [String:Any] {
                    if let frame = spriteFrameDict["frame"] as? [String:Int] {
                        let sprite = Sprite(size: Size(width: Float(frame["w"] ?? 0), height: Float(frame["h"] ?? 0)),
                                            uv: Point(x: Float(frame["x"] ?? 0), y: Float(frame["y"] ?? 0)))
                        sprites[currentSpriteId] = sprite
                        currentSpriteId += 1
                    }
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
}
