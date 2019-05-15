//
//  Vector+Apple.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 15/05/2019.
//  Copyright © 2019 One Minute Games. All rights reserved.
//

import CoreGraphics

extension Vector2 {
    // MARK: Properties
    internal var cgPoint: CGPoint {
        return CGPoint(x: Double(self.x), y: Double(self.y))
    }
    
    // MARK: Initialization
    init(cgPoint: CGPoint) {
        self.init(Float(cgPoint.x), Float(cgPoint.y))
    }
}

