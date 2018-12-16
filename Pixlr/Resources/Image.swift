//
//  Image.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 05/12/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation

// MARK: Helper types
public typealias ImageId = Int

// MARK: Image definition
internal struct Image {
    internal let size: Size
    internal let texture: Texture
    
    internal init(texture: Texture) {
        self.texture = texture
        self.size = texture.size
    }
}
