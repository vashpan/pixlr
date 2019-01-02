//
//  Math.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 02/01/2019.
//  Copyright © 2019 One Minute Games. All rights reserved.
//
//  Portions from:
//
//
//  VectorMath.swift
//  VectorMath
//
//  Version 0.3.3
//
//  Created by Nick Lockwood on 24/11/2014.
//  Copyright (c) 2014 Nick Lockwood. All rights reserved.
//
//  Distributed under the permissive MIT License
//  Get the latest version from here:
//
//  https://github.com/nicklockwood/VectorMath
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation

public typealias Point = Vector2

// MARK: Float additional utilities
public extension Float {
    public static let halfPi = pi / 2
    public static let quarterPi = pi / 4
    public static let twoPi = pi * 2
    public static let degreesPerRadian = 180 / pi
    public static let radiansPerDegree = pi / 180
    public static let epsilon: Float = 0.0001
    
    public static func ~= (lhs: Float, rhs: Float) -> Bool {
        return Swift.abs(lhs - rhs) < .epsilon
    }
    
    public var sign: Float {
        return self > 0 ? 1 : -1
    }
}

// MARK: Size
public struct Size {
    public let width: Float
    public let height: Float
    
    public static let zero = Size(width: 0.0, height: 0.0)
    
    public init(width: Float, height: Float) {
        self.width = width
        self.height = height
    }
}

// MARK: 2 dimensional vector
public struct Vector2 {
    // MARK: Properties
    public var x: Float
    public var y: Float
    
    public static let zero = Vector2(x: 0.0, y: 0.0)
    
    public var hashValue: Int {
        return self.x.hashValue &+ self.y.hashValue
    }
    
    public var lengthSquared: Float {
        return self.x * self.x + self.y * self.y
    }
    
    public var length: Float {
        return sqrt(self.lengthSquared)
    }
    
    public var inverse: Vector2 {
        return -self
    }
    
    // MARK: Initialization
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    public init(_ x: Float, _ y: Float) {
        self.init(x: x, y: y)
    }
    
    // MARK: Functions
    public func dot(_ v: Vector2) -> Float {
        return self.x * v.x + self.y * v.y
    }
    
    public func cross(_ v: Vector2) -> Float {
        return self.x * v.y - self.y * v.x
    }
    
    public mutating func normalize() {
        let lengthSquared = self.lengthSquared
        if lengthSquared ~= 0 || lengthSquared ~= 1 {
            return
        }
        
        let length = sqrt(lengthSquared)
        self.x /= length
        self.y /= length
    }
    
    public func normalized() -> Vector2 {
        let lengthSquared = self.lengthSquared
        if lengthSquared ~= 0 || lengthSquared ~= 1 {
            return self
        }
        
        return self / sqrt(lengthSquared)
    }
    
    public func rotated(by radians: Float) -> Vector2 {
        let cs = cos(radians)
        let sn = sin(radians)
        return Vector2(self.x * cs - self.y * sn,
                       self.x * sn + self.y * cs)
    }
    
    public func rotated(by radians: Float, around pivot: Vector2) -> Vector2 {
        return (self - pivot).rotated(by: radians) + pivot
    }
    
    public func angle(with v: Vector2) -> Float {
        if self == v {
            return 0.0
        }
        
        let t1 = normalized()
        let t2 = v.normalized()
        let cross = t1.cross(t2)
        let dot = max(-1.0, min(1.0, t1.dot(t2)))
        
        return atan2(cross, dot)
    }
    
    public func interpolated(with v: Vector2, by t: Float) -> Vector2 {
        return self + (v - self) * t
    }
    
    // MARK: Operators
    public static prefix func - (v: Vector2) -> Vector2 {
        return Vector2(-v.x, -v.y)
    }
    
    public static func + (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(lhs.x + rhs.x, lhs.y + rhs.y)
    }
    
    public static func - (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(lhs.x - rhs.x, lhs.y - rhs.y)
    }
    
    public static func * (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(lhs.x * rhs.x, lhs.y * rhs.y)
    }
    
    public static func * (lhs: Vector2, rhs: Float) -> Vector2 {
        return Vector2(lhs.x * rhs, lhs.y * rhs)
    }
    
    public static func * (lhs: Vector2, rhs: Matrix3) -> Vector2 {
        return Vector2(
            lhs.x * rhs.m11 + lhs.y * rhs.m21 + rhs.m31,
            lhs.x * rhs.m12 + lhs.y * rhs.m22 + rhs.m32
        )
    }
    
    public static func / (lhs: Vector2, rhs: Vector2) -> Vector2 {
        return Vector2(lhs.x / rhs.x, lhs.y / rhs.y)
    }
    
    public static func / (lhs: Vector2, rhs: Float) -> Vector2 {
        return Vector2(lhs.x / rhs, lhs.y / rhs)
    }
    
    public static func == (lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
    
    public static func ~= (lhs: Vector2, rhs: Vector2) -> Bool {
        return lhs.x ~= rhs.x && lhs.y ~= rhs.y
    }
}

// MARK: 3x3 matrix
public struct Matrix3 {
    // MARK: Properties
    public var m11, m12, m13: Float
    public var m21, m22, m23: Float
    public var m31, m32, m33: Float
    
    public static let identity = Matrix3(1, 0, 0, 0, 1, 0, 0, 0, 1)
    
    public var hashValue: Int {
        var hash = self.m11.hashValue &+ self.m12.hashValue &+ self.m13.hashValue
        hash = hash &+ self.m21.hashValue &+ self.m22.hashValue &+ self.m23.hashValue
        hash = hash &+ self.m31.hashValue &+ self.m32.hashValue &+ self.m33.hashValue
        
        return hash
    }
    
    public var adjugate: Matrix3 {
        return Matrix3(m22 * m33 - m23 * m32,
                       m13 * m32 - m12 * m33,
                       m12 * m23 - m13 * m22,
                       m23 * m31 - m21 * m33,
                       m11 * m33 - m13 * m31,
                       m13 * m21 - m11 * m23,
                       m21 * m32 - m22 * m31,
                       m12 * m31 - m11 * m32,
                       m11 * m22 - m12 * m21)
    }
    
    public var determinant: Float {
        return (m11 * m22 * m33 + m12 * m23 * m31 + m13 * m21 * m32) -
               (m13 * m22 * m31 + m11 * m23 * m32 + m12 * m21 * m33)
    }
    
    public var transpose: Matrix3 {
        return Matrix3(m11, m21, m31, m12, m22, m32, m13, m23, m33)
    }
    
    public var inverse: Matrix3 {
        return self.adjugate * (1 / self.determinant)
    }
    
    // MARK: Initialization
    public init(_ m11: Float, _ m12: Float, _ m13: Float,
                _ m21: Float, _ m22: Float, _ m23: Float,
                _ m31: Float, _ m32: Float, _ m33: Float) {
        self.m11 = m11
        self.m12 = m12
        self.m13 = m13
        self.m21 = m21
        self.m22 = m22
        self.m23 = m23
        self.m31 = m31
        self.m32 = m32
        self.m33 = m33
    }
    
    public init(scale s: Vector2) {
        self.init(s.x, 0.0, 0.0,
                  0.0, s.y, 0.0,
                  0.0, 0.0, 1.0)
    }
    
    public init(translation t: Vector2) {
        self.init(1.0, 0.0, 0.0,
                  0.0, 1.0, 0.0,
                  t.x, t.y, 1.0)
    }
    
    public init(rotation radians: Float) {
        let c = cos(radians)
        let s = sin(radians)
        
        self.init(c,   s,   0.0,
                  -s,  c,   0.0,
                  0.0, 0.0, 1.0)
    }
    
    // MARK: Functions
    public func interpolated(with m: Matrix3, by t: Float) -> Matrix3 {
        return Matrix3(m11 + (m.m11 - m11) * t,
                       m12 + (m.m12 - m12) * t,
                       m13 + (m.m13 - m13) * t,
                       m21 + (m.m21 - m21) * t,
                       m22 + (m.m22 - m22) * t,
                       m23 + (m.m23 - m23) * t,
                       m31 + (m.m31 - m31) * t,
                       m32 + (m.m32 - m32) * t,
                       m33 + (m.m33 - m33) * t)
    }
    
    // MARK: Operators
    public static prefix func - (m: Matrix3) -> Matrix3 {
        return m.inverse
    }
    
    public static func * (lhs: Matrix3, rhs: Matrix3) -> Matrix3 {
        return Matrix3(lhs.m11 * rhs.m11 + lhs.m21 * rhs.m12 + lhs.m31 * rhs.m13,
                       lhs.m12 * rhs.m11 + lhs.m22 * rhs.m12 + lhs.m32 * rhs.m13,
                       lhs.m13 * rhs.m11 + lhs.m23 * rhs.m12 + lhs.m33 * rhs.m13,
                       lhs.m11 * rhs.m21 + lhs.m21 * rhs.m22 + lhs.m31 * rhs.m23,
                       lhs.m12 * rhs.m21 + lhs.m22 * rhs.m22 + lhs.m32 * rhs.m23,
                       lhs.m13 * rhs.m21 + lhs.m23 * rhs.m22 + lhs.m33 * rhs.m23,
                       lhs.m11 * rhs.m31 + lhs.m21 * rhs.m32 + lhs.m31 * rhs.m33,
                       lhs.m12 * rhs.m31 + lhs.m22 * rhs.m32 + lhs.m32 * rhs.m33,
                       lhs.m13 * rhs.m31 + lhs.m23 * rhs.m32 + lhs.m33 * rhs.m33)
    }
    
    public static func * (lhs: Matrix3, rhs: Vector2) -> Vector2 {
        return rhs * lhs
    }
    
    public static func * (lhs: Matrix3, rhs: Float) -> Matrix3 {
        return Matrix3(lhs.m11 * rhs, lhs.m12 * rhs, lhs.m13 * rhs,
                       lhs.m21 * rhs, lhs.m22 * rhs, lhs.m23 * rhs,
                       lhs.m31 * rhs, lhs.m32 * rhs, lhs.m33 * rhs)
    }
    
    public static func == (lhs: Matrix3, rhs: Matrix3) -> Bool {
        if lhs.m11 != rhs.m11 { return false }
        if lhs.m12 != rhs.m12 { return false }
        if lhs.m13 != rhs.m13 { return false }
        if lhs.m21 != rhs.m21 { return false }
        if lhs.m22 != rhs.m22 { return false }
        if lhs.m23 != rhs.m23 { return false }
        if lhs.m31 != rhs.m31 { return false }
        if lhs.m32 != rhs.m32 { return false }
        if lhs.m33 != rhs.m33 { return false }
        return true
    }
    
    public static func ~= (lhs: Matrix3, rhs: Matrix3) -> Bool {
        if !(lhs.m11 ~= rhs.m11) { return false }
        if !(lhs.m12 ~= rhs.m12) { return false }
        if !(lhs.m13 ~= rhs.m13) { return false }
        if !(lhs.m21 ~= rhs.m21) { return false }
        if !(lhs.m22 ~= rhs.m22) { return false }
        if !(lhs.m23 ~= rhs.m23) { return false }
        if !(lhs.m31 ~= rhs.m31) { return false }
        if !(lhs.m32 ~= rhs.m32) { return false }
        if !(lhs.m33 ~= rhs.m33) { return false }
        return true
    }
}
