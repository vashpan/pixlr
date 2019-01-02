//
//  main.swift
//  PixlrExample
//
//  Created by Konrad Kołakowski on 12/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation
import Pixlr

struct SadFace {
    let pos: Point
    let rotation: Angle
    let scale: Float
    
    static let size = Size(width: 16.0, height: 16.0)
    static let imageId = ImageId(0)
    
    init(position: Point, rotation: Angle, scale: Float) {
        self.pos = position
        self.rotation = rotation
        self.scale = scale
    }
}

final class ExampleGame: Game {
    private var faces: [SadFace] = []
    
    override func start() {
        Resources.shared.loadImage(named: "sad-face", into: SadFace.imageId)
        
        // start with some faces
        let screenSize = Pixlr.config.screenSize
        let numberOfFaces = 32
        for _ in 0...numberOfFaces {
            let position = Point(x: Float.random(in: 0.0...screenSize.width - SadFace.size.width),
                                 y: Float.random(in: 0.0...screenSize.height - SadFace.size.height))
            
            let rotation = Angle.random(in: 0...Angle.twoPi)
            let scale = Float.random(in: 0.2...3.0)
            
            let sadFace = SadFace(position: position, rotation: rotation, scale: scale)
            
            self.faces.append(sadFace)
        }
    }
    
    override func draw(on gfx: Graphics) {
        for face in self.faces {
            gfx.draw(image: SadFace.imageId, at: face.pos, scale: Vector2(face.scale), rotation: face.rotation)
        }
    }
}

Pixlr.run(game: ExampleGame())
