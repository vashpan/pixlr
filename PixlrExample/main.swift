//
//  main.swift
//  PixlrExample
//
//  Created by Konrad Kołakowski on 12/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation
import Pixlr

class SadFace {
    var pos: Point
    var rotation: Angle
    let scale: Float
    
    var direction: Vector2
    
    static let radius: Float = 16.0
    static let imageId = ImageId(0)
    
    private static let rotationSpeed: Angle = 0.1 // 0.1r/s
    
    init(position: Point, rotation: Angle, scale: Float) {
        self.pos = position
        self.rotation = rotation
        self.scale = scale
        
        self.direction = Vector2(x: Float.random(in: -15.0...15.0), y: Float.random(in: -15.0...15.0))
    }
    
    func update(dt: TimeInterval, screenSize: Size) {
        // update
        self.rotation += SadFace.rotationSpeed * Float(dt)
        self.pos = self.pos + self.direction * Float(dt)
        
        // bounces
        if self.pos.x <= 0.0 || self.pos.y >= screenSize.height - SadFace.radius * self.scale ||
           self.pos.x >= screenSize.width - SadFace.radius * self.scale || self.pos.y <= 0.0 {
            self.direction = self.direction.inverse
        }
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
            let position = Point(x: Float.random(in: 0.0...screenSize.width - SadFace.radius),
                                 y: Float.random(in: 0.0...screenSize.height - SadFace.radius))
            
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
    
    override func update(dt: TimeInterval) {
        let screenSize = Pixlr.config.screenSize
        
        for face in self.faces {
            face.update(dt: dt, screenSize: screenSize)
        }
    }
}

Pixlr.run(game: ExampleGame())
