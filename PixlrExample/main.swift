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
        return .keepHeight
    }
}

struct SpriteIds {
    static let sadFace = ImageId(0)
    static let happyFace = ImageId(1)
    static let dodgerFace = ImageId(2)
}

struct FontIds {
    static let pressStart = FontId(1)
}

class Face {
    let image: ImageId
    
    var pos: Point
    var rotation: Angle
    let scale: Float
    let pivot: Vector2
    let color: Color
    
    var direction: Vector2
    
    static let radius: Float = 16.0
    
    private static let rotationSpeed: Angle = 1.5 // 1.5rad/s
    
    init(face: ImageId? = nil, position: Point, pivot: Vector2, rotation: Angle, scale: Float) {
        self.image = face ?? [SpriteIds.sadFace, SpriteIds.happyFace, SpriteIds.dodgerFace].randomElement()!
        
        self.pos = position
        self.pivot = pivot
        self.rotation = rotation
        self.scale = scale
        self.color = Color(r: UInt8.random(in: 0...255), g: UInt8.random(in: 0...255), b: UInt8.random(in: 0...255), a: 255)
        
        self.direction = Vector2(x: Float.random(in: -15.0...15.0), y: Float.random(in: -15.0...15.0))
    }
    
    func update(dt: TimeInterval, screenSize: Size) {
        // update
        self.rotation += Face.rotationSpeed * Float(dt)
        self.pos = self.pos + self.direction * Float(dt)
        
        // bounces
        if self.pos.x <= 0.0 || self.pos.y >= screenSize.height - Face.radius * self.scale ||
           self.pos.x >= screenSize.width - Face.radius * self.scale || self.pos.y <= 0.0 {
            self.direction = self.direction.inverse
        }
    }
}

final class ExampleGame: Game {
    private var faces: [Face] = []
    
    override func start() {
        super.start()
        
        Resources.shared.loadImage(named: "sad-face", into: SpriteIds.sadFace)
        Resources.shared.loadImage(named: "happy-face", into: SpriteIds.happyFace)
        Resources.shared.loadImage(named: "dodger-face", into: SpriteIds.dodgerFace)
        Resources.shared.loadFont(named: "press-start", into: FontIds.pressStart)
        
        // start with some faces
        let numberOfFaces = 32
        for _ in 0..<numberOfFaces {
            let position = Point(x: Float.random(in: 0.0...self.screenSize.width - Face.radius),
                                 y: Float.random(in: 0.0...self.screenSize.height - Face.radius))

            let rotation = Angle.random(in: 0...Angle.twoPi)
            let scale = Float.random(in: 0.4...2.0)

            let sadFace = Face(position: position, pivot: Vector2(0.5), rotation: rotation, scale: scale)

            self.faces.append(sadFace)
        }
        
        // COMMENTED FOR MORE GRANULAR TESTS:
        
//        let position = Point(x: 100.0/*Float.random(in: 0.0...self.screenSize.width - SadFace.radius)*/,
//                             y: 100.0/*Float.random(in: 0.0...self.screenSize.height - SadFace.radius)*/)
        
//        // test 1
//        let sadFace1 = SadFace(face: SpriteIds.dodgerFace, position: Point(x: 100.0, y: 100.0), pivot: Vector2(1.0), rotation: Angle(degrees: 0), scale: 1.0)
//        self.faces.append(sadFace1)
//
//        // test 2
//        let sadFace2 = SadFace(face: SpriteIds.dodgerFace, position: Point(x: 150.0, y: 100.0), pivot: Vector2(1.0), rotation: Angle(degrees: 0), scale: 1.0)
//        self.faces.append(sadFace2)
//
//        // test 3
//        let sadFace3 = SadFace(face: SpriteIds.sadFace, position: Point(x: 200.0, y: 100.0), pivot: Vector2(1.0), rotation: Angle(degrees: 0), scale: 1.0)
//        self.faces.append(sadFace3)
    }
    
    override func draw(on gfx: Graphics) {
        for face in self.faces {
            gfx.draw(image: face.image, at: face.pos, pivot: face.pivot, scale: Vector2(face.scale), rotation: face.rotation, color: face.color)
        }
        
        gfx.draw(text: "Hello World!\nWelcome to PIXLR!", using: FontIds.pressStart, at: Point(x: 100.0, y: 100.0))
        gfx.draw(text: "Boom!", using: FontIds.pressStart, at: Point(x: 100.0, y: 200.0)) { (c, i) -> (Vector2, Vector2, Color, Angle) in
            return (Vector2.zero, Vector2(1.2), Color.init(r: UInt8.random(in: 0...255), g: UInt8.random(in: 0...255), b: UInt8.random(in: 0...255)), Angle(0.0))
        }
    }
    
    override func update(dt: TimeInterval) {
        for face in self.faces {
            face.update(dt: dt, screenSize: self.screenSize)
        }
    }
}

Pixlr.run(game: ExampleGame(), with: SadFaceConfig())
