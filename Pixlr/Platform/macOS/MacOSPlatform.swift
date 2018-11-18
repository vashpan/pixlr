//
//  MacOSPlatform.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 12/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Foundation
import AppKit

// MARK: - macOS platform
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

// MARK: - Pixlr extension for macOS platform
internal extension Pixlr {
    internal static var currentPlatform: Platform = MacOSPlatform()
    internal static var renderer: Renderer = MetalRenderer()
}
