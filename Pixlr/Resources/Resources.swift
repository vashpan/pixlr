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
    
    internal var spriteSheets: [SpriteSheetId : SpriteSheet] = [:]
    
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
            dummySprites[n] = Sprite(size: Size(width: 16.0, height: 16.0), uv: Point(x: 0, y: 0))
        }
        
        self.spriteSheets[spriteSheetId] = SpriteSheet(sprites: dummySprites, texture: dummyTexture)
    }
    
    // MARK: Accessing resources
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
}
