//
//  Scene.swift
//  PixlrExample
//
//  Created by Konrad Kołakowski on 28/05/2019.
//  Copyright © 2019 One Minute Games. All rights reserved.
//

import Foundation
import Pixlr

class Scene {
    // MARK: Lifecycle
    open func onStart() {
        
    }
    
    open func onEnd() {
        
    }
    
    // MARK: Drawing & updating
    open func draw(on gfx: Graphics) {
        
    }
    
    open func update(dt: TimeInterval) {
        
    }
    
    // MARK: Input
    open func onTouch(touches: [Touch]) {
        
    }
    
    open func onKey(key: Key) {
        
    }
    
    open func onMouseMove(mouse: Mouse) {
        
    }
    
    open func onMouseClick(mouse: Mouse) {
        
    }
}
