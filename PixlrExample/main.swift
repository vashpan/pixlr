//
//  main.swift
//  PixlrExample
//
//  Created by Konrad Kołakowski on 12/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation
import Pixlr

final class PixlrExamples: Game {
    final class ExamplesConfig: Config {
        override var targetScreenSize: Size {
            return Size(width: 320.0, height: 240.0)
        }
        
        override var scaleMode: Config.ScreenScaleMode {
            return .keepHeight
        }
    }
    
    override func start() {
        super.start()

        Resources.shared.loadFont(named: "press-start", into: FontIds.pressStart)
        
        
    }
    
    override func onTouch(touches: [Touch]) {

    }

    override func onMouseMove(mouse: Mouse) {

    }

    override func draw(on gfx: Graphics) {

    }
    
    override func update(dt: TimeInterval) {

    }
}

Pixlr.run(game: PixlrExamples(), with: PixlrExamples.ExamplesConfig())
