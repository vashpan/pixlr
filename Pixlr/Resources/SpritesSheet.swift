//
//  SpritesSheet.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 30/11/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation

// MARK: Helper types
public typealias SpriteSheetId = Int

// MARK: - SpriteSheet definition
internal struct SpriteSheet {
    // MARK: Properties
    internal let sprites: [SpriteId : Sprite]
    internal let texture: Texture
}
