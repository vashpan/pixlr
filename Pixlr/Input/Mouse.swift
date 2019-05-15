//
//  Mouse.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 12/05/2019.
//  Copyright © 2019 One Minute Games. All rights reserved.
//

import Foundation

public struct Mouse {
    // MARK: Types
    public enum Button {
        case left, right
    }
    
    public enum ClickState {
        case down, up
    }
    
    // MARK: Properties
    public let position: Point
    private let state: [Button : ClickState]
    
    // MARK: Helpers
    public func clickState(for button: Button) -> ClickState {
        return self.state[button] ?? .up
    }
}
