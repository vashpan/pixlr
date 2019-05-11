//
//  PixlrIOSAppDelegate.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 04/05/2019.
//  Copyright © 2019 One Minute Games. All rights reserved.
//

import UIKit

internal class PixlrIOSAppDelegate: NSObject, UIApplicationDelegate {
    internal var window: UIWindow?
    
    public func applicationDidFinishLaunching(_ application: UIApplication) {
        let screenRect = UIScreen.main.bounds
        self.window = UIWindow(frame: screenRect)
        
        // setup our view controller, depending on renderer
        // in the future we could get renderers from config
        let metalViewController = iOSMetalViewController(game: Pixlr.game,
                                                         targetGameScreenSize: Pixlr.config.targetScreenSize,
                                                         scaleMode: Pixlr.config.scaleMode)
        
        self.window?.rootViewController = metalViewController
        self.window?.makeKeyAndVisible()
    }
    
    public func applicationWillResignActive(_ application: UIApplication) {
        Pixlr.game.onAppPause()
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        Pixlr.game.onAppResume()
    }
    
    public func applicationWillTerminate(_ application: UIApplication) {
        Pixlr.game.onAppTerminate()
    }
}

