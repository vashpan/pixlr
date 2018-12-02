//
//  main.swift
//  PixlrExample
//
//  Created by Konrad Kołakowski on 12/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation
import Pixlr

final class ExampleGame: Game {
    override func start() {
        Resources.shared.loadSpriteSheet(named: "Dummy!", into: 0)
    }
    
    override func draw(on gfx: Graphics) {
        let screenSize = Pixlr.config.screenSize
        let spriteSize: Float = 16.0
        
        // upper left
        //self.drawSprite(x: 0, y: self.spriteSize)
        gfx.draw(sprite: 0, from: 0, x: 0, y: spriteSize)
        
        // upper right
        //self.drawSprite(x: width - self.spriteSize, y: self.spriteSize)
        gfx.draw(sprite: 0, from: 0, x: screenSize.width - spriteSize, y: spriteSize)
        
        // down left
        //self.drawSprite(x: 0, y: height)
        gfx.draw(sprite: 0, from: 0, x: 0, y: screenSize.height)
        
        // down right
        //self.drawSprite(x: width - self.spriteSize, y: height)
        gfx.draw(sprite: 0, from: 0, x: screenSize.width - spriteSize, y: screenSize.height)
        
        // center
        //self.drawSprite(x: (width  - self.spriteSize / 2.0) / 2.0,
        //                y: (height + self.spriteSize) / 2.0)
        gfx.draw(sprite: 0, from: 0,
                 x: (screenSize.width - spriteSize / 2.0) / 2.0,
                 y: (screenSize.height - spriteSize) / 2.0)
    }
}

Pixlr.run(game: ExampleGame())
