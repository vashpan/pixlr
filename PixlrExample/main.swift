//
//  main.swift
//  PixlrExample
//
//  Created by Konrad Kołakowski on 12/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation
import Pixlr

let log = Logger(subsystem: nil, level: .info)

final class PixlrExamples: Game {
    // MARK: Config
    final class ExamplesConfig: Config {
        override var targetScreenSize: Size {
            return Size(width: 320.0, height: 240.0)
        }
        
        override var scaleMode: Config.ScreenScaleMode {
            return .keepHeight
        }
    }
    
    // MARK: Game lifecycle
    override func start() {
        super.start()

        Resources.shared.loadFont(named: "press-start", into: FontIds.pressStart)
        Resources.shared.loadImage(named: "white-box", into: SpriteIds.whiteBox)
        
        Director.shared.start(with: MainScene(), game: self)
    }
    
    // MARK: Input
    override func onTouch(touches: [Touch]) {
        Director.shared.onTouch(touches: touches)
    }
    
    override func onKey(key: Key) {
        Director.shared.onKey(key: key)
    }
    
    override func onMouseMove(mouse: Mouse) {
        Director.shared.onMouseMove(mouse: mouse)
    }
    
    override func onMouseClick(mouse: Mouse) {
        Director.shared.onMouseClick(mouse: mouse)
    }

    // MARK: Updating & drawing
    override func draw(on gfx: Graphics) {
        Director.shared.draw(on: gfx)
    }
    
    override func update(dt: TimeInterval) {
        Director.shared.update(with: self, dt: dt)
    }
}

Pixlr.run(game: PixlrExamples(), with: PixlrExamples.ExamplesConfig())
