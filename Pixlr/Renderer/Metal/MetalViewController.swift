//
//  MetalViewController.swift
//  Pixlr
//
//  Created by Konrad Kołakowski on 13/10/2018.
//  Copyright © 2018 One Minute Games. All rights reserved.
//

import Cocoa
import MetalKit

internal class MetalViewController: NSViewController {
    // MARK: Properties
    private var renderer: MetalRenderer!
    private var metalView: MTKView!
    
    // MARK: Initialization & overrides
    internal init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    override func loadView() {
        guard let mainWindow = NSApp.mainWindow else {
            return
        }
        
        guard let defaultMetalDevice = MTLCreateSystemDefaultDevice() else {
            Log.graphics.error("Metal is not supported!")
            return
        }
        
        let frame = NSRect(origin: .zero, size: mainWindow.frame.size)
        self.metalView = MTKView(frame: frame, device: defaultMetalDevice)
        
        guard let renderer = MetalRenderer(metalKitView: self.metalView) else {
            Log.graphics.error("Cannot create Metal renderer!")
            return
        }
        
        self.view = self.metalView
        self.renderer = renderer
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.metalView.delegate = self.renderer
    }
}
