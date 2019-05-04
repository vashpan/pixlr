//
//  iOSPlatform.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 03/05/2019.
//  Copyright © 2019 One Minute Games. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

// MARK: - iOS Platform
internal class iOSPlatform: Platform {
    // MARK: Properties
    internal var renderer: Renderer? = nil
    
    internal var appName: String {
        var result: String? = nil
        
        // first bundle display name
        result = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        
        // bundle name
        if result == nil {
            result = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        }

        return result ?? ""
    }
    
    // MARK: App lifecycle
    func startApp(with game: Game) {
        UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(PixlrIOSAppDelegate.self))
    }
    
    // MARK: Loading resources
    func loadTexture(name: String) -> Texture? {
        Log.resources.error("Loading textures not implemented yet on iOS!")
        return nil
    }
    
}

// MARK: Pixlr extension for iOS platform
extension Pixlr {
    internal static var currentPlatform: Platform = iOSPlatform()
}
