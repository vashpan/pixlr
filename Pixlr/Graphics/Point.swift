//
//  Point.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 18/11/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation

public struct Point: Equatable {
    public let x: Float
    public let y: Float
    
    public static var zero: Point {
        return Point(x: 0.0, y: 0.0)
    }
}
