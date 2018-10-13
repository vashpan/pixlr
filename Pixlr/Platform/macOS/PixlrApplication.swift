//
//  PixlrApplication.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 13/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Cocoa

internal class PixlrApplication: NSApplication {
    // MARK: Creating menus
    private func addToMainMenu(title: String, menu: NSMenu) {
        guard let mainMenu = self.mainMenu else {
            return
        }
        
        let menuItem = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        menuItem.submenu = menu
        mainMenu.addItem(menuItem)
    }
    
    internal func createMainMenu() {
        self.mainMenu = NSMenu()
        
        // application menu
        let appName = Pixlr.currentPlatform.appName
        let appMenu = NSMenu()
        
        appMenu.addItem(withTitle: "About \(appName)", action: #selector(orderFrontStandardAboutPanel(_:)), keyEquivalent: "")
        
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: "Hide \(appName)", action: #selector(hide(_:)), keyEquivalent: "h")
        
        let hideOthersMenuItem = appMenu.addItem(withTitle: "Hide Others",
                                                 action: #selector(hideOtherApplications(_:)),
                                                 keyEquivalent: "")
        hideOthersMenuItem.keyEquivalentModifierMask = [.option, .command]
        
        appMenu.addItem(withTitle: "Show All", action: #selector(unhideAllApplications(_:)), keyEquivalent: "")
        
        appMenu.addItem(NSMenuItem.separator())
        appMenu.addItem(withTitle: "Quit \(appName)", action: #selector(terminate(_:)), keyEquivalent: "q")
        
        self.addToMainMenu(title: "", menu: appMenu)
        
        // window menu
        let windowMenu = NSMenu(title: "Window")
        
        windowMenu.addItem(withTitle: "Minimize", action: #selector(NSWindow.performMiniaturize(_:)), keyEquivalent: "m")
        
        windowMenu.addItem(withTitle: "Zoom", action: #selector(NSWindow.performZoom(_:)), keyEquivalent: "")
        
        self.addToMainMenu(title: "Window", menu: windowMenu)
        self.windowsMenu = windowMenu
    }
    
    // MARK: Creating window
    internal func createMainWindow(title: String) {
        // FIXME: Center & load according to config, including fullscreen
        let size = CGSize(width: 640.0, height: 480.0)
        let position = CGPoint(x: 100.0, y: 100.0)
        let rect = NSRect(origin: position, size: size)
        
        let view = NSView(frame: rect)
        
        let window = NSWindow(contentRect: rect, styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: true)
        window.title = title
        window.contentView = view
        window.makeKeyAndOrderFront(nil)
    }
}
