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
        
        guard let renderer = Pixlr.renderer as? MetalRenderer else {
            Log.graphics.error("macOS platform can use only Metal renderer!")
            return
        }
        
        let frame = NSRect(origin: .zero, size: mainWindow.frame.size)
        self.metalView = MTKView(frame: frame, device: defaultMetalDevice)
        
        renderer.metalKitView = self.metalView
        renderer.setupRenderer()
        
        self.view = self.metalView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.metalView.delegate = self
    }
}

// MARK: - MTKViewDelegate functions
extension MetalViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        Pixlr.renderer.viewportWillChange(to: Size(cgSize: size))
    }
    
    func draw(in view: MTKView) {
        Pixlr.graphics.beginFrame()
        Pixlr.game.draw(on: Pixlr.graphics)
        Pixlr.graphics.endFrame()
    }
}
