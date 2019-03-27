//
//  Color+macOS.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 07/01/2019.
//  Copyright © 2019 One Minute Games. All rights reserved.
//

import CoreGraphics

extension Color {
    // MARK: Properties
    internal var simdColor: vector_float4 {
        return vector_float4(Float(self.r) / 255.0, Float(self.g) / 255.0, Float(self.b) / 255.0, Float(self.a) / 255.0)
    }
}
