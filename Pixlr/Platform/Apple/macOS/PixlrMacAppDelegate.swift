//
//  AppDelegate.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 11/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Cocoa

internal class PixlrMacAppDelegate: NSObject, NSApplicationDelegate {
    private var window: NSWindow!
    
    public func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.window = NSApp.mainWindow
        
        // setup our view controller, depending on renderer
        // in the future we could get renderers from config
        let metalViewController = MacMetalViewController(game: Pixlr.game,
                                                         targetGameScreenSize: Pixlr.config.targetScreenSize,
                                                         scaleMode: Pixlr.config.scaleMode)
        
        self.window.contentViewController = metalViewController
    }

    public func applicationWillTerminate(_ aNotification: Notification) {
        
    }
    
    public func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
