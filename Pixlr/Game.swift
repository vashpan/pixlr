//
//  Game.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 12/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation

open class Game: NSObject {
    // MARK: Properties
    public internal(set) var screenSize: Size
    
    // MARK: Initialization
    public override init() {
        self.screenSize = .zero
    }
    
    // MARK: Game lifecycle
    open func start() {
        // some checks
        guard self.screenSize != Size.zero else {
            Log.global.error("Game: screen size not set!?")
            return
        }
    }
    
    open func onAppPause() {
        
    }
    
    open func onAppResume() {
        
    }
    
    open func onAppTerminate() {
        
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
