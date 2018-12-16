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
    
    private let currentGame: Game
    private var graphics: Graphics!
    private var renderer: MetalRenderer!
    
    private let targetGameScreenSize: Size
    
    // MARK: Initialization & overrides
    internal init(game: Game, targetGameScreenSize: Size) {
        self.currentGame = game
        self.targetGameScreenSize = targetGameScreenSize
        
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
        self.view = self.metalView
        
        guard let newRenderer = MetalRenderer(metalKitView: self.metalView, targetGameScreenSize: self.targetGameScreenSize) else {
            Log.graphics.error("Cannot create Metal renderer!")
            return
        }
        
        guard let platform = Pixlr.currentPlatform as? MacOSPlatform else {
            return
        }
        
        platform.renderer = newRenderer
        
        self.renderer = newRenderer
        self.graphics = Graphics(renderer: self.renderer, screenSize: self.targetGameScreenSize)
        
        self.mtkView(self.metalView, drawableSizeWillChange: self.metalView.drawableSize)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.metalView.delegate = self
        
        // start game
        self.currentGame.start()
    }
}

// MARK: - MTKViewDelegate functions
extension MetalViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        self.renderer.viewportWillChange(to: Size(cgSize: size))
    }
    
    func draw(in view: MTKView) {
        self.graphics.beginFrame()
        self.currentGame.draw(on: self.graphics)
        self.graphics.endFrame()
    }
}
