//
//  main.swift
//  PixlrExample
//
//  Created by Konrad Kołakowski on 12/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation
import Pixlr

final class SadFaceConfig: Config {
    override var targetScreenSize: Size {
        return Size(width: 320.0, height: 240.0)
    }
    
    override var scaleMode: Config.ScreenScaleMode {
        return .keepWidth
    }
}

class SadFace {
    var pos: Point
    var rotation: Angle
    let scale: Float
    let pivot: Vector2
    let color: Color
    
    var direction: Vector2
    
    static let radius: Float = 16.0
    static let imageId = ImageId(0)
    
    private static let rotationSpeed: Angle = 1.5 // 1.5rad/s
    
    init(position: Point, pivot: Vector2, rotation: Angle, scale: Float) {
        self.pos = position
        self.pivot = pivot
        self.rotation = rotation
        self.scale = scale
        self.color = Color(r: UInt8.random(in: 0...255), g: UInt8.random(in: 0...255), b: UInt8.random(in: 0...255), a: 255)
        
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
        super.start()
        
        Resources.shared.loadImage(named: "sad-face", into: SadFace.imageId)
        
        // start with some faces
        let numberOfFaces = 32
        for _ in 0..<numberOfFaces {
            let position = Point(x: Float.random(in: 0.0...self.screenSize.width - SadFace.radius),
                                 y: Float.random(in: 0.0...self.screenSize.height - SadFace.radius))

            let rotation = Angle.random(in: 0...Angle.twoPi)
            let scale = Float.random(in: 0.4...2.0)

            let sadFace = SadFace(position: position, pivot: Vector2(0.5), rotation: rotation, scale: scale)

            self.faces.append(sadFace)
        }
        
        // COMMENTED FOR MORE GRANULAR TESTS:
        
        //let position = Point(x: 100.0/*Float.random(in: 0.0...self.screenSize.width - SadFace.radius)*/,
        //                     y: 100.0/*Float.random(in: 0.0...self.screenSize.height - SadFace.radius)*/)
        
        // test 1
        //let sadFace1 = SadFace(position: position, pivot: Vector2(1.0), rotation: Angle(degrees: 0), scale: 1.0)
        //self.faces.append(sadFace1)
        
        // test 2
        //let sadFace2 = SadFace(position: position, pivot: Vector2(x: 0.4, y: 0.4), rotation: Angle(degrees: 0), scale: 2.0)
        //self.faces.append(sadFace2)
    }
    
    override func draw(on gfx: Graphics) {
        for face in self.faces {
            gfx.draw(image: SadFace.imageId, at: face.pos, pivot: face.pivot, scale: Vector2(face.scale), rotation: face.rotation, color: face.color)
        }
    }
    
    override func update(dt: TimeInterval) {
        for face in self.faces {
            face.update(dt: dt, screenSize: self.screenSize)
        }
    }
}

Pixlr.run(game: ExampleGame(), with: SadFaceConfig())
