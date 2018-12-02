//
//  Size.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 18/11/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation

public struct Size {
    public let width: Float
    public let height: Float
    
    public static var zero: Size {
        return Size(width: 0.0, height: 0.0)
    }
}
