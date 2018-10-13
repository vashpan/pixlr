//
//  Pixlr.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 11/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation
import Cocoa

public class Pixlr {
    public static func run(game: Game) {
        Pixlr.currentPlatform.startApp(with: game)
    }
}
