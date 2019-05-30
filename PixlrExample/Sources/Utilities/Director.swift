//
//  Director.swift
//  PixlrExample
//
//  Created by Konrad Kołakowski on 28/05/2019.
//  Copyright © 2019 One Minute Games. All rights reserved.
//

import Foundation
import Pixlr

final class Director {
    // MARK: Properties
    private var currentScene: Scene?
    public private(set) var screenSize: Size = .zero
    
    static let shared = Director()
    
    // MARK: Updating & drawing
    func update(with game: Game, dt: TimeInterval) {
        self.screenSize = game.screenSize
        
        self.currentScene?.update(dt: dt)
    }
    
    func draw(on gfx: Graphics) {
        self.currentScene?.draw(on: gfx)
    }
    
    // MARK: Input
    func onTouch(touches: [Touch]) {
        self.currentScene?.onTouch(touches: touches)
    }
    
    func onKey(key: Key) {
        self.currentScene?.onKey(key: key)
    }
    
    func onMouseMove(mouse: Mouse) {
        self.currentScene?.onMouseMove(mouse: mouse)
    }
    
    func onMouseClick(mouse: Mouse) {
        self.currentScene?.onMouseClick(mouse: mouse)
    }
    
    // MARK: Managing scenes
    func replaceScene(with scene: Scene) {
        self.currentScene?.onEnd()
        self.currentScene = scene
        scene.onStart()
    }
    
    func start(with scene: Scene, game: Game) {
        guard self.currentScene == nil else {
            log.error("Director: Can't start director with scene currently running!")
            return
        }
        
        self.screenSize = game.screenSize
        
        self.currentScene = scene
        scene.onStart()
    }
}
