//
//  MainScene.swift
//  PixlrExample
//
//  Created by Konrad Kołakowski on 30/05/2019.
//  Copyright © 2019 One Minute Games. All rights reserved.
//

import Foundation
import Pixlr

final class MainScene: Scene {
    // MARK: Properties
    private var menu: [Button] = []
    
    // MARK: Start
    override func onStart() {
        var nextButtonPos = Point(x: 20.0, y: 80)
        let buttonsSpacing: Float = 20.0
        
        let spritesButton = Button(position: nextButtonPos, text: "SPRITES")
        spritesButton.event = { _ in self.showSpritesScene() }
        nextButtonPos.y += buttonsSpacing
        
        let textButton = Button(position: nextButtonPos, text: "TEXT")
        textButton.event = { _ in self.showTextScene() }
        nextButtonPos.y += buttonsSpacing
        
        let soundAndMusicButton = Button(position: nextButtonPos, text: "SOUND & MUSIC")
        soundAndMusicButton.event = { _ in self.showSoundAndMusicScene() }
        nextButtonPos.y += buttonsSpacing
        
        let inputButton = Button(position: nextButtonPos, text: "INPUT")
        inputButton.event = { _ in self.showInputScene() }
        
        self.menu = [spritesButton, textButton, soundAndMusicButton, inputButton]
    }
    
    // MARK: Actions
    private func showSpritesScene() {
        log.info("MainScene: showSpritesScene")
    }
    
    private func showTextScene() {
        log.info("MainScene: showTextScene")
    }
    
    private func showSoundAndMusicScene() {
        log.info("MainScene: showSoundAndMusicScene")
    }
    
    private func showInputScene() {
        log.info("MainScene: showInputScene")
    }
    
    // MARK: Drawing
    override func draw(on gfx: Graphics) {
        self.drawMenu(on: gfx)
    }
    
    private func drawMenu(on gfx: Graphics) {
        for button in self.menu {
            button.draw(on: gfx)
        }
    }
    
    // MARK: Input
    override func onTouch(touches: [Touch]) {
        for touch in touches {
            for button in self.menu {
                button.onTouch(touch: touch)
            }
        }
    }
    
    override func onMouseClick(mouse: Mouse) {
        for button in self.menu {
            button.onMouseClick(mouse: mouse)
        }
    }
    
    override func onMouseMove(mouse: Mouse) {
        for button in self.menu {
            button.onMouseMove(mouse: mouse)
        }
    }
}
