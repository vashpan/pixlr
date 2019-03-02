//
//  Font.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 02/03/2019.
//  Copyright © 2019 One Minute Games. All rights reserved.
//

import Foundation

// MARK: Helper types
public typealias FontId = Int

// MARK: Sprite definition
internal struct Font {
    internal let glyphs: [Character: Sprite]
    internal let texture: Texture
}
