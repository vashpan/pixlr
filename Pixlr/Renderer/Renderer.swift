//
//  Renderer.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 18/11/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation

internal protocol Renderer {
    func viewportWillChange(realSize: Size, gameSize: Size)
    func performDrawCommands(commands: [Graphics.DrawCommand])
}
