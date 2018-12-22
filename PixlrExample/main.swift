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
    private struct Sprites {
        static let sadFace = ImageId(0)
    }
    
    override func start() {
        Resources.shared.loadImage(named: "sad-face", into: Sprites.sadFace)
    }
    
    override func draw(on gfx: Graphics) {
        let screenSize = Pixlr.config.screenSize
        let sadFaceSize: Float = 16.0
        
        // upper left
        //self.drawSprite(x: 0, y: self.spriteSize)
        gfx.draw(image: Sprites.sadFace, x: 0, y: sadFaceSize)
        
        // upper right
        //self.drawSprite(x: width - self.spriteSize, y: self.spriteSize)
        gfx.draw(image: Sprites.sadFace, x: screenSize.width - sadFaceSize, y: sadFaceSize)
        
        // down left
        //self.drawSprite(x: 0, y: height)
        gfx.draw(image: Sprites.sadFace, x: 0, y: screenSize.height)
        
        // down right
        //self.drawSprite(x: width - self.spriteSize, y: height)
        gfx.draw(image: Sprites.sadFace, x: screenSize.width - sadFaceSize, y: screenSize.height)
        
        // center
        gfx.draw(image: Sprites.sadFace,
                 x: (screenSize.width - sadFaceSize / 2.0) / 2.0,
                 y: (screenSize.height - sadFaceSize) / 2.0)
    }
}

Pixlr.run(game: ExampleGame())
