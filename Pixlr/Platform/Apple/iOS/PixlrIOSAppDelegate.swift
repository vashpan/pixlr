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
        
        // FIXME: Replace this placeholder VC with IOSMetalViewController
        let placeholderVc = UIViewController()
        placeholderVc.view.backgroundColor = .green
        
        self.window?.rootViewController = placeholderVc
        self.window?.makeKeyAndVisible()
    }
    
    public func applicationWillTerminate(_ application: UIApplication) {
        
    }
}

