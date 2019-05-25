//
//  Key.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 13/05/2019.
//  Copyright © 2019 One Minute Games. All rights reserved.
//

import Foundation

public struct Key {
    // MARK: Types
    public enum State {
        case down, up
    }
    
    public enum Code {
        case Q, W, E, R, T, Y, U, I, O, P, A, S, D, F, G, H, J, K, L, Z, X, C, V, B, N, M
        case one, two ,three, four, five, six, seven, eight, nine, zero
        case minus, equal
        case leftBracket, rightBracket
        case semicolon, apostrophe, slash
        case tilde, comma, period, backslash
        case paragraph
        case escape
        case F1, F2, F3, F4, F5, F6, F7, F8, F9, F10, F11, F12, F13, F14, F15, F16, F17, F18, F19
        case shift, control, alt, command, meta, fn, capsLock // modifiers
        case space, tab, backspace, enter, delete, home, end, pageUp, pageDown
        case leftArrow, upArrow, downArrow, rightArrow
        
        case keypadClearOrNumLock, keypadEquals, keypadDivide, keypadMultiply, keypadMinus, keypadPlus
        case keypadEnter, keypadPeriod
        case keypadZero, keypadOne, keypadTwo, keypadThree, keypadFour, keypadFive, keypadSix, keypadSeven, keypadEight, keypadNine
        
        case unknown
        
        // FIXME: add more (?)
    }
    
    // MARK: Properties
    public let code: Code
    public let modifiers: [Code]
    public let state: State
}
