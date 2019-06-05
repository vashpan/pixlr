//
//  Button.swift
//  PixlrExample
//
//  Created by Konrad Kołakowski on 02/06/2019.
//  Copyright © 2019 One Minute Games. All rights reserved.
//

import Foundation
import Pixlr

// FIXME: Add support for keyboard
// FIXME: Add support for highlighting button with white background if selected (button states?)
// FIXME: Add support for custom button size

final class Button {
    // MARK: Types
    private enum State {
        case normal, pressed
    }
    
    typealias ButtonEvent = (Button) -> Void
    
    // MARK: Properties
    private let position: Point
    private let size: Size
    private let text: String
    
    private var state: State
    
    var event: ButtonEvent?
    
    // MARK: Initialize
    init(position: Point, text: String) {
        self.position = position
        self.text = text
        self.size = Graphics.textSize(text: self.text, using: FontIds.pressStart)
        
        self.state = .normal
    }
    
    // MARK: Helpers
    private func hitTest(point: Point) -> Bool {
        if point.x >= position.x && point.y >= position.y {
            if point.x <= position.x + self.size.width && point.y <= position.y + self.size.height {
                return true
            }
        }
        
        return false
    }
    
    private func textColor(for state: State) -> Color {
        return state == .normal ? .white : .black
    }
    
    // MARK: Drawing
    func draw(on gfx: Graphics) {
        // box (if needed)
        if self.state == .pressed {
            let boxPosition = Point(x: self.position.x - 1.0, y: self.position.y - 1.0)
            gfx.draw(image: SpriteIds.whiteBox, at: boxPosition, pivot: .zero, scale: Vector2(x: (self.size.width + 4.0) / 8.0, y: 1))
        }
        
        // text
        gfx.draw(text: self.text, using: FontIds.pressStart, at: self.position, color: self.textColor(for: self.state))
    }
    
    // MARK: Input
    func onTouch(touch: Touch) {
        if self.hitTest(point: touch.position) {
            switch touch.state {
                case .began:
                    self.state = .pressed
                case .ended:
                    if self.state == .pressed {
                        self.event?(self)
                        self.state = .normal
                    }
                default:
                    break
            }
        } else {
            self.state = .normal // cancel if we moved out of hit box
        }
    }
    
    func onMouseClick(mouse: Mouse) {
        if self.hitTest(point: mouse.position) {
            switch mouse.clickState(for: .left) {
                case .down:
                    self.state = .pressed
                case .up:
                    if self.state == .pressed {
                        self.event?(self)
                        self.state = .normal
                    }
            }
        } else {
            self.state = .normal // cancel if we moved out of hit box
        }
    }
    
    func onMouseMove(mouse: Mouse) {
        // cancel if we moved out of hit box
        if mouse.clickState(for: .left) == .down {
            if self.hitTest(point: mouse.position) {
                self.state = .pressed
            } else {
                self.state = .normal
            }
        }
    }
}
