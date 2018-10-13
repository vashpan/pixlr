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
    // MARK: Platform protocol
    internal func startApp(with game: Game) {
        let app = PixlrApplication.shared as! PixlrApplication
        let delegate = PixlrAppDelegate()
        
        app.createMainMenu()
        app.createMainWindow(title: self.appName)
        
        app.delegate = delegate
        app.run()
    }
    
    internal var appName: String {
        var result: String? = nil
        
        // first bundle display name
        result = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        
        // bundle name
        if result == nil {
            result = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        }
        
        // process name
        if result == nil {
            result = ProcessInfo.processInfo.processName
        }
        
        return result ?? ""
    }
}

internal extension Pixlr {
    internal static var currentPlatform: Platform = MacOSPlatform()
}
