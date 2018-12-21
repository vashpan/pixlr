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
        
        Log.resources.warning("Loading sprite sheets not implemented yet! Dummy sprite sheet will be loaded!")
        
        // creating dummy sprite sheet (with 10 sprites)
        let dummyTexture = Texture(data: Data(), size: Size(width: 512, height: 512))
        var dummySprites: [SpriteId : Sprite] = [:]
        for n in 0...10 {
            dummySprites[n] = Sprite(size: Size(width: 16.0, height: 16.0), uv: .zero)
        }
        
        self.spriteSheets[spriteSheetId] = SpriteSheet(sprites: dummySprites, texture: dummyTexture)
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
