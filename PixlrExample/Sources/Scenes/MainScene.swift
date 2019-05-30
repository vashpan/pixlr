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
    // MARK: Start
    override func onStart() {
        
    }
    
    // MARK: Drawing
    override func draw(on gfx: Graphics) {
        self.drawMenu(on: gfx)
    }
    
    private func drawMenu(on gfx: Graphics) {
        var nextButtonPos = Point(x: 20.0, y: 80)
        let buttonsSpacing: Float = 20.0
        
        // sprites
        gfx.draw(text: "SPRITES", using: FontIds.pressStart, at: nextButtonPos)
        nextButtonPos.y += buttonsSpacing
        
        // text
        gfx.draw(text: "TEXT", using: FontIds.pressStart, at: nextButtonPos)
        nextButtonPos.y += buttonsSpacing
        
        // sound & music
        gfx.draw(text: "SOUND & MUSIC", using: FontIds.pressStart, at: nextButtonPos)
        nextButtonPos.y += buttonsSpacing
        
        // input
        gfx.draw(text: "INPUT", using: FontIds.pressStart, at: nextButtonPos)
        nextButtonPos.y += buttonsSpacing
    }
}
