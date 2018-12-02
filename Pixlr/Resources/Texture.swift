//
//  Texture.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 30/11/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation

internal struct Texture {
    // MARK: Types
    internal enum Format {
        case rgba8, bgra8, argb8
    }
    
    // MARK: Properties
    internal let size: Size
    internal let data: Data
    
    internal let format: Format
    
    // MARK: Initialization
    init(data: Data, size: Size, format: Format = .rgba8) {
        self.size = size
        self.format = format
        self.data = data
    }
}
