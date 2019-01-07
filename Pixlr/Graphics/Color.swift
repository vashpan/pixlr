//
//  Color.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 18/11/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation

public struct Color {
    // MARK: Properties
    public let r: UInt8
    public let g: UInt8
    public let b: UInt8
    public let a: UInt8
    
    // MARK: Initialization
    init(r: UInt8, g: UInt8, b: UInt8, a: UInt8 = 255) {
        self.r = r
        self.g = g
        self.b = b
        self.a = a
    }
    
    init(floatR: Float, floatG: Float, floatB: Float, floatA: Float = 1.0) {
        self.init(r: UInt8(floatR * 255.0), g: UInt8(floatG * 255.0), b: UInt8(floatB * 255.0), a: UInt8(floatA * 255.0))
    }
    
    // MARK: Predefined colors
    public static let clear = Color(r: 255, g: 255, b: 255, a: 0)
    
    public static let black = Color(r: 0, g: 0, b: 0)
    public static let gray = Color(r: 128, g: 128, b: 128)
    public static let silver = Color(r: 192, g: 192, b: 192)
    public static let white = Color(r: 255, g: 255, b: 255)
    public static let maroon = Color(r: 128, g: 0, b: 0)
    public static let red = Color(r: 255, g: 0, b: 0)
    public static let olive = Color(r: 128, g: 128, b: 0)
    public static let yellow = Color(r: 255, g: 255, b: 0)
    public static let green = Color(r: 0, g: 128, b: 0)
    public static let lime = Color(r: 0, g: 255, b: 0)
    public static let teal = Color(r: 0, g: 125, b: 125)
    public static let aqua = Color(r: 0, g: 255, b: 255)
    public static let navy = Color(r: 0, g: 0, b: 128)
    public static let blue = Color(r: 0, g: 0, b: 255)
    public static let purple = Color(r: 128, g: 0, b: 128)
    public static let fuchsia = Color(r: 255, g: 0, b: 255)
}
