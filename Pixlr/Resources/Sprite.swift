//
//  Sprite.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 30/11/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation

// MARK: Helper types
public typealias SpriteId = Int

// MARK: Sprite definition
internal struct Sprite {
    internal let size: Size
    internal let uv: Point
}
