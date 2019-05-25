//
//  MacKeyMapping.swift
//  Pixlr-macOS
//
//  Created by Konrad Kołakowski on 19/05/2019.
//  Copyright © 2019 One Minute Games. All rights reserved.
//

import Cocoa

internal final class MacKeyMapping {
    internal static func macKeyCodeToPixlrKeyCode(macKeyCode: UInt16) -> Key.Code {
        switch macKeyCode {
            case 0:   return .A
            case 1:   return .S
            case 2:   return .D
            case 3:   return .F
            case 4:   return .H
            case 5:   return .G
            case 6:   return .Z
            case 7:   return .X
            case 8:   return .C
            case 9:   return .V
            case 10:  return .paragraph // it's sometimes tilde on some keyboards
            case 11:  return .B
            case 12:  return .Q
            case 13:  return .W
            case 14:  return .E
            case 15:  return .R
            case 16:  return .Y
            case 17:  return .T
            case 18:  return .one
            case 19:  return .two
            case 20:  return .three
            case 21:  return .four
            case 22:  return .six
            case 23:  return .five
            case 24:  return .equal
            case 25:  return .nine
            case 26:  return .seven
            case 27:  return .minus
            case 28:  return .eight
            case 29:  return .zero
            case 30:  return .rightBracket
            case 31:  return .O
            case 32:  return .U
            case 33:  return .leftBracket
            case 34:  return .I
            case 35:  return .P
            case 36:  return .enter
            case 37:  return .L
            case 38:  return .J
            case 39:  return .apostrophe
            case 40:  return .K
            case 41:  return .semicolon
            case 42:  return .backslash
            case 43:  return .comma
            case 44:  return .slash
            case 45:  return .N
            case 46:  return .M
            case 47:  return .period
            case 48:  return .tab
            case 49:  return .space
            case 50:  return .tilde
            case 51:  return .backspace
            case 52:  return .keypadEnter
            case 53:  return .escape
            case 54:  return .fn
            case 55:  return .fn
            case 56:  return .shift
            case 57:  return .capsLock
            case 58:  return .alt
            case 59:  return .control
            case 60:  return .shift
            case 61:  return .alt
            case 62:  return .control
            case 63:  return .fn
            case 64:  return .F17
            case 65:  return .keypadPeriod
            case 66:  return .unknown
            case 67:  return .keypadMultiply
            case 68:  return .unknown
            case 69:  return .keypadPlus
            case 70:  return .unknown
            case 71:  return .keypadClearOrNumLock
            case 72:  return .unknown // volume up, but unused
            case 73:  return .unknown // volume down, but unused
            case 74:  return .unknown // mute, but unused
            case 75:  return .keypadDivide
            case 76:  return .keypadEnter
            case 77:  return .unknown
            case 78:  return .keypadMinus
            case 79:  return .F18
            case 80:  return .F19
            case 81:  return .keypadEquals
            case 82:  return .keypadZero
            case 83:  return .keypadOne
            case 84:  return .keypadTwo
            case 85:  return .keypadThree
            case 86:  return .keypadFour
            case 87:  return .keypadFive
            case 88:  return .keypadSix
            case 89:  return .keypadSeven
            case 90:  return .unknown
            case 91:  return .keypadEight
            case 92:  return .keypadNine
            case 93:  return .unknown // yen?
            case 94:  return .unknown // ro?
            case 95:  return .keypadPeriod
            case 96:  return .F5
            case 97:  return .F6
            case 98:  return .F7
            case 99:  return .F3
            case 100: return .F8
            case 101: return .F9
            case 102: return .unknown // eisu?
            case 103: return .F11
            case 104: return .unknown // kana?
            case 105: return .F13 // on PC it's print-screen
            case 106: return .F16
            case 107: return .F14 // in PC it's scroll lock
            case 108: return .unknown
            case 109: return .F10
            case 110: return .unknown // "menu" key on Windows
            case 111: return .F12
            case 112: return .unknown
            case 113: return .F15 // on PC it's pause
            case 114: return .unknown // on PC it's insert
            case 115: return .home
            case 116: return .pageUp
            case 117: return .delete
            case 118: return .F4
            case 119: return .end
            case 120: return .F2
            case 121: return .pageDown
            case 122: return .F1
            case 123: return .leftArrow
            case 124: return .rightArrow
            case 125: return .downArrow
            case 126: return .upArrow
            case 127: return .unknown // power on old keyboards

            default:
                return .unknown
        }
    }
}
