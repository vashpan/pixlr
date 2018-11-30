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
    public func loadSpriteSheet(named spriteSheetName: String, into id: SpriteSheetId) {
        Log.resources.error("Loading sprite sheets not implemented yet!")
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
