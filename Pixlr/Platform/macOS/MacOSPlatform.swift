//
//  MacOSPlatform.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 12/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation
import AppKit

internal class MacOSPlatform: Platform {
    internal func startApp(with game: Game) {
        let app = PixlrApplication.shared
        let delegate = PixlrAppDelegate()
        
        app.delegate = delegate
        app.run()
    }
}

internal extension Pixlr {
    internal static var currentPlatform: Platform = MacOSPlatform()
}
