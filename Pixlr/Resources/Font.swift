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

// MARK: - Glyph definition
internal struct Glyph {
    internal let size: Size
    internal let uv: Point
}

// MARK: - Font definition
internal struct Font {
    // MARK: Properties
    internal let glyphs: [Character: Glyph]
    internal let texture: Texture
    
    internal let lineHeight: Int
    internal let spacing: Int
    internal let size: Int
}
