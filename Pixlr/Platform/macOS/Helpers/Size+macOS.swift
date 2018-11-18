//
//  Size+macOS.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 18/11/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import CoreGraphics

internal extension Size {
    // MARK: Properties
    internal var cgSize: CGSize {
        return CGSize(width: CGFloat(self.width), height: CGFloat(self.height))
    }
    
    // MARK: Initialization
    init(cgSize: CGSize) {
        self.init(width: Float(cgSize.width), height: Float(cgSize.height))
    }
}
