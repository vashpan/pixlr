//
//  Touch.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 11/05/2019.
//  Copyright © 2019 One Minute Games. All rights reserved.
//

import Foundation

public struct Touch {
    // MARK: Types
    public enum State {
        case began, moved, ended
    }
    
    // MARK: Properties
    public let position: Point
    public let state: State
}
