//
//  Config.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 18/11/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation

open class Config {
    // MARK: Types
    public enum ScreenScaleMode {
        case keepWidth, keepHeight, keepWidthAndHeight
    }
    
    // MARK: Screen
    open var screenSize: Size {
        return Size(width: 320.0, height: 240.0)
    }
    
    open var scaleMode: ScreenScaleMode {
        return .keepWidthAndHeight
    }
    
    // MARK: Initialization
    public init() {
        
    }
}
